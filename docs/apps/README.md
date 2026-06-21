# Per-app setup guides

Optional extended documentation when a template needs more explanation than fits in the XML `<Description>` field.

**Full template list (all apps):** [TEMPLATE_INDEX.md](../TEMPLATE_INDEX.md) — auto-generated from `templates/*.xml`.

---

## Documented apps

| App | Templates | Guide |
|-----|-----------|-------|
| NornicDB | `nornicdb-hermes-memory-cpu`, `nornicdb-hermes-memory-gpu`, `nornicdb-hermes-memory-apple-silicon` | [nornicdb.md](nornicdb.md) |

Add a row here when you create a new guide under `docs/apps/`.

---

## When to add a guide

Create `docs/apps/<app>.md` when:

- The app has multiple template variants (CPU/GPU, branches, etc.)
- Install steps are non-obvious (GPU flags, Metal, reverse proxy)
- You tested on a specific Unraid version and want to record notes

For simple one-file templates, the XML `<Description>` alone is often enough — skip the markdown file.

---

## Naming convention

| Item | Convention |
|------|------------|
| Template file | `templates/my-app.xml` |
| Optional doc | `docs/apps/my-app.md` |
| Multi-variant doc | `docs/apps/my-app.md` covers `my-app-cpu`, `my-app-gpu`, etc. |

The index generator links templates to docs when the filename matches or shares a prefix (e.g. `nornicdb-hermes-memory-cpu` → `nornicdb.md`).

See [app-template-checklist.md](../app-template-checklist.md).
