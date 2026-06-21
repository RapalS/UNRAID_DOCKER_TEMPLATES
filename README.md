# Unraid Docker Templates

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)
[![CI](https://img.shields.io/github/actions/workflow/status/RapalS/UNRAID_DOCKER_TEMPLATES/validate-xml.yml?branch=main&color=ff8c2f&style=for-the-badge&label=XML%20Validate)](https://github.com/RapalS/UNRAID_DOCKER_TEMPLATES/actions)

**RapalS**’s personal collection of **Unraid Docker templates** — one GitHub repo for every app you want to install with one click, whether or not it is in the official [Community Applications](https://unraid.net/community/apps) catalog yet.

Maintainer: **[RapalS](https://github.com/RapalS)** · Repository: [RapalS/UNRAID_DOCKER_TEMPLATES](https://github.com/RapalS/UNRAID_DOCKER_TEMPLATES)

---

## What this repo is

- **`templates/`** — drop a new `.xml` here, push to GitHub, install on Unraid
- **Docs & validation** — authoring guides, examples, and CI so templates stay CA-compatible
- **Not single-app** — NornicDB, future homelab apps, and anything else you template all live in the same repo

Inspired by the [Unraid forum guide for non-CA Docker images](https://forums.unraid.net/topic/162164-guide-how-to-install-docker-images-that-are-not-avaliable-on-the-community-applications-page/) and the **[Selfhosters templating guide](https://selfhosters.net/docker/templating/templating/)**.

---

## Quick start (30 seconds)

1. Unraid UI → **Docker** → **Docker Repositories**
2. Add template repository URL:
   ```
   https://github.com/RapalS/UNRAID_DOCKER_TEMPLATES
   ```
3. **Save** → **Docker** → **Add Container** → pick any template → **Apply**

Detailed install paths: [docs/01-install-templates.md](docs/01-install-templates.md)

---

## Template catalog

The full list is auto-generated from `templates/*.xml`:

→ **[docs/TEMPLATE_INDEX.md](docs/TEMPLATE_INDEX.md)**

Per-app setup guides (when needed): [docs/apps/](docs/apps/)

---

## Add another template (maintainer workflow)

```powershell
# 1. Scaffold
.\scripts\scaffold-template.ps1 -Name "my-app" -Image "ghcr.io/org/app:latest" -Port 8080

# 2. Edit templates/my-app.xml from upstream docs; set <Icon> to upstream PNG URL

# 3. Validate
.\scripts\validate-template.ps1 templates/my-app.xml
python scripts/validate.py --strict templates ca_profile.xml

# 4. Refresh catalog
python scripts/generate_template_index.py

# 5. Push
git add templates/my-app.xml docs/TEMPLATE_INDEX.md docs/apps/my-app.md
git commit -m "Add my-app Unraid template"
git push
```

No CA resubmission required for each new template — users who added the Docker Repository URL pick up new XML on refresh.

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full checklist.

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
| [CA submission](docs/07-community-apps-submission.md) | Optional official catalog listing |
| [Troubleshooting](docs/08-troubleshooting.md) | DNS, permissions, ports |
| [App checklist](docs/app-template-checklist.md) | PR checklist per template |

---

## Repository structure

```
templates/              One XML per app (flat folder — scales to hundreds)
docs/TEMPLATE_INDEX.md    Auto-generated catalog (run generate_template_index.py)
docs/apps/                Optional per-app setup guides
examples/                 Reference XML for learning
scripts/                  validate, scaffold, generate index
ca_profile.xml            CA repository profile (one file for the whole repo)
```

---

## Lab testing

Templates are tested on a local Unraid server (e.g. `192.168.1.10`). See [docs/05-testing-on-your-server.md](docs/05-testing-on-your-server.md).

---

## Contributing

Forks and community PRs welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md) and [docs/app-template-checklist.md](docs/app-template-checklist.md).

---

## Credits and references

- **[Selfhosters — Writing a template compatible for Unraid](https://selfhosters.net/docker/templating/templating/)**
- [Unraid CA Builder Guide](https://ca.unraid.net/submit/help/builders)
- [CA Repository XML format](https://ca.unraid.net/submit/help/repository-xml)
- [CA XML field reference](https://ca.unraid.net/submit/help/xml-field-reference)

---

## License

MIT — see [LICENSE](LICENSE). Upstream container images are licensed separately by their publishers.

---

## Community Applications (optional)

To list the **whole repository** in the official Unraid catalog once (not per template):

1. Review [`ca_profile.xml`](ca_profile.xml)
2. Run `python scripts/validate.py --strict templates ca_profile.xml`
3. Submit at [ca.unraid.net/submit/new](https://ca.unraid.net/submit/new)

Full checklist: [docs/07-community-apps-submission.md](docs/07-community-apps-submission.md)
