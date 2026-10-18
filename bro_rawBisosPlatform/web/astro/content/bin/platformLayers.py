#!/usr/bin/env python

"""Snapshot this platform's layers as content/data/platformLayers.json, for platform.here.

Read-only. Four layers, from the bottom up:

  box        --- the hardware or virtualized resource: its type and its profile
  os         --- the Debian release and its profile (headless, xfce, vnc-xfce, ...)
  bisos      --- BISOS on this OS: addresses, and where /bisos/platform and /bisos/site lead
  evolution  --- how far this BISOS has evolved: RawBisos, RawBisosCBMs, Sited-BISOS

Each layer is a summary plus a list of items (label, value, source), and the pages render whatever
items there are: adding a fact is adding one item here. Facts come from facter (as bisos.facter's
CMDB does) where it has them, and from small checks of our own where it does not.

Usage: platformLayers.py [--cbmBase DIR] [--out FILE]
"""

import argparse
import datetime
import json
import os
import pathlib
import re
import shutil
import socket
import subprocess
import sys

from bisos.banna import tcpPorts

thisDir = pathlib.Path(__file__).resolve().parent
defaultOut = thisDir.parent / "data" / "platformLayers.json"   # content/data/, read by site/ as @content
defaultCbmBase = pathlib.Path("/bisos/platform/sys/cbm")

rawBisosPlatform = "bro_rawBisosPlatform"
rawBisosSite = "bro_rawBisosSite"

# DMI system vendors (or product names) that mean the box is a virtual machine.
vmVendors = ("QEMU", "KVM", "VMware", "Xen", "Microsoft Corporation", "innotek", "Amazon EC2",
             "Google", "DigitalOcean", "OpenStack", "Parallels", "Bochs", "oVirt", "Hetzner")

# Desktop sessions, by the package that provides them, in the order they are checked.
desktopSessions = (
    ("xfce4-session", "xfce"),
    ("gnome-shell", "gnome"),
    ("plasma-desktop", "kde"),
    ("cinnamon", "cinnamon"),
    ("mate-session-manager", "mate"),
    ("lxqt-session", "lxqt"),
    ("lxsession", "lxde"),
)
vncServers = ("tigervnc-standalone-server", "tightvncserver", "x11vnc", "turbovnc")
hostingServices = ("libvirtd", "docker", "podman", "containerd")


def _run(*cmd: str) -> str:
    try:
        return subprocess.run(cmd, capture_output=True, text=True, timeout=30).stdout.strip()
    except (OSError, subprocess.SubprocessError):
        return ""


def _read(path: str) -> str:
    try:
        return pathlib.Path(path).read_text().strip()
    except OSError:
        return ""


def _item(label: str, value, source: str, detail: str = "") -> dict:
    return {"label": label, "value": value if value not in (None, "") else "unknown",
            "source": source, "detail": detail}


def _facts() -> dict:
    if not shutil.which("facter"):
        return {}
    names = ["virtual", "processors", "memory.system", "os", "kernelrelease", "dmi",
             "networking.primary", "networking.interfaces", "mountpoints"]
    out = _run("facter", "--json", *names)
    try:
        return json.loads(out) if out else {}
    except json.JSONDecodeError:
        return {}


def _installed(pkgs) -> list[str]:
    out = _run("dpkg-query", "-W", "-f", "${Package} ${db:Status-Status}\n", *pkgs)
    return [line.split()[0] for line in out.splitlines() if line.endswith(" installed")]


def _active(unit: str) -> bool:
    return _run("systemctl", "is-active", unit) == "active"


#
# Box
#

def _privileged() -> bool:
    """Every capability the kernel knows of is effective for PID 1."""
    m = re.search(r"^CapEff:\s*([0-9a-f]+)", _read("/proc/1/status"), re.MULTILINE)
    lastCap = _read("/proc/sys/kernel/cap_last_cap")
    if not (m and lastCap.isdigit()):
        return False
    full = (1 << (int(lastCap) + 1)) - 1
    return int(m.group(1), 16) & full == full


def _cgroupLimits() -> tuple[str, str]:
    """(cpu, memory) limits of this cgroup, or "" when unlimited. cgroup v2, then v1."""
    cpu = mem = ""
    cpuMax = _read("/sys/fs/cgroup/cpu.max")
    if cpuMax:
        quota, _, period = cpuMax.partition(" ")
        if quota != "max":
            cpu = f"{int(quota) / int(period):g} CPUs"
    else:
        quota = _read("/sys/fs/cgroup/cpu/cpu.cfs_quota_us")
        period = _read("/sys/fs/cgroup/cpu/cpu.cfs_period_us")
        if quota.lstrip("-").isdigit() and int(quota) > 0 and period.isdigit():
            cpu = f"{int(quota) / int(period):g} CPUs"
    memMax = _read("/sys/fs/cgroup/memory.max") or _read("/sys/fs/cgroup/memory/memory.limit_in_bytes")
    if memMax.isdigit() and int(memMax) < (1 << 60):
        mem = f"{int(memMax) / (1 << 30):.1f} GiB"
    return cpu, mem


def boxLayer(facts: dict) -> dict:
    container = _run("systemd-detect-virt", "--container")
    container = "" if container in ("", "none") else container
    vendor = _read("/sys/class/dmi/id/sys_vendor") or facts.get("dmi", {}).get("manufacturer", "")
    product = _read("/sys/class/dmi/id/product_name") or facts.get("dmi", {}).get("product", {}).get("name", "")
    pid1 = _read("/proc/1/comm")

    # The machine under any container: a VM or bare metal.
    if container:
        underVm = any(v.lower() in f"{vendor} {product}".lower() for v in vmVendors) \
            and not product.endswith(".metal")
    else:
        vm = _run("systemd-detect-virt", "--vm")
        underVm = vm not in ("", "none")
    machine = f"{vendor} {product}".strip()
    hosting = [s for s in hostingServices if _active(s)]
    if underVm:
        machineType = "VM"
    else:
        machineType = "Host" if hosting else "rawMetal"

    if container == "docker":
        boxType = "PrivDocker" if _privileged() else "Docker"
    elif container == "podman":
        boxType = "PodmanSysd" if pid1 == "systemd" else "Podman"
    elif container:
        boxType = container
    else:
        boxType = machineType

    summary = boxType
    if container:
        summary += f", on a {machineType}" + (f" ({machine})" if machine else "")
    elif machine:
        summary += f" ({machine})"

    procs = facts.get("processors", {})
    models = sorted(set(procs.get("models", [])))
    mem = facts.get("memory.system", {})
    root = facts.get("mountpoints", {}).get("/", {})
    cpuLimit, memLimit = _cgroupLimits()
    shared = " --- shared with the host" if container else ""

    links = []
    for name, iface in sorted(facts.get("networking.interfaces", {}).items()):
        if name == "lo" or not iface.get("ip"):
            continue
        links.append(f"{name} {iface['ip']}/{_prefixLen(iface.get('netmask', ''))}")

    items = [
        _item("Type", boxType, "systemd-detect-virt; /proc/1/status CapEff; /proc/1/comm",
              "privileged: every capability is effective" if boxType == "PrivDocker" else ""),
    ]
    if container:
        items.append(_item("Runs on", f"{machineType}" + (f" --- {machine}" if machine else ""),
                           "/sys/class/dmi/id (the machine under the container)"))
    elif machine:
        items.append(_item("Machine", machine, "/sys/class/dmi/id"))
    if machineType == "Host" and not container:
        items.append(_item("Hosts", ", ".join(hosting), "systemctl is-active"))
    items += [
        _item("CPU", ", ".join(models), "facter processors.models"),
        _item("Cores", f"{procs.get('count', '?')} threads, {procs.get('cores', '?')} cores per socket{shared}"
              + (f"; limited to {cpuLimit}" if cpuLimit else ""), "facter processors; cgroup cpu"),
        _item("RAM", f"{mem.get('total', '?')}{shared}" + (f"; limited to {memLimit}" if memLimit else ""),
              "facter memory.system; cgroup memory"),
        _item("Disk", f"{root.get('size', '?')} {root.get('filesystem', '')} at /, "
              f"{root.get('available', '?')} free{shared}", "facter mountpoints./"),
        _item("Network links", ", ".join(links), "facter networking.interfaces"),
    ]
    return {"id": "box", "title": "Box", "subtitle": "hardware or virtualized resource",
            "summary": summary, "items": items, "inContainer": bool(container)}


def _prefixLen(netmask: str) -> str:
    try:
        return str(sum(bin(int(octet)).count("1") for octet in netmask.split(".")))
    except ValueError:
        return "?"


#
# OS
#

def osLayer(facts: dict, inContainer: bool) -> dict:
    distro = facts.get("os", {}).get("distro", {})
    description = distro.get("description") or _read("/etc/os-release")
    release = distro.get("release", {}).get("full") or _read("/etc/debian_version")
    codename = distro.get("codename", "")
    arch = facts.get("os", {}).get("architecture", "")

    sessions = _installed([pkg for pkg, _ in desktopSessions])
    desktop = next((name for pkg, name in desktopSessions if pkg in sessions), "")
    vnc = _installed(vncServers)
    if not desktop:
        profile = "headless"
    elif vnc:
        profile = f"vnc-{desktop}"
    else:
        profile = desktop
    vncUnits = [u for u in ("vncserver", "novnc") if _active(u)]

    items = [
        _item("Debian release", f"{release} ({codename})" if codename else release,
              "facter os.distro; /etc/debian_version"),
        _item("Distribution", description, "facter os.distro.description"),
        _item("Architecture", arch, "facter os.architecture"),
        _item("Kernel", facts.get("kernelrelease", "") + (" --- the host's" if inContainer else ""),
              "facter kernelrelease"),
        _item("Profile", profile, "dpkg: desktop session and VNC server packages",
              ", ".join(sessions + vnc)),
    ]
    if vncUnits:
        items.append(_item("Desktop services", ", ".join(f"{u}.service" for u in vncUnits),
                           "systemctl is-active"))
    return {"id": "os", "title": "OS", "subtitle": "Debian and its profile",
            "summary": f"Debian {release} ({codename}), {profile}" if codename else f"Debian {release}, {profile}",
            "items": items}


#
# BISOS
#

def _linkEnd(path: str) -> str:
    p = pathlib.Path(path)
    if not p.exists():
        return ""
    return os.readlink(p) if p.is_symlink() else str(p)


def bisosLayer(facts: dict) -> dict:
    hereEntries = tcpPorts.hereEntries()
    hereIps = sorted((ip for ip, _, _ in hereEntries), key=lambda ip: [int(x) for x in ip.split(".")])
    primary = facts.get("networking.primary", "")
    primaryIp = facts.get("networking.interfaces", {}).get(primary, {}).get("ip", "")
    platformEnd = _linkEnd("/bisos/platform")
    siteEnd = _linkEnd("/bisos/site")
    items = [
        _item("Host name", socket.gethostname(), "socket.gethostname()"),
        _item("Primary address", f"{primaryIp} ({primary})" if primaryIp else "", "facter networking.primary"),
        _item(".here addresses", f"{len(hereEntries)} names on {hereIps[0]} -- {hereIps[-1]}" if hereIps else "",
              "bisos.banna tcpPorts.hereEntries(); /etc/hosts"),
        _item("/bisos/platform", platformEnd, "readlink /bisos/platform"),
        _item("/bisos/site", siteEnd, "readlink /bisos/site"),
    ]
    return {"id": "bisos", "title": "BISOS", "subtitle": "BISOS on this OS",
            "summary": f"platform {pathlib.Path(platformEnd).name or '?'}, site {pathlib.Path(siteEnd).name or '?'}",
            "items": items, "platformEnd": platformEnd, "siteEnd": siteEnd}


#
# BISOS-Evolution
#

def _cbmsMaterialized(cbmBase: pathlib.Path) -> tuple[int, int]:
    """(enabled leaves, of which the last outcome was ok)."""
    enabled = ok = 0
    for spcs in cbmBase.glob("*/*/*/cbmProc.spcs"):
        if _read(str(spcs.parent / "cbmProc.control")) != "enabled":
            continue
        enabled += 1
        lines = _read(str(spcs.parent / "cbmProc.status")).splitlines()
        ok += bool(lines) and lines[-1].endswith(" ok")
    return enabled, ok


def evolutionLayer(bisos: dict, cbmBase: pathlib.Path) -> dict:
    raw = pathlib.Path(bisos["platformEnd"]).name == rawBisosPlatform \
        and pathlib.Path(bisos["siteEnd"]).name in (rawBisosSite, "")
    enabled, ok = _cbmsMaterialized(cbmBase)
    if not raw:
        current = "Sited-BISOS"
    elif ok:
        current = "RawBisosCBMs"
    else:
        current = "RawBisos"
    stages = [
        {"name": "RawBisos", "test": f"/bisos/platform leads to {rawBisosPlatform}"},
        {"name": "RawBisosCBMs", "test": "RawBisos, and at least one enabled CBM leaf last materialized ok"},
        {"name": "Sited-BISOS", "test": "/bisos/platform or /bisos/site leads to a real BPO, not bro_rawBisos"},
    ]
    names = [s["name"] for s in stages]
    for s in stages:
        s["current"] = s["name"] == current
        s["reached"] = names.index(s["name"]) <= names.index(current)
    items = [
        _item("Stage", current, "/bisos/platform and /bisos/site link ends; cbmProc.control/.status"),
        _item("CBMs", f"{ok} of {enabled} enabled leaves last materialized ok", f"{cbmBase}/*/*/*/"),
    ]
    return {"id": "evolution", "title": "BISOS-Evolution", "subtitle": "how far this BISOS has evolved",
            "summary": current, "items": items, "stages": stages}


def layers(cbmBase: pathlib.Path) -> list[dict]:
    facts = _facts()
    box = boxLayer(facts)
    bisos = bisosLayer(facts)
    return [box, osLayer(facts, box["inContainer"]), bisos, evolutionLayer(bisos, cbmBase)]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--cbmBase", type=pathlib.Path, default=defaultCbmBase)
    parser.add_argument("--out", type=pathlib.Path, default=defaultOut)
    args = parser.parse_args()

    snapshot = {
        "generatedAt": datetime.datetime.now().astimezone().isoformat(timespec="seconds"),
        "host": socket.gethostname(),
        "facter": bool(shutil.which("facter")),
        "layers": layers(args.cbmBase),   # bottom up
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(snapshot, indent=2) + "\n")
    print(f"{args.out}: " + "; ".join(f"{l['title']}: {l['summary']}" for l in snapshot["layers"]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
