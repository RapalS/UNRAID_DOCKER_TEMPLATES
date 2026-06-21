#!/usr/bin/env python3
"""Validate Unraid Docker template XML files."""

from __future__ import annotations

import argparse
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

REQUIRED_CONTAINER_TAGS = ("Name", "Repository", "Overview")
RECOMMENDED_CONTAINER_TAGS = ("Description", "Support", "Project", "TemplateURL", "Category")
LEGACY_TAGS = ("Networking", "Data", "Environment")
INTERNAL_TAGS = ("DateInstalled",)
SKIP_FILES = {"base-xml.xml", "scaffold-starter.xml"}
PLACEHOLDER_REPOS = {
    "ghcr.io/ORG/IMAGE:tag",
    "YOUR_IMAGE:tag",
    "example/placeholder:latest",
}


def load_tree(path: Path) -> ET.Element:
    try:
        tree = ET.parse(path)
        return tree.getroot()
    except ET.ParseError as exc:
        raise ValueError(f"Malformed XML: {exc}") from exc


def text_of(root: ET.Element, tag: str) -> str:
    el = root.find(tag)
    if el is None or el.text is None:
        return ""
    return el.text.strip()


def validate_file(path: Path, strict: bool = False) -> tuple[list[str], list[str]]:
    errors: list[str] = []
    warnings: list[str] = []

    if path.name in SKIP_FILES:
        return errors, [f"Skipped starter file ({path.name})"]

    root = load_tree(path)
    tag = root.tag

    if tag == "Container":
        _validate_container(root, path, errors, warnings, strict)
    elif tag == "CommunityApplications":
        _validate_community_applications(root, errors, warnings)
    elif tag == "CAProfile":
        warnings.append(
            "Legacy <CAProfile> root — use <CommunityApplications> with <Profile> "
            "(https://ca.unraid.net/submit/help/repository-info-xml)"
        )
        _validate_ca_profile_legacy(root, errors, warnings)
    else:
        errors.append(
            f"Unknown root element <{tag}>; expected Container, CommunityApplications, or CAProfile"
        )

    return errors, warnings


def _validate_container(
    root: ET.Element,
    path: Path,
    errors: list[str],
    warnings: list[str],
    strict: bool,
) -> None:
    if root.get("version") != "2":
        warnings.append("Container missing version='2' attribute")

    for tag in REQUIRED_CONTAINER_TAGS:
        if not text_of(root, tag):
            errors.append(f"Missing or empty required tag <{tag}>")

    if strict and path.parent.name == "templates" and path.name not in SKIP_FILES:
        for tag in RECOMMENDED_CONTAINER_TAGS:
            if not text_of(root, tag):
                warnings.append(f"Missing recommended tag <{tag}> (required for CA submission)")

        template_url = text_of(root, "TemplateURL")
        if template_url and "raw.githubusercontent.com" not in template_url:
            warnings.append("TemplateURL should use raw.githubusercontent.com")
        if "YOUR_USERNAME" in ET.tostring(root, encoding="unicode"):
            warnings.append("Contains YOUR_USERNAME placeholder — replace before publishing")

        icon_url = text_of(root, "Icon")
        if icon_url and icon_url.startswith("/plugins/"):
            warnings.append("Icon uses local Unraid path — use HTTPS URL for CA/GitHub distribution")
        if icon_url and icon_url.endswith(".svg"):
            errors.append(
                "Icon is SVG — Unraid Docker UI requires PNG (SVG/WebP show question "
                "mark or blank; see forums.unraid.net bug R3755)"
            )
        if icon_url and icon_url.endswith(".webp"):
            errors.append("Icon is WebP — Unraid Docker UI does not render WebP; use PNG")
        if icon_url and "raw.githubusercontent.com" not in icon_url and icon_url.startswith("http"):
            warnings.append("Icon hotlinked from a non-GitHub host — prefer a stable raw GitHub PNG (e.g. the app's upstream raw icon)")

    repo = text_of(root, "Repository")
    is_example = path.parent.name == "examples"
    if not repo:
        errors.append("Repository is empty")
    elif repo in PLACEHOLDER_REPOS or repo.startswith("YOUR_"):
        if is_example:
            warnings.append(f"Repository is a placeholder ({repo}) — replace before use")
        else:
            errors.append("Repository is still a placeholder")

    for legacy in LEGACY_TAGS:
        if root.find(legacy) is not None:
            warnings.append(f"Legacy <{legacy}> block present — prefer <Config> entries only")

    for internal in INTERNAL_TAGS:
        if root.find(internal) is not None:
            warnings.append(f"Internal tag <{internal}> should be removed before publishing")

    configs = root.findall("Config")
    if path.parent.name == "templates" and path.name not in SKIP_FILES and not configs:
        warnings.append("No <Config> entries — template may be incomplete for end users")

    privileged = text_of(root, "Privileged").lower()
    network = text_of(root, "Network")
    if privileged == "true":
        warnings.append("Privileged=true — document why in Description")
    if network == "host":
        warnings.append("Network=host — port Config entries are ignored")


def _profile_text(root: ET.Element) -> str:
    el = root.find("Profile")
    if el is None:
        return ""
    return (el.text or "").strip()


def _validate_community_applications(
    root: ET.Element, errors: list[str], warnings: list[str]
) -> None:
    if not _profile_text(root):
        errors.append("ca_profile.xml missing required non-empty <Profile>")
    if not text_of(root, "WebPage"):
        warnings.append("ca_profile.xml missing recommended <WebPage>")
    if not text_of(root, "Icon"):
        warnings.append("ca_profile.xml missing recommended <Icon>")
    icon_url = text_of(root, "Icon")
    if icon_url and icon_url.endswith((".svg", ".webp")):
        errors.append("ca_profile Icon must be PNG — Unraid does not render SVG/WebP in Docker UI (bug R3755)")
    if "YOUR_USERNAME" in ET.tostring(root, encoding="unicode"):
        warnings.append("ca_profile.xml contains YOUR_USERNAME placeholder — replace before CA submission")
    if "YOUR_GITHUB_USERNAME" in ET.tostring(root, encoding="unicode"):
        warnings.append("ca_profile.xml contains YOUR_GITHUB_USERNAME placeholder")


def _validate_ca_profile_legacy(root: ET.Element, errors: list[str], warnings: list[str]) -> None:
    if not text_of(root, "Overview"):
        errors.append("CAProfile missing required <Overview> (migrate to CommunityApplications/<Profile>)")
    if "YOUR_USERNAME" in ET.tostring(root, encoding="unicode"):
        warnings.append("ca_profile.xml contains YOUR_USERNAME placeholder")


def collect_files(paths: list[str], repo_root: Path) -> list[Path]:
    files: list[Path] = []
    for raw in paths:
        p = Path(raw)
        if not p.is_absolute():
            p = repo_root / p
        if p.is_dir():
            files.extend(sorted(p.rglob("*.xml")))
        elif p.exists():
            files.append(p)
        else:
            print(f"Warning: path not found: {raw}", file=sys.stderr)
    return files


def main() -> int:
    # Windows consoles default to cp1252 and mangle em dashes in messages.
    for stream in (sys.stdout, sys.stderr):
        try:
            stream.reconfigure(encoding="utf-8")
        except (AttributeError, ValueError):
            pass

    parser = argparse.ArgumentParser(description="Validate Unraid Docker template XML")
    parser.add_argument("paths", nargs="*", default=["templates", "examples", "ca_profile.xml"])
    parser.add_argument("--strict", action="store_true", help="Strict checks for templates/ publish path")
    parser.add_argument("--repo-root", default=".", help="Repository root directory")
    args = parser.parse_args()

    repo_root = Path(args.repo_root).resolve()
    files = collect_files(args.paths, repo_root)

    if not files:
        print("No XML files found to validate.", file=sys.stderr)
        return 1

    total_errors = 0
    total_warnings = 0

    for path in files:
        rel = path.relative_to(repo_root) if path.is_relative_to(repo_root) else path
        try:
            errors, warnings = validate_file(path, strict=args.strict or path.parent.name == "templates")
        except ValueError as exc:
            print(f"FAIL {rel}: {exc}")
            total_errors += 1
            continue

        if errors:
            print(f"FAIL {rel}")
            for msg in errors:
                print(f"  ERROR: {msg}")
            total_errors += len(errors)
        elif warnings:
            print(f"WARN {rel}")
        else:
            print(f"OK   {rel}")

        for msg in warnings:
            print(f"  WARN: {msg}")
        total_warnings += len(warnings)

    print(f"\nValidated {len(files)} file(s): {total_errors} error(s), {total_warnings} warning(s)")

    return 1 if total_errors else 0


if __name__ == "__main__":
    sys.exit(main())
