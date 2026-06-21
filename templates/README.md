# Published templates

Every `*.xml` file in this folder (except names starting with `_`) is an installable Unraid Docker template.

## Add a new template

```powershell
.\scripts\scaffold-template.ps1 -Name "my-app" -Image "org/image:tag"
# Edit my-app.xml, validate, regenerate index, push
.\scripts\validate-template.ps1 templates/my-app.xml
python scripts/generate_template_index.py
```

See [CONTRIBUTING.md](../CONTRIBUTING.md) and [docs/TEMPLATE_INDEX.md](../docs/TEMPLATE_INDEX.md) for the full catalog.
