#!/usr/bin/env python

"""Snapshot this platform's CBM tree as content/data/capabilities.json, for platform.here.

Read-only. For every leaf under /bisos/platform/sys/cbm/<realm>/<capabilityType>/<name>/ that has a
cbmProc.spcs, it records the gate (cbmProc.control), the last line of cbmProc.status, the CBS the leaf
points at, the .here name, IP and port from bisos.banna, and the HTTP status of http://<name>.here/
as probed now. cbmProc.spcs is parsed as text, not executed. The order is the walk's
(branchesOrdered of the type's ftoBranchProc.spcs), then by name.

The site is a snapshot: rerun this (cbm/platform-assemble.cs -i siteBuild runs every content/bin
script) to refresh it.

Usage: platformCapabilities.py [--cbmBase DIR] [--out FILE] [--noProbe]
"""

import argparse
import datetime
import json
import pathlib
import re
import socket
import sys
import urllib.error
import urllib.request

from bisos.banna import tcpPorts

thisDir = pathlib.Path(__file__).resolve().parent
defaultOut = thisDir.parent / "data" / "capabilities.json"   # content/data/, read by site/ as @content
defaultCbmBase = pathlib.Path("/bisos/platform/sys/cbm")

# Where a capability's .here name differs from its capability name.
hereNameOf = {
    "gatsbyBxSidebar": "starterSidebar",
}

# One line for leaves whose banna port has no description (or no port at all).
descriptionOf = {
    "nginx": "nginx, the web server every .here vhost needs",
    "reactPlus": "Node.js and the React/Gatsby toolchain (sbom only, no units)",
    "gatsbyBxSidebar": "the ByStar nested-sidebar Gatsby starter, as a site",
    "kafka": "Apache Kafka, single-node KRaft; kafka.here is its web UI, Kafbat UI",
    "platform": "this site: the platform's capabilities and their .here links",
}

thisSiteName = "platform"
gates = ("enabled", "available", "disabled")
defaultGate = "available"   # bisos.capability.cbmProc_seedInfo.DEFAULT_CONTROL


def _setupArg(text: str, name: str) -> str:
    m = re.search(rf'^\s*{name}\s*=\s*["\']([^"\']+)["\']', text, re.MULTILINE)
    return m.group(1) if m else ""


def _branchesOrdered(typeDir: pathlib.Path) -> list[str]:
    branchProc = typeDir / "ftoBranchProc.spcs"
    if not branchProc.is_file():
        return []
    m = re.search(r"^branchesOrdered\s*=\s*\[(.*?)\]", branchProc.read_text(), re.MULTILINE | re.DOTALL)
    return re.findall(r'^\s*"([^"]+)"', m.group(1), re.MULTILINE) if m else []


def _repoOf(cbsSpec: str) -> tuple[str, str]:
    """(package or repo name, its GitHub URL) from where the CBS lives."""
    path = cbsSpec.replace("/bisos/git/auth/bxRepos/", "/bisos/git/bxRepos/")
    m = re.match(r"/bisos/git/bxRepos/([^/]+)/([^/]+)/", path)
    if not m:
        return ("", "")
    org, repo = m.groups()
    name = f"bisos.{repo}" if org == "bisos-pip" else repo
    return (name, f"https://github.com/{org}/{repo}")


def _probe(url: str) -> int | None:
    try:
        with urllib.request.urlopen(url, timeout=3) as resp:
            return resp.status
    except urllib.error.HTTPError as e:
        return e.code
    except (urllib.error.URLError, OSError):
        return None


def capabilities(cbmBase: pathlib.Path, probe: bool = True) -> list[dict]:
    ports = tcpPorts.tcpPortsAssignedList.tcpPortsList
    hereNames = {name: (ip, portNu) for ip, name, portNu in tcpPorts.hereEntries()}
    result = []
    for spcs in sorted(cbmBase.glob("*/*/*/cbmProc.spcs")):
        leaf = spcs.parent
        realm, capabilityType, leafName = leaf.relative_to(cbmBase).parts
        text = spcs.read_text()
        name = _setupArg(text, "capabilityName") or leafName
        cbsSpec = _setupArg(text, "cbsSpec")

        control = leaf / "cbmProc.control"
        gate = control.read_text().strip() if control.is_file() else defaultGate
        status = leaf / "cbmProc.status"
        statusLines = status.read_text().splitlines() if status.is_file() else []
        lastStatus = statusLines[-1] if statusLines else ""

        hereName = hereNameOf.get(name, name)
        hereIp, portNu = hereNames.get(hereName, (None, None))
        url = f"http://{hereName}.here/" if hereIp else None
        port = ports.get(hereName)
        description = descriptionOf.get(name) or (port.portDescription if port else "")
        package, repoUrl = _repoOf(cbsSpec)

        order = _branchesOrdered(leaf.parent)
        result.append({
            "realm": realm,
            "capabilityType": capabilityType,
            "name": name,
            "gate": gate,
            "lastStatus": lastStatus,
            "cbsSpec": cbsSpec,
            "package": package,
            "repoUrl": repoUrl,
            "hereName": hereName if hereIp else None,
            "url": url,
            "hereIp": hereIp,
            "portNu": portNu,
            "description": description,
            # This site is snapshotted before its own vhost exists: not probed.
            "isThisSite": name == thisSiteName,
            "httpStatus": _probe(url) if (url and probe and name != thisSiteName) else None,
            "walkOrder": order.index(leafName) if leafName in order else len(order),
            "slug": f"/capabilities/{realm}/{capabilityType}/{name}/",
        })
    result.sort(key=lambda c: (c["realm"], c["capabilityType"], c["walkOrder"], c["name"]))
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--cbmBase", type=pathlib.Path, default=defaultCbmBase)
    parser.add_argument("--out", type=pathlib.Path, default=defaultOut)
    parser.add_argument("--noProbe", action="store_true", help="do not probe the .here URLs")
    args = parser.parse_args()

    caps = capabilities(args.cbmBase, probe=not args.noProbe)
    snapshot = {
        "generatedAt": datetime.datetime.now().astimezone().isoformat(timespec="seconds"),
        "host": socket.gethostname(),
        "cbmBase": str(args.cbmBase),
        "probed": not args.noProbe,
        "counts": {g: sum(c["gate"] == g for c in caps) for g in gates},
        "capabilities": caps,
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(snapshot, indent=2) + "\n")
    print(f"{args.out}: {len(caps)} capabilities, {snapshot['counts']}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
