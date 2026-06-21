# Troubleshooting

Common issues when installing containers from custom templates on Unraid.

---

## Docker cannot pull image — "no such host"

**Symptoms:**

```
dial tcp: lookup ghcr.io on 192.168.x.1:53: no such host
```

**Causes:** DNS misconfiguration on Unraid; Pi-hole or router DNS blocking; no upstream DNS.

**Fixes:**

1. Settings → Network Settings
2. Enable **Static DNS addresses** (or use fixed DNS)
3. Set DNS to public resolvers, e.g. `1.1.1.1` and `8.8.8.8`
4. Disable Docker → Apply → Re-enable Docker → Apply
5. Retry container creation

If using Pi-hole, ensure Unraid itself can resolve external names (not only clients).

---

## Docker Hub rate limit

**Symptoms:** Pull fails with rate limit errors after many pulls.

**Fixes:**

- Log in to Docker Hub in Unraid (Settings → Docker → credentials) if available
- Use mirror registries (`lscr.io` for LinuxServer images)
- Wait and retry
- Pull from GHCR if upstream publishes there

---

## Version shows "not available"

**Symptoms:** Docker tab shows **Version: not available** but container runs.

**Causes:** Registry metadata format (OCI manifest), DNS, Docker Hub API limits, or upstream tagging.

**Fixes:**

1. Advanced View → **Force Update** (may temporarily show up-to-date)
2. Fix DNS (see above)
3. Install **Docker Update Patch** plugin from CA if on affected Unraid versions
4. Container may still be functional — document known-good tag in template Description

Not caused by template XML alone in most cases.

---

## Permission denied on appdata

**Symptoms:** Container logs show permission errors writing to `/config`.

**Fixes:**

1. Ensure host path exists: `/mnt/user/appdata/myapp`
2. Set PUID/PGID to `99`/`100` for Unraid defaults
3. Fix ownership:
   ```bash
   chown -R 99:100 /mnt/user/appdata/myapp
   ```
4. Use a share on a Linux filesystem (xfs/btrfs), not FAT/exFAT

---

## Port already allocated

**Symptoms:** `Bind for 0.0.0.0:8080 failed: port is already allocated`

**Fixes:**

1. Change **host port** in Add Container (keep container port same)
2. Stop conflicting container
3. Update template default port if 8080 is commonly used on Unraid (Plex, etc.)

---

## Template not in dropdown

**Fixes:**

1. Confirm XML is in `/boot/config/plugins/dockerMan/templates-user/` OR repo is in Docker Repositories
2. Check XML is well-formed (run validation script)
3. Re-add Docker Repository URL
4. Hard refresh browser cache
5. Filename should end in `.xml`

---

## WebUI link wrong

**Fixes:**

1. Use tokens: `http://[IP]:[PORT:8080]` not hardcoded IP
2. Match `[PORT:n]` to **container** port in Config
3. Use `https://` if app serves TLS on that port
4. Add path suffix if required: `http://[IP]:[PORT:8080]/admin`

---

## Private registry images

**Symptoms:** Pull fails with unauthorized.

**Fixes:**

1. Configure registry credentials in Unraid Docker settings
2. Use full image path in `<Repository>`
3. Document login steps in `<Description>`

Do not commit credentials to public XML.

---

## Host network / macvlan issues

**Symptoms:** Container unreachable or wrong IP.

**Fixes:**

- **host:** Port mappings ignored; ensure no port conflicts on host
- **custom:br0:** Requires configured macvlan network; enable host access to custom networks if needed (Settings → Docker)

See [docs/examples/host-network-privileged.xml.example](../examples/host-network-privileged.xml.example) warnings.

---

## GPU / device passthrough

**Symptoms:** `/dev/dri` or NVIDIA devices missing.

**Fixes:**

1. Install Unraid NVIDIA Driver plugin if using NVIDIA
2. Add Device Config entries in template
3. May need `--runtime=nvidia` in ExtraParams (document in Description)
4. Verify `ls -la /dev/dri` on host

---

## Template changes not applied to running container

Editing XML does **not** auto-update running containers.

**Fix:** Edit container manually, or recreate from updated template.

---

## Getting help

1. Search [Unraid forums](https://forums.unraid.net/)
2. Open an [issue](https://github.com/RapalS/UNRAID_DOCKER_TEMPLATES/issues) in this repo
3. Include Unraid version, template name, `docker logs` output, and DNS settings

---

## Back to start

→ [00-getting-started.md](00-getting-started.md)
