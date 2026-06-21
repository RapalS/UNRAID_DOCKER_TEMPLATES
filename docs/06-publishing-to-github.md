# Publishing Templates to GitHub

How to share templates from this repository so others can install them via Docker Repositories or manual copy.

---

## Repository requirements

| Item | Location |
|------|----------|
| Template XML | `templates/<app-name>.xml` |
| Icon (128×128 PNG) | HTTPS URL in `<Icon>` — the app's upstream raw icon |
| Optional per-app doc | `docs/apps/<app-name>.md` |
| Maintainer profile | `ca_profile.xml` (repo root) |

Naming: lowercase, hyphenated (`my-cool-app.xml`).

---

## Replace placeholders

Search and replace before publishing:

| Placeholder | Replace with |
|-------------|--------------|
| `RapalS` | Maintainer GitHub username (this repo) |
| `APP_NAME` | Actual app slug in filenames |
| `UPSTREAM/REPO` | Upstream project path |

PowerShell:

```powershell
Get-ChildItem -Recurse -Include *.xml,*.md | ForEach-Object {
  (Get-Content $_.FullName -Raw) -replace 'RapalS','mygithubuser' | Set-Content $_.FullName
}
```

---

## Raw GitHub URLs

Templates must use **raw** URLs, not blob links.

**Wrong:**

```
https://github.com/user/repo/blob/main/templates/app.xml
```

**Correct:**

```
https://raw.githubusercontent.com/user/repo/main/templates/app.xml
```

### TemplateURL

Every published template in `templates/` should include:

```xml
<TemplateURL>https://raw.githubusercontent.com/RapalS/UNRAID_DOCKER_TEMPLATES/main/templates/my-app.xml</TemplateURL>
```

### Icon

Point `<Icon>` to the app's **upstream raw PNG** (most projects ship one in their repo):

```xml
<Icon>https://raw.githubusercontent.com/<owner>/<repo>/main/path/to/icon.png</Icon>
```

Use the official upstream icon where possible. If you reuse a third-party icon, confirm its license and add attribution if required.

---

## Icon guidelines

| Rule | Detail |
|------|--------|
| Size | 128×128 pixels |
| Format | **PNG only** for `<Icon>` URLs (SVG/WebP fail in Unraid Docker UI) |
| Source | The app's upstream raw icon URL (preferred) |
| License | Ensure you have rights to use/link the icon |

Prefer the official upstream icon. Avoid SVG/WebP — Unraid's Docker UI only renders PNG reliably.

---

## Branch and default branch

Raw URLs must match your **default branch** (`main` or `master`):

```
.../main/templates/app.xml
```

If you rename the default branch, update all `TemplateURL` and `Icon` values.

---

## Commit workflow

1. Scaffold: `.\scripts\scaffold-template.ps1 -Name "my-app" -Image "org/image:tag"`
2. Edit XML from upstream documentation
3. Set `<Icon>` to the app's upstream raw PNG URL
4. Validate: `.\scripts\validate-template.ps1 templates/my-app.xml`
5. Test on Unraid ([05-testing-on-your-server.md](05-testing-on-your-server.md))
6. Update README template index table
7. Open PR with [checklist](app-template-checklist.md)

---

## README template index

Add a row to the README **Template index** table:

```markdown
| my-app | `org/image:tag` | 8080 | Ready | [docs](docs/apps/my-app.md) |
```

---

## Version tags and `:latest`

Document which tag users should run. Prefer explicit tags for production apps:

```xml
<Repository>ghcr.io/org/app:1.2.3</Repository>
```

Using `:latest` is acceptable for reference templates but note it in Description.

---

## Security

- Never commit API keys, tokens, or passwords in XML
- Use `Mask="true"` for secret **variables** (user supplies at install)
- Do not embed private registry credentials in public templates

---

## Next step

→ [07-community-apps-submission.md](07-community-apps-submission.md) for official CA catalog
