# XML Reference

Unraid Docker template reference for `<Container version="2">`, aligned with [Selfhosters — Writing a template compatible for Unraid](https://selfhosters.net/docker/templating/templating/) and the [CA XML field reference](https://ca.unraid.net/submit/help/xml-field-reference).

---

## Manual authoring

### Starting from scratch (base XML)

Selfhosters base template — also shipped as [`docs/examples/base-xml.xml.example`](../examples/base-xml.xml.example):

```xml
<?xml version="1.0"?>
<Container version="2">
  <Name></Name>
  <Repository></Repository>
  <Registry></Registry>
  <Network>bridge</Network>
  <Privileged>false</Privileged>
  <Support></Support>
  <Project></Project>
  <Overview></Overview>
  <WebUI></WebUI>
  <TemplateURL/>
  <Icon>/plugins/dynamix.docker.manager/images/question.png</Icon>
  <ExtraParams/>
  <PostArgs/>
  <DonateText/>
  <DonateLink/>
</Container>
```

Copy [`docs/examples/scaffold-starter.xml.example`](../examples/scaffold-starter.xml.example) for a pre-filled starter with example `<Config>` entries, or use [`docs/examples/base-xml.xml.example`](../examples/base-xml.xml.example) for the minimal Selfhosters base.

### Fill the base

| Tag | Expected value |
|-----|----------------|
| `Name` | Container name; **prefer lowercase** |
| `Repository` | Image to pull, e.g. `domistyle/idrac6` or `ghcr.io/author/app:tag` |
| `Registry` | Registry page, e.g. `https://hub.docker.com/r/domistyle/idrac6/` |
| `Network` | Usually `bridge` unless upstream requires `host` or custom network |
| `Support` | Unraid forum support thread (preferred for CA) |
| `Project` | Upstream GitHub or homepage |
| `Overview` | Primary description shown in CA and Add Container |
| `WebUI` | `http://[IP]:[PORT:5800]` — `[PORT:n]` is **container port**; Unraid resolves host mapping |
| `TemplateURL` | **Raw** GitHub URL, must start with `https://raw.githubusercontent.com/` |
| `Icon` | **HTTPS** direct link to **PNG** (128×128). Do not use SVG or WebP — Unraid shows question mark or blank ([R3755](https://forums.unraid.net/bug-reports/stable-releases/custom-docker-icons-by-path-w-svg-or-webp-icons-unexpected-behavior-r3755/)) |
| `ExtraParams` | Extra `docker run` flags, e.g. `--restart unless-stopped` |
| `PostArgs` | Command run inside container after start (advanced) |
| `DonateText` / `DonateLink` | **Deprecated** — use `ca_profile.xml` instead |

### Add a Config entry

Universal syntax (attributes vary by `Type`):

```xml
<Config Name="" Target="" Default="" Mode="" Description=""
        Type="Path|Variable|Port|Device|Label"
        Display="always|always-hide|advanced|advanced-hide"
        Required="false" Mask="false"/>
```

#### Type: Path (volume)

| Attribute | Meaning |
|-----------|---------|
| `Target` | Container path, e.g. `/config` |
| `Mode` | `rw` (read/write), `ro` (read-only); slave options supported |
| `Type` | Always `Path` |
| `Default` / body | Host path, e.g. `/mnt/user/appdata/idrac` |

#### Type: Variable

| Attribute | Meaning |
|-----------|---------|
| `Target` | Environment variable name, e.g. `IDRAC_HOST` |
| `Type` | Always `Variable` |
| `Mask` | `true` to hide secrets |

#### Type: Port

| Attribute | Meaning |
|-----------|---------|
| `Target` | **Container** port, e.g. `5800` |
| `Mode` | `tcp` or `udp` |
| `Type` | Always `Port` |

#### Shared Config attributes

| Attribute | Meaning |
|-----------|---------|
| `Name` | Label in template manager, e.g. `Appdata`, `WebUI`, `PUID` |
| `Description` | Help text for this setting |
| `Default` | Suggested value; use `value1\|value2` for dropdowns (see Tips) |
| `Display` | See table below |
| `Required` | `true` if user cannot proceed without a value |
| `Mask` | Mask value with asterisks (variables only) |

**Display values** ([Selfhosters](https://selfhosters.net/docker/templating/templating/#shared-attributes)):

| Value | Behavior |
|-------|----------|
| `always` | Always visible; editable in basic view |
| `always-hide` | Always visible; **cannot** edit/delete in basic view |
| `advanced` | Shown after **Show more settings…**; editable in basic view |
| `advanced-hide` | Shown after **Show more settings…**; **cannot** edit/delete in basic view |

---

## Tips and tricks

### Limit values to a dropdown

Set `Default` with pipe-separated options:

```xml
<Config Name="keyboard fix" Target="IDRAC_KEYCODE_HACK" Default="false|true"
        Type="Variable" Display="advanced-hide" ...>false</Config>
```

Highly recommended for booleans.

### Categorization

Use the **Application Categorizer** plugin to generate `<Category>` tags for CA discoverability.

---

## Container fields (alphabetical)

From Selfhosters XML field explanations (Unraid 6.10+). Include only what applies.

| Tag | Purpose |
|-----|---------|
| `Banner` | URL to banner image (direct PNG link) |
| `Beta` | `true` shows beta warning in CA |
| `Branch` | Offer multiple image branches/tags to user |
| `Tag` | Docker image tag, e.g. `latest` |
| `TagDescription` | Description shown when user picks a tag |
| `Category` | CA categories; use Application Categorizer |
| `Changes` | Template changelog (Markdown only) — template changes, **not** app releases |
| `Config` | User-facing setting — see above |
| `Date` | Internal — **do NOT include** |
| `DateInstalled` | Internal — **do NOT include** |
| `Description` | **Deprecated** — use `Overview`; still accepted by many CA flows |
| `DonateText` / `DonateLink` | **Deprecated** — use repository `ca_profile.xml` |
| `ExtraParams` | Additional `docker run` parameters |
| `ExtraSearchTerms` | Space-separated CA search keywords |
| `Icon` | HTTPS icon URL; theme variants: `Icon-black`, `Icon-white`, `Icon-azure`, `Icon-gray` |
| `License` | Container license info |
| `Maintainer` | Template maintainer info (shown in CA) |
| `WebPage` | Maintainer contact / personal site |
| `Name` | Template name in CA search and Add Container |
| `Network` | `bridge`, `host`, or custom network name |
| `Overview` | Primary description in CA and install UI |
| `Privileged` | Avoid `true` unless required |
| `Project` | Upstream project URL |
| `ReadMe` | Readme URL; shown in Docker tab context menu |
| `Registry` | Link to image registry page |
| `Repository` | `registry/author/app:tag` pattern |
| `Requires` | Prerequisites warning in CA and install UI |
| `Screenshot` | CA store screenshot (multiple tags allowed) |
| `Shell` | `sh` or `bash` for exec — **omit if unsure** (can break containers) |
| `Support` | Unraid forum support thread URL |
| `TemplateURL` | Raw GitHub XML URL |
| `Video` | Promotional video link in CA |
| `WebUI` | `http://[IP]:[PORT:5000]` pattern; enables WebUI in Docker context menu |

Forum schema reference: [Docker template XML schema](https://forums.unraid.net/topic/38619-docker-template-xml-schema/)

---

## WebUI tokens

| Token | Replaced with |
|-------|---------------|
| `[IP]` | Unraid server IP |
| `[PORT:5800]` | Host port mapped to **container** port 5800 |

Examples:

```
http://[IP]:[PORT:8080]
https://[IP]:[PORT:8443]
http://[IP]:[PORT:8080]/admin
```

---

## Network modes

| Value | Use case |
|-------|----------|
| `bridge` | Default; map ports via `Type="Port"` Config |
| `host` | Shares host network; Port configs ignored |
| `custom:br0` | Macvlan / own LAN IP |

---

## PUID / PGID

Unraid defaults: user `nobody` = **99**, group `users` = **100**.

Some images use `USER_ID` / `GROUP_ID` instead of `PUID` / `PGID` — match upstream env names in `Target`.

---

## Legacy blocks (remove before publish)

CA exports may include duplicate legacy sections:

```xml
<Networking>...</Networking>
<Data><Volume>...</Volume></Data>
<Environment><Variable>...</Variable></Environment>
```

Keep **only** `<Config>` entries. See [04-cleaning-xml.md](04-cleaning-xml.md).

---

## CA submission minimum

Per [CA Repository XML format](https://ca.unraid.net/submit/help/repository-xml):

- `Name`, `Repository`, `Overview`, `Description` (still requested by CA pipeline)
- `Support`, `Project`, `TemplateURL`, `Category`
- `WebUI` when the app has a web interface

This repo puts install notes in `Overview` first; add `Description` when CA scan requires it or for long Markdown guides.

---

## Examples in this repo

| File | Demonstrates |
|------|--------------|
| [docs/examples/base-xml.xml.example](../examples/base-xml.xml.example) | Selfhosters empty base |
| [docs/examples/minimal-bridge.xml.example](../examples/minimal-bridge.xml.example) | Minimal valid template |
| [docs/examples/with-ports-volumes-env.xml.example](../examples/with-ports-volumes-env.xml.example) | Port, Path, Variable |
| [docs/examples/host-network-privileged.xml.example](../examples/host-network-privileged.xml.example) | Host + privileged (with warnings) |
| [docs/examples/scaffold-starter.xml.example](../examples/scaffold-starter.xml.example) | Scaffold source for new templates |
| [templates/](../templates/) | Published templates (see [TEMPLATE_INDEX.md](TEMPLATE_INDEX.md)) |

---

## Next step

→ [04-cleaning-xml.md](04-cleaning-xml.md)
