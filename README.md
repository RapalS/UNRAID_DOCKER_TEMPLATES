# Unraid Docker Templates

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)
[![Templates](https://img.shields.io/badge/templates-3+-ff8c2f?style=for-the-badge)](#template-index)
[![CI](https://img.shields.io/github/actions/workflow/status/RapalS/UNRAID_DOCKER_TEMPLATES/validate-xml.yml?branch=main&color=ff8c2f&style=for-the-badge&label=XML%20Validate)](https://github.com/RapalS/UNRAID_DOCKER_TEMPLATES/actions)

Community-maintained **Unraid Docker templates** for applications not yet available in the official [Community Applications](https://unraid.net/community/apps) catalog — plus guides, examples, and validation tooling so anyone can author and share templates.

Maintainer: **[RapalS](https://github.com/RapalS)** · Repository: [RapalS/UNRAID_DOCKER_TEMPLATES](https://github.com/RapalS/UNRAID_DOCKER_TEMPLATES)

---

## Why this exists

- New or beta software often ships on Docker Hub/GHCR before appearing in CA
- Custom or self-built images need one-click install templates for the community
- Template authoring is poorly documented — this repo collects best practices in one place

Inspired by the [Unraid forum guide for non-CA Docker images](https://forums.unraid.net/topic/162164-guide-how-to-install-docker-images-that-are-not-avaliable-on-the-community-applications-page/) and the **[Selfhosters templating guide](https://selfhosters.net/docker/templating/templating/)** (primary authoring reference for this repo).

---

## Quick start (30 seconds)

1. Unraid UI → **Docker** → **Docker Repositories**
2. Add template repository URL:
   ```
   https://github.com/RapalS/UNRAID_DOCKER_TEMPLATES
   ```
3. **Save** → **Docker** → **Add Container** → pick a template → **Apply**

Detailed install paths: [docs/01-install-templates.md](docs/01-install-templates.md)

---

## Template index

| App | Image | Ports | Status | Notes |
|-----|-------|-------|--------|-------|
| [nornicdb-hermes-memory-cpu](templates/nornicdb-hermes-memory-cpu.xml) | `nornicdb-cpu-bge` / `cpu-headless` | 7474, 7687 | Ready | AMD64, no GPU — [Setup guide](docs/apps/nornicdb.md) |
| [nornicdb-hermes-memory-gpu](templates/nornicdb-hermes-memory-gpu.xml) | CUDA / Vulkan BGE branches | 7474, 7687 | Ready | AMD64 NVIDIA/Vulkan — [Setup guide](docs/apps/nornicdb.md) |
| [nornicdb-hermes-memory-apple-silicon](templates/nornicdb-hermes-memory-apple-silicon.xml) | `nornicdb-arm64-metal-bge` | 7474, 7687 | Ready | Apple Silicon Metal — [Setup guide](docs/apps/nornicdb.md) |

_Request or contribute more apps — see [CONTRIBUTING.md](CONTRIBUTING.md)._

---

## Documentation

| Guide | Description |
|-------|-------------|
| [Getting started](docs/00-getting-started.md) | Prerequisites and repo layout |
| [Install templates](docs/01-install-templates.md) | Manual, Docker Repositories, CA paths |
| [Authoring on Unraid](docs/02-authoring-on-unraid.md) | Template Authoring Mode workflow |
| [XML reference](docs/03-xml-reference.md) | Every field and Config type |
| [Cleaning XML](docs/04-cleaning-xml.md) | Prepare CA/GitHub-ready templates |
| [Testing on your server](docs/05-testing-on-your-server.md) | Validate on your Unraid box |
| [Publishing to GitHub](docs/06-publishing-to-github.md) | Raw URLs, icons, commits |
| [CA submission](docs/07-community-apps-submission.md) | Official catalog submission |
| [Troubleshooting](docs/08-troubleshooting.md) | DNS, permissions, ports |
| [App checklist](docs/app-template-checklist.md) | PR checklist per template |

---

## Repository structure

```
templates/          Published installable templates
examples/           Reference XML for learning
docs/               Authoring and install guides
scripts/            validate-template, scaffold-template
ca_profile.xml      CA repository profile (<CommunityApplications> / <Profile>)
```

---

## Create a new template

```powershell
# Windows
.\scripts\scaffold-template.ps1 -Name "my-app" -Image "ghcr.io/org/app:latest"

# Validate
.\scripts\validate-template.ps1 templates/my-app.xml
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full workflow.

---

## Lab testing

Templates are designed to be tested on a local Unraid server (e.g. `192.168.x.10`). See [docs/05-testing-on-your-server.md](docs/05-testing-on-your-server.md).

---

## Contributing

Contributions welcome! Read [CONTRIBUTING.md](CONTRIBUTING.md) and follow [docs/app-template-checklist.md](docs/app-template-checklist.md).

---

## Credits and references

- **[Selfhosters — Writing a template compatible for Unraid](https://selfhosters.net/docker/templating/templating/)** — primary authoring reference (Squid FAQ)
- [Unraid CA Builder Guide](https://ca.unraid.net/submit/help/builders)
- [CA Repository XML format](https://ca.unraid.net/submit/help/repository-xml)
- [CA XML field reference](https://ca.unraid.net/submit/help/xml-field-reference)
- [Docker template XML schema (forum)](https://forums.unraid.net/topic/38619-docker-template-xml-schema/)
- [Real Docker FAQ](https://forums.unraid.net/topic/57181-real-docker-faq/)

---

## License

MIT — see [LICENSE](LICENSE). This is an [OSI-approved](https://opensource.org/licenses/MIT) license for **repository contents** (templates, docs, icons). Upstream container images are licensed separately by their publishers. See [GitHub — Licensing a repository](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository).

---

## Community Applications submission

To list this repo in the official Unraid catalog:

1. Customize [`ca_profile.xml`](ca_profile.xml) if needed (`<Profile>` is **required** for CA — see [repository info XML](https://ca.unraid.net/submit/help/repository-info-xml))
2. Run `python scripts/validate.py --strict templates ca_profile.xml`
3. Submit at [ca.unraid.net/submit/new](https://ca.unraid.net/submit/new) → **Validate** → **Scan** → **Submit**

Full checklist: [docs/07-community-apps-submission.md](docs/07-community-apps-submission.md)
