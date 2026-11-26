#!/usr/bin/env python

"""Snapshot this platform's CBM tree as content/data/capabilities.json, for platform.internal.

Read-only. For every leaf under /bisos/platform/sys/cbm/<realm>/<capabilityType>/<name>/ that has a
cbmProc.spcs, it records the gate (cbmProc.control), the last line of cbmProc.status, the CBS the leaf
points at, the .internal name, IP and port from bisos.banna, and the HTTP status of http://<name>.internal/
as probed now. cbmProc.spcs is parsed as text, not executed. The order is the walk's
(branchesOrdered of the type's ftoBranchProc.spcs), then by name. Each leaf also gets its verdict
from the latest fullyVerify report (bisos.capability, /bisos/var/cbm/verify/latest/report.json),
when there is one.

The site is a snapshot: rerun this (cbm/platform-assemble.cs -i siteBuild runs every content/bin
script) to refresh it.

Usage: platformCapabilities.py [--cbmBase DIR] [--out FILE] [--noProbe] [--verifyReport FILE]
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
defaultVerifyReport = pathlib.Path("/bisos/var/cbm/verify/latest/report.json")

# Where a capability's .internal name differs from its capability name.
hereNameOf = {
    "gatsbyBxSidebar": "starterSidebar",
}

# One line for leaves whose banna port has no description (or no port at all).
descriptionOf = {
    "nginx": "nginx, the web server every .internal vhost needs",
    "reactPlus": "Node.js and the React/Gatsby toolchain (sbom only, no units)",
    "gatsbyBxSidebar": "the ByStar nested-sidebar Gatsby starter, as a site",
    "kafka": "Apache Kafka, single-node KRaft; kafka.internal is its web UI, Kafbat UI",
    "platform": "this site: the platform's capabilities and their .internal links",
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


def _probe(url: str) -> int | str | None:
    """The status of url; "no vhost" when nginx's default page answered (any name without a vhost)."""
    try:
        with urllib.request.urlopen(url, timeout=3) as resp:
            if b"<title>Welcome to nginx!</title>" in resp.read(4096):
                return "no vhost"
            return resp.status
    except urllib.error.HTTPError as e:
        return e.code
    except (urllib.error.URLError, OSError):
        return None


def _verifyByLeaf(path: pathlib.Path) -> tuple[dict, dict | None]:
    """The leaves of a fullyVerify report, keyed <realm>/<type>/<name>, and the report's summary."""
    try:
        rep = json.loads(path.read_text())
    except (OSError, ValueError):
        return {}, None
    byLeaf = {"/".join(pathlib.PurePath(leaf["leafRel"]).parts[-3:]): leaf for leaf in rep.get("leaves", [])}
    summary = {k: rep.get(k) for k in ("generatedAt", "verdict", "counts", "platformProblems", "maskedFailures")}
    summary["report"] = str(path.resolve())
    return byLeaf, summary


def capabilities(cbmBase: pathlib.Path, probe: bool = True, verifyBy: dict | None = None) -> list[dict]:
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
        url = f"http://{tcpPorts.hereFqdn(hereName)}/" if hereIp else None
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
            "verify": _verifyOf((verifyBy or {}).get(f"{realm}/{capabilityType}/{leafName}")),
        })
    result.sort(key=lambda c: (c["realm"], c["capabilityType"], c["walkOrder"], c["name"]))
    return result


def _verifyOf(leaf: dict | None) -> dict | None:
    if not leaf:
        return None
    return {k: leaf.get(k) for k in ("verdict", "detail", "at", "rcAgrees", "materializeRc")}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--cbmBase", type=pathlib.Path, default=defaultCbmBase)
    parser.add_argument("--out", type=pathlib.Path, default=defaultOut)
    parser.add_argument("--noProbe", action="store_true", help="do not probe the .internal URLs")
    parser.add_argument("--verifyReport", type=pathlib.Path, default=defaultVerifyReport,
                        help="the fullyVerify report whose verdicts the site shows")
    args = parser.parse_args()

    verifyBy, verifySummary = _verifyByLeaf(args.verifyReport)
    caps = capabilities(args.cbmBase, probe=not args.noProbe, verifyBy=verifyBy)
    snapshot = {
        "generatedAt": datetime.datetime.now().astimezone().isoformat(timespec="seconds"),
        "host": socket.gethostname(),
        "cbmBase": str(args.cbmBase),
        "probed": not args.noProbe,
        "counts": {g: sum(c["gate"] == g for c in caps) for g in gates},
        "verify": verifySummary,
        "capabilities": caps,
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(snapshot, indent=2) + "\n")
    print(f"{args.out}: {len(caps)} capabilities, {snapshot['counts']}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
