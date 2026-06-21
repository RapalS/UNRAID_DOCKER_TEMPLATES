# Install Templates

Three ways to use templates from this repository. Pick the path that fits your situation.

## Path A — Manual (single template)

Best when you want **one app** quickly without linking a whole GitHub repo.

### Steps

1. Open the template on GitHub, e.g. [`templates/nornicdb-hermes-memory-cpu.xml`](../templates/nornicdb-hermes-memory-cpu.xml).
2. Click **Raw** and save the file, or copy the raw URL:
   ```
   https://raw.githubusercontent.com/RapalS/UNRAID_DOCKER_TEMPLATES/main/templates/nornicdb-hermes-memory-cpu.xml
   ```
3. Copy the `.xml` file to your Unraid flash drive:
   ```
   /boot/config/plugins/dockerMan/templates-user/nornicdb-hermes-memory-cpu.xml
   ```
   Access via SMB share `flash`, SSH, or the Unraid terminal.
4. In the Unraid web UI: **Docker** → **Add Container**.
5. Open the **Template** dropdown → select **User Templates** → choose your template.
6. Review fields (enable **Advanced View** if needed) → **Apply**.

### When to use Path A

- Testing a single template before adding the full repo
- Air-gapped or minimal setups
- Sharing one template link in a forum post

---

## Path B — Docker Repositories (recommended)

Best for **ongoing use** of this entire template collection.

### Steps

1. Unraid web UI → **Docker** tab.
2. Click the **Docker Repositories** sub-tab (may appear as a secondary tab under Docker).
3. In **Template repositories**, add:
   ```
   https://github.com/RapalS/UNRAID_DOCKER_TEMPLATES
   ```
4. Click **Save**.
5. Return to **Docker** → **Add Container**.
6. Open the **Template** dropdown → select a template from this repository.
7. Configure required fields → **Apply**.

### Updating templates

After the maintainer pushes XML changes to GitHub:

1. Re-save the Docker Repositories entry (or wait for Unraid to refresh).
2. When adding a **new** container, the updated template appears in the dropdown.
3. For **existing** containers, edit the container or recreate from the updated template.

> **Note:** Unraid may cache templates. If you do not see updates, remove and re-add the repository URL, or use Path A for a single-file override.

### When to use Path B

- You install multiple apps from this repo
- You want one-click access to new templates as they are published

---

## Path C — Official Community Applications catalog

Best when templates should appear in the **global CA store** for all Unraid users.

This requires maintainer submission at [ca.unraid.net/submit/new](https://ca.unraid.net/submit/new). See [07-community-apps-submission.md](07-community-apps-submission.md).

Requirements summary:

- Public GitHub repository
- OSI-approved `LICENSE`
- Valid `ca_profile.xml` with non-empty `<Profile>` ([repository info XML](https://ca.unraid.net/submit/help/repository-info-xml))
- Valid template XML per [CA Repository XML format](https://ca.unraid.net/submit/help/repository-xml)

---

## Quick test: nornicdb

Verify your install path works:

| Field | Default |
|-------|---------|
| Template | `nornicdb-hermes-memory-cpu`, `nornicdb-hermes-memory-gpu`, or `nornicdb-hermes-memory-apple-silicon` |
| Port | `7474` |
| WebUI | `http://YOUR_UNRAID_IP:7474` |

Health check: `curl http://YOUR_UNRAID_IP:7474/health`

See [docs/apps/nornicdb.md](apps/nornicdb.md) for full setup.

---

## Install path comparison

| Path | Effort | Updates | Best for |
|------|--------|---------|----------|
| A — Manual | Copy one file | Manual re-copy | Single app, testing |
| B — Docker Repositories | Add URL once | Refresh from GitHub | This repo's full catalog |
| C — CA catalog | Maintainer submission | CA feed | Public discovery |

---

## Screenshot placeholders

When documenting for your fork, capture screenshots for:

1. Docker → Docker Repositories → Template repositories field
2. Add Container → Template dropdown showing repo templates
3. Advanced View with filled port/path fields
4. Successful container running with WebUI link

Store screenshots in `docs/images/` if you add them to your fork.

---

## Next step

→ [02-authoring-on-unraid.md](02-authoring-on-unraid.md) to create your own templates
