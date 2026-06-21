# Contributing

Thank you for helping improve Unraid Docker templates for the community.

## Ways to contribute

- Add a new template for an app missing from CA
- Fix ports, paths, or env vars in existing templates
- Improve documentation
- Report issues with install or upstream image changes

## Before you start

1. Read [docs/00-getting-started.md](docs/00-getting-started.md)
2. Use [docs/app-template-checklist.md](docs/app-template-checklist.md) for every new template
3. Forks: replace `RapalS` in XML URLs if publishing under your own GitHub account

## Adding a new template

### 1. Scaffold

```powershell
.\scripts\scaffold-template.ps1 -Name "my-app" -Image "org/image:tag"
```

Or run [`scripts/scaffold-template.ps1`](scripts/scaffold-template.ps1), or copy [`examples/scaffold-starter.xml`](examples/scaffold-starter.xml) to `templates/my-app.xml`.

### 2. Research upstream

From the Docker image README / Dockerfile, document:

- `Repository` and tag
- Required environment variables
- Ports (TCP/UDP)
- Volume mounts
- Special requirements (GPU, privileged, host network)

### 3. Edit XML

Conventions:

| Item | Convention |
|------|------------|
| Filename | `templates/my-app.xml` (lowercase, hyphenated) |
| Icon | HTTPS URL to a 128×128 PNG — the app's upstream raw icon |
| Appdata | `/mnt/user/appdata/my-app/` |
| PUID/PGID | `99` / `100` when image supports it |
| Config style | Modern `<Config>` only — no legacy blocks |
| TemplateURL | Raw GitHub URL to your XML file |

See [docs/03-xml-reference.md](docs/03-xml-reference.md).

### 4. Validate locally

```powershell
.\scripts\validate-template.ps1 templates/my-app.xml
```

### 5. Test on Unraid

Follow [docs/05-testing-on-your-server.md](docs/05-testing-on-your-server.md). Record Unraid version and test results in your PR.

### 6. Update README

Add a row to the **Template index** table in [README.md](README.md).

### 7. Open a pull request

Fill out the PR template checklist completely.

## Pull request guidelines

- One app per PR when possible (easier review)
- No secrets in XML or docs
- CI must pass (XML validation workflow)
- Squash or clean commits welcome but not required

## Code of conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## Questions

Open a [GitHub issue](https://github.com/RapalS/UNRAID_DOCKER_TEMPLATES/issues) or discuss in your Unraid forum support thread if this repo is submitted to CA.

## Requesting a new app

If you want a specific app templated, open an issue with:

- Docker image name and preferred tag
- Link to upstream documentation
- Any Unraid-specific notes (GPU, ports in use, etc.)

Maintainers will research, author XML, and test before merge.
