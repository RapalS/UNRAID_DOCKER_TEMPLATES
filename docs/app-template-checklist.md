# App Template Checklist



Use this checklist for **every new template** before opening a pull request.  

Aligned with [Selfhosters templating](https://selfhosters.net/docker/templating/templating/) and this repo's validation scripts.



---



## Upstream research



- [ ] Read upstream Docker README / documentation (primary source for Config entries)

- [ ] Confirmed correct image name and tag (`Repository`)

- [ ] Listed all required environment variables

- [ ] Listed all exposed ports (TCP/UDP) — WebUI uses **container** port in `[PORT:n]`

- [ ] Listed all volume mounts for persistent data

- [ ] Noted GPU, privileged, or host network requirements

- [ ] Checked if app already exists in official CA (avoid duplicates)



---



## XML file



- [ ] File at `templates/<app-name>.xml` (lowercase, hyphenated)

- [ ] Based on [`examples/scaffold-starter.xml`](../examples/scaffold-starter.xml), [`examples/base-xml.xml`](../examples/base-xml.xml), or cleaned CA export

- [ ] GitHub URLs use `RapalS` (or your fork username if publishing separately)

- [ ] `<Name>` lowercase; `<Repository>` and `<Registry>` correct

- [ ] `<Overview>` has primary description (preferred over deprecated `<Description>`)

- [ ] `<Support>` — Unraid forum thread for CA; GitHub issues OK for personal/third-party drafts

- [ ] `<Project>` points to upstream repo

- [ ] `<TemplateURL>` is **raw** `https://raw.githubusercontent.com/...` URL

- [ ] `<Category>` set via Application Categorizer plugin when possible

- [ ] `<WebUI>` uses container port: `http://[IP]:[PORT:n]` or `https://...`

- [ ] All `<Config>` entries: correct Type, Target, Required, Mask, Display

- [ ] Boolean vars use `Default="false|true"` pipe syntax where applicable

- [ ] Default appdata path: `/mnt/user/appdata/<app-name>/`

- [ ] PUID/PGID (or USER_ID/GROUP_ID) match upstream env names; defaults 99/100

- [ ] **Removed:** `<Date>`, `<DateInstalled>`, `<Shell>` (unless shell verified)

- [ ] **Removed:** empty tags, legacy `<Networking>` / `<Data>` / `<Environment>`

- [ ] Validated: `scripts/validate-template.ps1` passes



---



## Icon



- [ ] `<Icon>` is an **HTTPS PNG** URL — the app's upstream raw icon (SVG/WebP/local paths fail in Unraid UI)

- [ ] Icon is 128×128 (or close); resolves with HTTP 200

- [ ] If reusing a third-party icon, license/attribution confirmed



---



## Testing on Unraid



- [ ] Template Authoring Mode used OR manual XML validated

- [ ] Template appears in Add Container dropdown

- [ ] Image pulls successfully

- [ ] Container starts without crash loop

- [ ] WebUI or core functionality verified

- [ ] Appdata persists after container restart

- [ ] Tested on Unraid version: _______________

- [ ] Server IP used for test: _______________



---



## Documentation



- [ ] `docs/TEMPLATE_INDEX.md` regenerated (`python scripts/generate_template_index.py`)

- [ ] Optional `docs/apps/<app-name>.md` for complex setup

- [ ] `<Overview>` or `<Description>` covers non-obvious post-install steps



---



## Community Applications (optional)

- [ ] [`ca_profile.xml`](../ca_profile.xml) uses `<CommunityApplications>` with non-empty `<Profile>` ([docs](https://ca.unraid.net/submit/help/repository-info-xml))
- [ ] `<WebPage>` and `<Icon>` set in `ca_profile.xml` (no placeholders)
- [ ] Public repo with OSI license ([MIT](../LICENSE) — [GitHub licensing guide](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository))
- [ ] `python scripts/validate.py --strict templates ca_profile.xml` passes locally
- [ ] Scan-ready at [ca.unraid.net/submit/new](https://ca.unraid.net/submit/new) (Validate → Scan clean)
- [ ] Unraid forum support thread created and linked in `<Support>` / `ca_profile.xml` `<Forum>`
- [ ] Donation links in `ca_profile.xml`, not per-template XML



---



## PR



- [ ] PR template checklist completed

- [ ] CI workflow green

