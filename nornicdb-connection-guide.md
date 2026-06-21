# NornicDB — Connection Reference (Unraid / Docker)

NornicDB is a Neo4j-compatible graph + vector + temporal database. It speaks the **Neo4j Bolt protocol**, so any Neo4j driver or Cypher-capable client can connect to it.

---

## Quick reference

| Protocol | Default port | URI format |
|----------|-------------|------------|
| Neo4j Bolt | `7687` | `bolt://UNRAID_IP:7687` |
| HTTP / REST API | `7474` | `http://UNRAID_IP:7474` |
| gRPC / vector (optional) | `6334` | `UNRAID_IP:6334` |

Replace `UNRAID_IP` with your server's LAN IP address (e.g. `192.168.1.10`).

Most client applications connect via **Bolt on port 7687**. The HTTP port is used for the admin UI, health checks, and REST endpoints.

---

## Prerequisites

Before connecting from a client:

1. The NornicDB Docker container is **running** on Unraid.
2. Container ports are **published** to the host (see §3).
3. You know whether authentication is enabled (default: disabled — `NORNICDB_NO_AUTH=true`).
4. Client and Unraid server are reachable on the same network or across a configured route.

---

## Port mapping

Verify the container has the required host port bindings under **Docker → container → Edit** in the Unraid UI:

| Container port | Host port | Required for |
|----------------|-----------|--------------|
| `7474` | `7474` | HTTP API, admin UI, health endpoints |
| `7687` | `7687` | Neo4j Bolt — all driver connections |
| `6334` | `6334` | gRPC / vector API (optional) |

If port `7687` is not published, Bolt connections from external hosts will be refused.

### Docker CLI reference

CPU image:

```bash
docker run -d \
  --name nornicdb \
  -p 7474:7474 \
  -p 7687:7687 \
  -v /mnt/user/appdata/nornicdb/data:/data \
  timothyswt/nornicdb-amd64-cpu-bge:latest
```

NVIDIA GPU image:

```bash
docker run -d \
  --name nornicdb \
  --gpus all \
  -p 7474:7474 \
  -p 7687:7687 \
  -v /mnt/user/appdata/nornicdb/data:/data \
  timothyswt/nornicdb-amd64-cuda-bge:latest
```

With optional gRPC port:

```bash
docker run -d \
  --name nornicdb \
  -p 7474:7474 \
  -p 7687:7687 \
  -p 6334:6334 \
  -v /mnt/user/appdata/nornicdb/data:/data \
  timothyswt/nornicdb-amd64-cpu-bge:latest
```

> **Always use the Unraid server IP from external clients — not `localhost` or `127.0.0.1`.**

---

## Connectivity testing

### Linux / macOS / WSL

```bash
# Netcat
nc -zv 192.168.1.10 7687
nc -zv 192.168.1.10 7474

# Pure bash (no netcat required)
timeout 3 bash -lc '</dev/tcp/192.168.1.10/7687' && echo OK || echo FAIL
timeout 3 bash -lc '</dev/tcp/192.168.1.10/7474' && echo OK || echo FAIL
```

### Windows PowerShell

```powershell
Test-NetConnection 192.168.1.10 -Port 7687
Test-NetConnection 192.168.1.10 -Port 7474
```

Expected result: `TcpTestSucceeded : True`

### HTTP health check

```bash
curl http://192.168.1.10:7474/status
curl http://192.168.1.10:7474/health
```

A JSON response confirms the HTTP interface is reachable.

---

## Python driver

### Installation

```bash
pip install neo4j
```

### Connect (no authentication)

```python
from neo4j import GraphDatabase

URI  = "bolt://192.168.1.10:7687"
AUTH = None

driver = GraphDatabase.driver(URI, auth=AUTH)

with driver.session() as session:
    result = session.run("RETURN 1 AS ok")
    print(result.single()["ok"])  # Expected: 1

driver.close()
```

### Connect (with authentication)

```python
from neo4j import GraphDatabase

URI  = "bolt://192.168.1.10:7687"
AUTH = ("neo4j", "YOUR_PASSWORD")

driver = GraphDatabase.driver(URI, auth=AUTH)

with driver.session() as session:
    result = session.run("RETURN 1 AS ok")
    print(result.single()["ok"])

driver.close()
```

### Write a node

```python
from neo4j import GraphDatabase

driver = GraphDatabase.driver("bolt://192.168.1.10:7687", auth=None)

with driver.session() as session:
    session.run(
        """
        CREATE (n:TestMemory {
            title:      $title,
            content:    $content,
            source:     $source,
            created_at: datetime()
        })
        """,
        title="Connection test",
        content="Written from Python client.",
        source="python-test",
    )
    count = session.run(
        "MATCH (n:TestMemory) RETURN count(n) AS n"
    ).single()["n"]
    print("TestMemory count:", count)

driver.close()
```

### Read nodes

```python
from neo4j import GraphDatabase

driver = GraphDatabase.driver("bolt://192.168.1.10:7687", auth=None)

with driver.session() as session:
    rows = session.run(
        """
        MATCH (n:TestMemory)
        RETURN n.title AS title, n.content AS content, n.created_at AS created_at
        ORDER BY n.created_at DESC
        LIMIT 10
        """
    )
    for row in rows:
        print(row["title"], "—", row["content"])

driver.close()
```

### Delete test nodes

```python
from neo4j import GraphDatabase

driver = GraphDatabase.driver("bolt://192.168.1.10:7687", auth=None)

with driver.session() as session:
    session.run(
        "MATCH (n:TestMemory {source: 'python-test'}) DELETE n"
    )

driver.close()
```

> `DELETE` in Cypher is irreversible. Scope your queries to test labels before running against production data.

---

## Node.js driver

### Installation

```bash
npm install neo4j-driver
```

### Connect (no authentication)

```javascript
const neo4j = require('neo4j-driver')

const driver = neo4j.driver('bolt://192.168.1.10:7687')

async function main() {
  const session = driver.session()
  try {
    const result = await session.run('RETURN 1 AS ok')
    console.log(result.records[0].get('ok').toNumber()) // Expected: 1
  } finally {
    await session.close()
    await driver.close()
  }
}

main().catch(console.error)
```

### Connect (with authentication)

```javascript
const neo4j = require('neo4j-driver')

const driver = neo4j.driver(
  'bolt://192.168.1.10:7687',
  neo4j.auth.basic('neo4j', 'YOUR_PASSWORD')
)
```

---

## Neo4j Browser / GUI clients

| Field | Value |
|-------|-------|
| Connect URL | `bolt://192.168.1.10:7687` |
| Username | blank (or `neo4j` if the tool requires a non-empty value) |
| Password | blank when auth is disabled |

If a tool forces credentials even when auth is off, try `neo4j` / `(empty)`. If that fails, auth is likely enabled on the server — supply the correct password.

---

## Hermes Agent integration

Hermes connects to NornicDB through its memory provider plugin via environment variables.

### `.env` configuration

No authentication:

```bash
NORNICDB_URI=bolt://192.168.1.10:7687
NORNICDB_USER=
NORNICDB_PASSWORD=
```

With authentication:

```bash
NORNICDB_URI=bolt://192.168.1.10:7687
NORNICDB_USER=neo4j
NORNICDB_PASSWORD=YOUR_PASSWORD
```

### Activate the provider

```bash
hermes config set memory.provider nornicdb
```

### Restart the gateway

```bash
hermes gateway restart
```

> Restart from a terminal session, not from within an agent interface (Discord, Telegram, etc.).

### Verify

```bash
hermes memory status
```

Expected output includes `provider: nornicdb` and `connected: true`.

---

## Embedding configuration

NornicDB images with `bge` in the name include BGE-M3 embedding support (e.g. `timothyswt/nornicdb-amd64-cpu-bge:latest`).

### Local / bundled model (default)

```bash
NORNICDB_EMBEDDING_ENABLED=true
NORNICDB_EMBEDDING_PROVIDER=local
NORNICDB_EMBEDDING_MODEL=bge-m3
NORNICDB_EMBEDDING_DIMENSIONS=1024
```

### Ollama embedder

```bash
NORNICDB_EMBEDDING_ENABLED=true
NORNICDB_EMBEDDING_PROVIDER=ollama
NORNICDB_EMBEDDING_API_URL=http://192.168.1.2:11434
NORNICDB_EMBEDDING_MODEL=mxbai-embed-large
NORNICDB_EMBEDDING_DIMENSIONS=1024
```

### Embedding status

```bash
curl http://192.168.1.10:7474/nornicdb/embed/stats
```

### Trigger re-embedding

```bash
curl -X POST 'http://192.168.1.10:7474/nornicdb/embed/trigger?regenerate=true'
```

---

## Vector indexing and search (Cypher)

### Create a vector index

```cypher
CREATE VECTOR INDEX memoryEmbeddings IF NOT EXISTS
FOR (n:Memory) ON (n.embedding)
OPTIONS {
  indexConfig: {
    `vector.dimensions`: 1024,
    `vector.similarity_function`: 'cosine'
  }
}
```

### Query by text (server-side embedding required)

```cypher
CALL db.index.vector.queryNodes('memoryEmbeddings', 10, 'your query text')
YIELD node, score
RETURN node.content AS content, score
ORDER BY score DESC
```

### Query by pre-computed vector

```cypher
CALL db.index.vector.queryNodes('memoryEmbeddings', 10, $queryVector)
YIELD node, score
RETURN node.content AS content, score
ORDER BY score DESC
```

### Model dimension reference

| Embedding model | Dimensions |
|-----------------|-----------|
| `bge-m3` | 1024 |
| `mxbai-embed-large` | 1024 |
| `text-embedding-3-small` (OpenAI) | 1536 |
| `text-embedding-3-large` (OpenAI) | 3072 |

Vector dimensions must match the index configuration exactly.

---

## Troubleshooting

Work through these checks in order.

### 1. Container running?

Unraid UI → Docker tab → confirm the NornicDB container status is **running**. Start it if stopped.

### 2. Ports published?

Unraid UI → container → Edit. Confirm:

```
7474 (container) → 7474 (host)
7687 (container) → 7687 (host)
```

### 3. TCP reachable from client?

```bash
nc -zv 192.168.1.10 7687
```

Failure here is a network, port-mapping, or firewall issue — not an application issue.

### 4. HTTP API responding?

```bash
curl http://192.168.1.10:7474/status
```

If HTTP works but Bolt (`7687`) does not, verify port `7687` is published (see step 2).

### 5. Minimal Bolt smoke test

```python
from neo4j import GraphDatabase

driver = GraphDatabase.driver("bolt://192.168.1.10:7687", auth=None)
with driver.session() as session:
    print(session.run("RETURN 1 AS ok").single()["ok"])
driver.close()
```

Output `1` confirms the connection is fully operational. Any error at this point is driver, auth, or server-side configuration.

---

## Common mistakes

| Mistake | Cause | Fix |
|---------|-------|-----|
| `bolt://localhost:7687` from external client | `localhost` resolves to the client machine | Use the Unraid server IP |
| Port 7474 works, 7687 refused | Bolt port not published | Add `-p 7687:7687` or the equivalent Unraid template Config entry |
| Auth error with `auth=None` | Server has auth enabled | Provide `("neo4j", "PASSWORD")` in the driver call |
| Custom network IP mismatch | Container assigned its own IP | Connect to the container's IP (e.g. `192.168.1.50`), not the Unraid host IP |
| Data lost after container update | No host volume mount | Mount `/mnt/user/appdata/nornicdb/data` → `/data` |
| Client unreachable cross-subnet | VLAN / firewall rule | Place client and server on the same subnet, or open the required ports on the router/firewall |

---

## Data persistence and operational notes

Always bind-mount the data directory so the database survives container rebuilds:

```
/mnt/user/appdata/nornicdb/data  →  /data  (read/write)
```

**Before modifying the container template**, record the current configuration:

- Image name and tag
- Container name
- Port mappings
- Volume mappings
- Environment variables
- Network type

**Back up the data directory before major changes:**

```bash
cp -a /mnt/user/appdata/nornicdb/data /mnt/user/appdata/nornicdb/data.bak
```

Do not change exposed ports without updating all upstream clients.

---

## Connection parameter checklist

Fill in before distributing to consumers:

```
Unraid server IP : ___________________________
HTTP API URL     : http://___________________________:7474
Bolt URI         : bolt://___________________________:7687
Authentication   : enabled / disabled
Username         : ___________________________ (or leave blank)
Password         : ___________________________ (or leave blank)
```

Minimal connectivity test (copy/paste):

```bash
pip install neo4j -q && python3 - <<'PY'
from neo4j import GraphDatabase
URI  = "bolt://192.168.1.10:7687"   # <-- update
AUTH = None                          # <-- set ("user","pass") if auth is enabled
driver = GraphDatabase.driver(URI, auth=AUTH)
with driver.session() as session:
    print(session.run("RETURN 1 AS ok").single()["ok"])
driver.close()
PY
```

Output `1` confirms the full path from client → network → Docker → NornicDB is working.
