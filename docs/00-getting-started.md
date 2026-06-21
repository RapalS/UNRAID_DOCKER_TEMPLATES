# Getting Started

Welcome to the **Unraid Docker Templates** community project. This repository helps you install Docker applications on Unraid that are **not yet listed** in the official Community Applications (CA) catalog, and teaches you how to author templates others can reuse.

## What is a Docker template?

Unraid stores container definitions as **XML template files**. Each template describes:

- Which Docker image to pull (`Repository`)
- Network mode, ports, volume mounts, and environment variables
- Metadata shown in the UI (name, description, icon, WebUI link)

When you pick a template in **Docker → Add Container**, Unraid pre-fills the form so you do not have to configure everything manually.

## Prerequisites

| Requirement | Notes |
|-------------|-------|
| **Unraid 6.9+** | Recommended; 6.12+ for best Docker/CA compatibility |
| **Docker enabled** | Settings → Docker → Enable Docker = Yes |
| **Community Applications** | Strongly recommended (not strictly required for manual XML install) |
| **Array started** | Required before pulling images |
| **Internet access** | For pulling images from Docker Hub, GHCR, etc. |
| **Appdata share** | Typically `/mnt/user/appdata/` for persistent config |

## Key paths on Unraid

| Path | Purpose |
|------|---------|
| `/boot/config/plugins/dockerMan/templates-user/` | User-installed template XML files (flash drive) |
| `/mnt/user/appdata/<app>/` | Persistent container configuration |
| `/var/lib/docker/` | Docker image and container storage (system path) |

## Repository layout (quick map)

```
templates/              → One XML per app (flat folder; scales to hundreds)
docs/TEMPLATE_INDEX.md  → Auto-generated catalog of all templates
docs/apps/              → Optional per-app setup guides
examples/               → Learning/reference XML (not primary install path)
docs/                   → Step-by-step guides (start here if new)
scripts/                → Validation, scaffolding, index generation
ca_profile.xml          → CA repository profile — one file for the whole repo
```

This is a **multi-app template collection**, not a single-product repo. Add `templates/new-app.xml`, run `python scripts/generate_template_index.py`, and push — Unraid users who linked the Docker Repository see the new template after refresh.

## Recommended reading order

1. [Install templates](01-install-templates.md) — get a container running in minutes
2. [Authoring on Unraid](02-authoring-on-unraid.md) — **primary guide** ([Selfhosters workflow](https://selfhosters.net/docker/templating/templating/))
3. [XML reference](03-xml-reference.md) — Config types, all Container fields, manual authoring
4. [Cleaning XML](04-cleaning-xml.md) — remove CA bloat (idrac6 walkthrough)
5. [Testing on your server](05-testing-on-your-server.md) — validate on your Unraid box
6. [Publishing to GitHub](06-publishing-to-github.md) — raw URLs, icons, commits
7. [Community Apps submission](07-community-apps-submission.md) — optional official catalog
8. [Troubleshooting](08-troubleshooting.md) — common problems

## Authoring source of truth

This repo's authoring docs are aligned with **[Selfhosters.net — Writing a template compatible for Unraid](https://selfhosters.net/docker/templating/templating/)** (Squid's FAQ). For official CA submission parser rules, also see [ca.unraid.net XML field reference](https://ca.unraid.net/submit/help/xml-field-reference).

## Before you publish

Repository URLs use maintainer **`RapalS`**. Forks for personal use should search/replace `RapalS` with your GitHub username in XML files if publishing under your own account.

## External references

- [Forum guide: Docker images not on CA](https://forums.unraid.net/topic/162164-guide-how-to-install-docker-images-that-are-not-avaliable-on-the-community-applications-page/)
- [Selfhosters templating guide](https://selfhosters.net/docker/templating/templating/)
- [Official CA Builder Guide](https://ca.unraid.net/submit/help/builders)

## Next step

→ Continue to [01-install-templates.md](01-install-templates.md)
