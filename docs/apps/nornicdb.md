# NornicDB

Unraid templates for [NornicDB](https://github.com/orneryd/NornicDB) — graph + vector database with Neo4j Bolt/Cypher compatibility.

Three templates — pick **one** based on your hardware:

| Template | File | Use when |
|----------|------|----------|
| **nornicdb-hermes-memory-cpu** | `templates/nornicdb-hermes-memory-cpu.xml` | AMD64, no GPU |
| **nornicdb-hermes-memory-gpu** | `templates/nornicdb-hermes-memory-gpu.xml` | AMD64 NVIDIA CUDA or Vulkan GPU |
| **nornicdb-hermes-memory-apple-silicon** | `templates/nornicdb-hermes-memory-apple-silicon.xml` | Apple Silicon (M1/M2/M3/M4) |

Ports: **7474** (HTTP/UI), **7687** (Bolt), optional **6334** (Qdrant gRPC).

**Icon:** Official upstream PNG ([raw GitHub](https://raw.githubusercontent.com/orneryd/NornicDB/main/macos/Assets/NornicDB.iconset/icon_1024x1024.png)). Unraid requires PNG — not SVG/WebP.

---

## nornicdb-hermes-memory-cpu

| Branch | Image | Notes |
|--------|-------|-------|
| **cpu-bge** (default) | `timothyswt/nornicdb-cpu-bge:latest` | Web UI + BGE-M3 |
| **cpu-headless** | `timothyswt/nornicdb-amd64-cpu-headless:latest` | API only, no UI |

1. **Docker** → **Add Container** → **nornicdb-hermes-memory-cpu**
2. Branch **cpu-bge** (default)
3. Appdata: `/mnt/user/appdata/nornicdb/`
4. **Apply** → WebUI: `http://YOUR_UNRAID_IP:7474`

---

## nornicdb-hermes-memory-gpu

| Branch | Image | GPU |
|--------|-------|-----|
| **cuda-bge** (default) | `timothyswt/nornicdb-amd64-cuda-bge:latest` | NVIDIA CUDA |
| **cuda-heimdall** | `timothyswt/nornicdb-amd64-cuda-bge-heimdall:latest` | NVIDIA + AI |
| **vulkan-bge** | `timothyswt/nornicdb-amd64-vulkan-bge:latest` | AMD/Intel/NVIDIA Vulkan |

### NVIDIA (cuda-bge / cuda-heimdall)

1. Install **NVIDIA Driver** plugin on Unraid
2. **Add Container** → **nornicdb-hermes-memory-gpu** → branch **cuda-bge**
3. Template sets `--runtime=nvidia` automatically
4. For **cuda-heimdall**, set `NORNICDB_HEIMDALL_ENABLED=true`

### Vulkan (vulkan-bge)

1. **Add Container** → **nornicdb-hermes-memory-gpu** → branch **vulkan-bge**
2. In **Extra Parameters**, remove `--runtime=nvidia` and add `--device=/dev/dri`
   (the template default targets CUDA; Unraid does not always carry per-branch parameters across a version switch)

---

## nornicdb-hermes-memory-apple-silicon

**Apple Silicon only** — M1/M2/M3/M4 Macs with Metal GPU acceleration. Does **not** run on standard AMD64 Unraid servers.

| Branch | Image | Notes |
|--------|-------|-------|
| **metal-bge** (default) | `timothyswt/nornicdb-arm64-metal-bge:latest` | Web UI + BGE-M3 + Metal |
| **metal-headless** | `timothyswt/nornicdb-arm64-metal-headless:latest` | API only, no UI |
| **metal-heimdall** | `timothyswt/nornicdb-arm64-metal-bge-heimdall:latest` | Metal + Heimdall AI |

1. **Docker** → **Add Container** → **nornicdb-hermes-memory-apple-silicon**
2. Branch **metal-bge** (default)
3. Appdata: `/mnt/user/appdata/nornicdb/`
4. **Apply** → WebUI: `http://YOUR_HOST_IP:7474`
5. For **metal-heimdall**, set `NORNICDB_HEIMDALL_ENABLED=true`

---

## Verify

```bash
curl http://YOUR_UNRAID_IP:7474/health
```

Bolt: `bolt://YOUR_UNRAID_IP:7687`

---

## Embeddings (BGE variants)

BGE images bundle `bge-m3` at `/app/models` inside the container.

**Do not** bind-mount an empty host folder to `/app/models` — you will see:

```text
model not found: bge-m3 (expected at /app/models/bge-m3.gguf)
```

---

## Heimdall AI assistant

[Heimdall](https://github.com/orneryd/NornicDB/blob/main/docs/user-guides/heimdall-ai-assistant.md) is NornicDB's built-in AI assistant — natural-language chat with your graph DB via the **Bifrost** panel (helmet icon in the admin UI).

### Quick enable

1. Set `NORNICDB_HEIMDALL_ENABLED=true`
2. Open WebUI → click the helmet icon
3. On **\*-heimdall** image branches (`cuda-heimdall`, `metal-heimdall`), the GGUF model is bundled — use provider **local** (default)

### Provider options

| Provider | When to use | Key variables |
|----------|-------------|---------------|
| **local** | Bundled or custom GGUF in `/app/models` | `NORNICDB_HEIMDALL_MODEL` (name without `.gguf`), `NORNICDB_HEIMDALL_GPU_LAYERS` (`-1`=auto) |
| **ollama** | Ollama already running on your network | `NORNICDB_HEIMDALL_PROVIDER=ollama`, `NORNICDB_HEIMDALL_API_URL=http://YOUR_OLLAMA_IP:11434`, optional `NORNICDB_HEIMDALL_MODEL=llama3.2` |
| **openai** | OpenAI or compatible API (Azure, local proxy) | `NORNICDB_HEIMDALL_PROVIDER=openai`, `NORNICDB_HEIMDALL_API_KEY=sk-...`, optional `NORNICDB_HEIMDALL_MODEL=gpt-4o-mini` |

All Heimdall variables are exposed in the template under **Advanced View**.

### Recommended local models (BYOM)

| Model | Size | Notes |
|-------|------|-------|
| `qwen3-0.6b-instruct` | ~469 MB | Default — fast, basic commands |
| `qwen2.5-1.5b-instruct-q4_k_m` | ~1 GB | Recommended balance |
| `qwen2.5-3b-instruct-q4_k_m` | ~2 GB | Better quality, slower |

Do **not** mount an empty folder over `/app/models` — it hides bundled models. To use custom GGUF files, mount your models directory with the files already present.

### Tuning (optional)

| Variable | Default | Purpose |
|----------|---------|---------|
| `NORNICDB_HEIMDALL_MAX_TOKENS` | `1024` | Max response length |
| `NORNICDB_HEIMDALL_TEMPERATURE` | `0.5` | Creativity (0.0–1.0) |
| `NORNICDB_HEIMDALL_GPU_LAYERS` | `-1` | Local only: GPU offload (`0`=CPU, `999`=all) |

### API access

Heimdall exposes OpenAI-compatible endpoints on the same port as the WebUI:

- `POST http://YOUR_IP:7474/v1/chat/completions`
- `GET http://YOUR_IP:7474/api/bifrost/status`

Use with Continue IDE, OpenAI SDK, or any OpenAI-compatible client — set `base_url` to `http://YOUR_IP:7474/v1`.

---

## Qdrant gRPC

1. Set `NORNICDB_QDRANT_GRPC_ENABLED=true`
2. Map port **6334**

---

## Security

Default `NORNICDB_NO_AUTH=true` — fine for LAN/lab. Do not expose 7474/7687 to the internet without auth.

---

## Backup

Back up `/mnt/user/appdata/nornicdb/data` while the container is stopped.

---

## Links

- [Upstream README](https://github.com/orneryd/NornicDB)
- [Docker image matrix](https://github.com/orneryd/NornicDB/blob/main/docs/getting-started/image-quick-reference.md)
- [Heimdall AI assistant guide](https://github.com/orneryd/NornicDB/blob/main/docs/user-guides/heimdall-ai-assistant.md)

## Tested

- Unraid: 7.3.1
- Server: 192.168.1.10
- Image: `timothyswt/nornicdb-cpu-bge:latest`
