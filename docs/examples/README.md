# Reference XML examples

Learning templates for authoring — **not published to Community Applications**.

CA scans every `*.xml` file with a `<Container>` root anywhere in the repository. These files use the `.xml.example` extension so they are excluded from the CA catalog.

| File | Purpose |
|------|---------|
| [base-xml.xml.example](base-xml.xml.example) | Minimal Selfhosters base template |
| [scaffold-starter.xml.example](scaffold-starter.xml.example) | Starter used by `scripts/scaffold-template.ps1` |
| [minimal-bridge.xml.example](minimal-bridge.xml.example) | Smallest valid bridge-network template |
| [with-ports-volumes-env.xml.example](with-ports-volumes-env.xml.example) | Port, Path, and Variable Config examples |
| [host-network-privileged.xml.example](host-network-privileged.xml.example) | Host network + privileged (with warnings) |

**Installable templates** live only in [`templates/`](../../templates/).
