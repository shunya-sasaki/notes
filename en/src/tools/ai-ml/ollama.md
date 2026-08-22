# <iconify-icon icon="selfhst:ollama" style="vertical-align: middle;"></iconify-icon>Ollama

![Ollama](https://img.shields.io/badge/Ollama-000000?logo=ollama&labelColor=gray&logoColor=white)
<!-- toc -->

- [What is Ollama?](#what-is-ollama)
- [Install](#install)
  - [macOS](#macos)
  - [Linux](#linux)
  - [Windows](#windows)
  - [Docker](#docker)
- [Setup](#setup)
  - [Start the server](#start-the-server)
  - [Environment variables](#environment-variables)
  - [Context length](#context-length)
  - [Sign in for cloud models](#sign-in-for-cloud-models)
- [Usage](#usage)
  - [CLI](#cli)
  - [Interactive session commands](#interactive-session-commands)
  - [Modelfile](#modelfile)
  - [REST API](#rest-api)
  - [OpenAI and Anthropic compatible APIs](#openai-and-anthropic-compatible-apis)
  - [Coding agent integrations](#coding-agent-integrations)
  - [Web search](#web-search)
- [Choosing a Model](#choosing-a-model)
  - [By VRAM budget](#by-vram-budget)
  - [By use case](#by-use-case)
- [Local LLM Model Families (2026)](#local-llm-model-families-2026)
- [Recommended Models for AI Agent Development](#recommended-models-for-ai-agent-development)
  - [Tier 1 — Excellent](#tier-1--excellent)
  - [Tier 2 — Very Good](#tier-2--very-good)
  - [Tier 3 — Specialized](#tier-3--specialized)
- [Notes](#notes)
  - [Qwen](#qwen)
  - [Gemma](#gemma)
  - [gpt-oss](#gpt-oss)
  - [DeepSeek](#deepseek)
  - [Ornith](#ornith)
  - [GLM](#glm)
  - [Kimi](#kimi)
  - [LFM (Liquid Foundation Models)](#lfm-liquid-foundation-models)
  - [Nemotron](#nemotron)
  - [Llama](#llama)
  - [Mistral](#mistral)
  - [Phi](#phi)
  - [MiniMax](#minimax)
  - [MiniCPM](#minicpm)
  - [InternLM](#internlm)
  - [Yi](#yi)
  - [OLMo](#olmo)
  - [SmolLM](#smollm)

<!-- /toc -->

👉 [Official Ollama page](https://ollama.com/)
👉 [Documentation](https://docs.ollama.com/)
👉 [Model library](https://ollama.com/library)
👉 [GitHub Repository](https://github.com/ollama/ollama)

## What is Ollama?

Ollama is an open-source runtime that downloads, manages, and serves
large language models on your own machine.
It bundles the inference engine, a model registry client,
and an HTTP server behind a single CLI,
so running a model is one command instead of a build pipeline.

Key features:

- **One-command models** - `ollama run <model>` pulls, loads, and starts a chat.
- **Local HTTP API** - Serves on `http://localhost:11434` for any application to use.
- **OpenAI / Anthropic compatibility** - Drop-in `/v1/chat/completions`
  and `/v1/messages` endpoints work with existing SDKs and coding agents.
- **GPU acceleration** - Apple Silicon (Metal), NVIDIA (CUDA), and AMD (ROCm).
- **Capabilities** - Tool calling, thinking / reasoning modes, vision,
  audio, structured outputs, and embeddings.
- **Cloud models** - Models tagged `:cloud` run on Ollama's datacenter hardware
  with the exact same commands and API as local models.
- **Modelfile** - Customize system prompts, parameters, and templates,
  then share the result through the registry.

## Install

### macOS

Requires macOS Sonoma (v14) or newer.
Apple M series gets CPU and GPU support; x86 is CPU only.

👉 [Download the macOS app](https://ollama.com/download/mac)

Or install with Homebrew:

```sh
brew install --cask ollama-app
```

### Linux

**Option 1. Install script**:

```sh
curl -fsSL https://ollama.com/install.sh | sh
```

---

**Option 2. Manual install**:

```sh
curl -fsSL https://ollama.com/download/ollama-linux-amd64.tar.zst \
    | sudo tar x -C /usr
```

For an AMD GPU, extract the additional ROCm package as well:

```sh
curl -fsSL https://ollama.com/download/ollama-linux-amd64-rocm.tar.zst \
    | sudo tar x -C /usr
```

### Windows

👉 [Download the Windows installer](https://ollama.com/download/windows)

### Docker

```sh
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
```

With an NVIDIA GPU, add `--gpus=all`.

## Setup

### Start the server

The desktop app starts the server automatically.
To run it manually:

```sh
ollama serve
```

Verify it is running:

```sh
ollama -v
curl http://localhost:11434/api/version
```

### Environment variables

Set these before `ollama serve`.
Run `ollama serve --help` for the full list.

| Variable                   | Purpose                                 | Default             |
| -------------------------- | --------------------------------------- | ------------------- |
| `OLLAMA_HOST`              | Address the server binds to             | `127.0.0.1:11434`   |
| `OLLAMA_MODELS`            | Directory where model blobs are stored  | `~/.ollama/models`  |
| `OLLAMA_CONTEXT_LENGTH`    | Default context length                  | 4k/32k/256k by VRAM |
| `OLLAMA_KEEP_ALIVE`        | How long a model stays loaded in memory | `5m`                |
| `OLLAMA_NUM_PARALLEL`      | Maximum number of parallel requests     | auto                |
| `OLLAMA_MAX_LOADED_MODELS` | Maximum loaded models per GPU           | auto                |
| `OLLAMA_FLASH_ATTENTION`   | Enable flash attention                  | off                 |
| `OLLAMA_KV_CACHE_TYPE`     | Quantization type for the K/V cache     | `f16`               |
| `OLLAMA_NO_CLOUD`          | Disable cloud inference and web search  | off                 |
| `OLLAMA_DEBUG`             | Show additional debug information       | off                 |

> [!TIP]
> To expose Ollama to your LAN, set `OLLAMA_HOST=0.0.0.0:11434`.
> Ollama has no authentication, so only do this on a trusted network.

### Context length

Ollama picks a default context length from available VRAM:

| VRAM      | Default context |
| --------- | --------------- |
| < 24 GiB  | 4k              |
| 24–48 GiB | 32k             |
| >= 48 GiB | 256k            |

Agents, coding tools, and web search need much more than the 4k default.
Set at least 64k for those workloads:

```sh
OLLAMA_CONTEXT_LENGTH=64000 ollama serve
```

A larger context length costs more memory, so make sure the VRAM is there.
Cloud models are always set to their maximum context length.

### Sign in for cloud models

Cloud models carry the `:cloud` suffix and run on Ollama's servers
while keeping the local CLI and API surface identical.

```sh
ollama signin
ollama run gpt-oss:120b-cloud
```

👉 [Cloud model list](https://ollama.com/search?c=cloud)

## Usage

### CLI

```sh
# Pull a model without running it
ollama pull gemma4

# Run a model (pulls it first if missing)
ollama run gemma4

# One-shot prompt
ollama run gemma4 "Explain why the sky is blue in one paragraph."

# Pipe input from stdin
cat report.md | ollama run gemma4 "Summarize this in three bullets."

# Multimodal input: pass an image path in the prompt
ollama run gemma4 "What's in this image? ./diagram.png"

# Enable or tune thinking mode
ollama run qwen3.5 --think=high "Design a rate limiter."
ollama run qwen3.5 --think=false "What is 2 + 2?"

# JSON output
ollama run gemma4 --format json "List three colors as {\"colors\": []}"

# Show timings
ollama run gemma4 --verbose "Hello"

# Embeddings
ollama run embeddinggemma "Hello world"

# Model management
ollama list          # installed models
ollama ps            # currently loaded models
ollama show gemma4   # parameters, template, license
ollama stop gemma4   # unload from memory
ollama rm gemma4     # delete
ollama cp gemma4 my-gemma
```

### Interactive session commands

Inside `ollama run`, lines starting with `/` are commands:

| Command            | Description                       |
| ------------------ | --------------------------------- |
| `/bye`             | Exit the session                  |
| `/?`               | Show help                         |
| `/set parameter …` | Change a runtime parameter        |
| `/set system …`    | Set the system prompt             |
| `/show info`       | Show details of the current model |
| `/clear`           | Clear the conversation context    |
| `/save <name>`     | Save the session as a new model   |

Wrap multiline input in `"""`:

```text
>>> """Hello,
... world!
... """
```

### Modelfile

A `Modelfile` layers a system prompt, parameters, and a template
on top of an existing model.

```dockerfile
FROM qwen3.5:9b

PARAMETER temperature 0.3
PARAMETER num_ctx 65536

SYSTEM """
You are a terse Rust reviewer.
Answer with a diff whenever possible.
"""
```

Build and run it:

```sh
ollama create rust-reviewer -f Modelfile
ollama run rust-reviewer
```

👉 [Modelfile reference](https://docs.ollama.com/modelfile)

### REST API

The server listens on `http://localhost:11434`.

| Method | Endpoint        | Description                     |
| ------ | --------------- | ------------------------------- |
| POST   | `/api/generate` | Single-prompt completion        |
| POST   | `/api/chat`     | Chat completion with history    |
| POST   | `/api/embed`    | Generate embeddings             |
| POST   | `/api/create`   | Create a model from a Modelfile |
| POST   | `/api/pull`     | Pull a model from the registry  |
| POST   | `/api/push`     | Push a model to the registry    |
| POST   | `/api/show`     | Show model details              |
| POST   | `/api/copy`     | Copy a model                    |
| DELETE | `/api/delete`   | Delete a model                  |
| GET    | `/api/tags`     | List installed models           |
| GET    | `/api/ps`       | List running models             |
| GET    | `/api/version`  | Server version                  |

```sh
curl http://localhost:11434/api/generate -d '{
  "model": "gemma4",
  "prompt": "Why is the sky blue?",
  "stream": false
}'
```

```sh
curl http://localhost:11434/api/chat -d '{
  "model": "qwen3.5",
  "messages": [
    { "role": "user", "content": "Give me a one-line git alias for amend." }
  ],
  "stream": false
}'
```

Responses stream by default; set `"stream": false` for a single JSON object.

### OpenAI and Anthropic compatible APIs

Ollama exposes both compatibility layers, so most existing SDKs work unchanged.

**OpenAI** (`/v1/chat/completions`, `/v1/responses`):

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:11434/v1/",
    api_key="ollama",  # required but ignored
)

completion = client.chat.completions.create(
    model="gpt-oss:20b",
    messages=[{"role": "user", "content": "Say this is a test"}],
)
print(completion.choices[0].message.content)
```

**Anthropic** (`/v1/messages`):

```sh
export ANTHROPIC_AUTH_TOKEN=ollama  # required but ignored
export ANTHROPIC_BASE_URL=http://localhost:11434
```

### Coding agent integrations

`ollama launch` configures and starts a supported tool against a local model.

```sh
# Interactive picker
ollama launch

# Launch a specific integration and model
ollama launch claude --model qwen3-coder

# Configure without launching
ollama launch droid --config
```

Supported integrations include Claude Code, OpenCode, Codex, VS Code,
Cline, Zed, JetBrains, Goose, Droid, and n8n.

👉 [Integration list](https://docs.ollama.com/integrations)

### Web search

A hosted search API lets models ground answers in current pages.
It needs a free Ollama account and an [API key](https://ollama.com/settings/keys).

```sh
curl https://ollama.com/api/web_search \
  --header "Authorization: Bearer $OLLAMA_API_KEY" \
  -d '{ "query": "what is ollama?", "max_results": 5 }'
```

## Choosing a Model

### By VRAM budget

Sizes assume 4-bit quantization (`Q4_K_M`), which is the default for most tags.

| VRAM / Unified memory | Practical ceiling   | Good picks                                                                      |
| --------------------- | ------------------- | ------------------------------------------------------------------------------- |
| 8 GB                  | 4B dense            | `qwen3.5:4b`, `gemma4:e4b`, `phi4-mini`, `lfm2.5:8b` (A1B MoE, 5.2 GB)          |
| 16 GB                 | 9–14B dense         | `qwen3.5:9b`, `gemma4:12b`, `phi4:14b`                                          |
| 24–32 GB              | 27–35B, small MoE   | `qwen3-coder:30b`, `qwen3.6:27b`, `gemma4:31b`, `gpt-oss:20b`, `ornith-1.5:35b` |
| 48–64 GB              | 70B dense, 120B MoE | `gpt-oss:120b`, `nemotron-3-super:120b`                                         |
| Beyond that           | —                   | Use `:cloud` tags instead of buying hardware                                    |

> [!NOTE]
> MoE (Mixture-of-Experts) models list a large total parameter count but
> activate only a fraction per token, so they run far faster than a dense
> model of the same footprint. `qwen3-coder:30b` is 30B total / 3.3B active.

### By use case

| Use case              | Recommended model                              | Why                                                    |
| --------------------- | ---------------------------------------------- | ------------------------------------------------------ |
| Agentic coding        | `qwen3-coder:30b`, `ornith-1.5:35b`            | Best quality per GB, 256K context, reliable tool calls |
| Coding, frontier tier | `ornith-1.5:397b`, `glm-5.2:cloud`             | Top open-weight scores on SWE-Bench / Terminal-Bench   |
| General assistant     | `qwen3.6:27b`, `gemma4:12b`                    | Strong all-round reasoning on one GPU                  |
| Reasoning             | `gpt-oss:20b`, `deepseek-r1`                   | Adjustable reasoning effort, chain-of-thought          |
| Vision / multimodal   | `gemma4`, `qwen3.5`, `minicpm-v`               | Image and document understanding                       |
| OCR / documents       | `glm-ocr`                                      | Purpose-built for complex layouts                      |
| Laptop / edge         | `lfm2.5:8b`, `gemma4:e2b`, `qwen3.5:0.8b`      | Fast on CPU or small unified memory                    |
| Embeddings / RAG      | `embeddinggemma`, `nomic-embed-text`, `bge-m3` | Cheap, high-quality vectors                            |

## Local LLM Model Families (2026)

| Model Family                   | Publisher / Developer        | Country | Ollama Tags                                           | Typical Sizes           | Runs Locally | License                   | Primary Strengths                                         | Recommendation |
| ------------------------------ | ---------------------------- | ------- | ----------------------------------------------------- | ----------------------- | ------------ | ------------------------- | --------------------------------------------------------- | -------------- |
| Qwen                           | Alibaba Cloud                | China   | `qwen3.5`, `qwen3.6`, `qwen3-coder`                   | 0.8B–480B (Dense & MoE) | Yes          | Apache 2.0 (most models)  | Coding, reasoning, most reliable tool calling             | ★★★★★          |
| Gemma                          | Google DeepMind              | UK / US | `gemma4`, `embeddinggemma`                            | 270M–31B                | Yes          | Gemma License             | Efficient reasoning, vision, audio, instruction following | ★★★★★          |
| gpt-oss                        | OpenAI                       | US      | `gpt-oss`                                             | 20B, 120B (MoE)         | Yes          | Apache 2.0                | Adjustable reasoning effort, long-running research        | ★★★★★          |
| DeepSeek                       | DeepSeek                     | China   | `deepseek-v4-flash`, `deepseek-v4-pro`, `deepseek-r1` | 1.5B–671B (MoE)         | Partial      | MIT                       | Programming, chain-of-thought reasoning                   | ★★★★★          |
| Ornith                         | DeepReinforce AI             | US      | `ornith`, `ornith-1.5`                                | 9B–397B (Dense & MoE)   | Yes          | MIT                       | Self-improving agentic coding, tool use, debugging        | ★★★★★          |
| GLM                            | Zhipu AI (Z.ai)              | China   | `glm-5.1`, `glm-5.2`, `glm-ocr`                       | 9B–744B (MoE)           | Partial      | MIT / varies by model     | Long-horizon reasoning, agentic coding, OCR               | ★★★★★          |
| Kimi                           | Moonshot AI                  | China   | `kimi-k3`, `kimi-k2.7-code`                           | Cloud & open variants   | Partial      | Modified MIT              | Long-context reasoning, agent workflows                   | ★★★★☆          |
| LFM (Liquid Foundation Models) | Liquid AI                    | US      | `lfm2.5:8b`, `lfm2:24b`                               | 350M–24B (A1B/A2B MoE)  | Yes          | LFM Open License          | Hybrid architecture, edge deployment, tool calling        | ★★★★☆          |
| Nemotron                       | NVIDIA                       | US      | `nemotron-3-nano`, `-super`, `-ultra`                 | 4B–120B+                | Partial      | NVIDIA Open Model License | Enterprise reasoning, multi-agent execution               | ★★★★☆          |
| Llama                          | Meta                         | US      | `llama3.1`, `llama3.2`, `llama4`                      | 1B–405B                 | Yes          | Llama Community License   | Largest fine-tune ecosystem                               | ★★★★☆          |
| Mistral                        | Mistral AI                   | France  | `mistral`, `mistral-nemo`, `mistral-large-3`          | 7B–123B                 | Partial      | Apache 2.0 (many models)  | Efficient inference, European data governance             | ★★★★☆          |
| Phi                            | Microsoft                    | US      | `phi4`, `phi4-mini`                                   | 3.8B–14B                | Yes          | MIT                       | Small but capable models                                  | ★★★★☆          |
| MiniMax                        | MiniMax                      | China   | `minimax-m2.7`, `minimax-m3`                          | Cloud only              | No           | Varies by model           | Agentic workflows, vision                                 | ★★★☆☆          |
| MiniCPM                        | OpenBMB                      | China   | `minicpm-v`                                           | 2B–8B                   | Yes          | Apache 2.0                | On-device vision-language efficiency                      | ★★★☆☆          |
| InternLM                       | Shanghai AI Laboratory       | China   | `internlm2`                                           | 7B–20B                  | Yes          | Apache 2.0                | Coding, multilingual                                      | ★★★☆☆          |
| Yi                             | 01.AI                        | China   | `yi`                                                  | 6B–34B                  | Yes          | Apache 2.0                | General reasoning                                         | ★★★☆☆          |
| OLMo                           | Allen Institute for AI (AI2) | US      | `olmo2`                                               | 1B–32B                  | Yes          | Apache 2.0                | Fully open training pipeline                              | ★★★☆☆          |
| SmolLM                         | Hugging Face                 | France  | `smollm2`                                             | 135M–1.7B               | Yes          | Apache 2.0                | Tiny footprint                                            | ★★★☆☆          |

> [!NOTE]
> "Runs Locally: Partial" means the family ships some open-weight tags you can
> pull, but the flagship sizes are only reachable through `:cloud` tags.

## Recommended Models for AI Agent Development

### Tier 1 — Excellent

- Qwen
- Gemma
- gpt-oss
- DeepSeek
- Ornith
- GLM

### Tier 2 — Very Good

- Kimi
- LFM
- Nemotron
- Llama
- Mistral
- Phi

### Tier 3 — Specialized

- MiniMax
- MiniCPM
- InternLM
- Yi
- OLMo
- SmolLM

## Notes

### Qwen

- Outstanding coding capability; `qwen3-coder` targets agentic workflows directly.
- The most stable local family for tool calling — lowest rate of dropped tool calls.
- Excellent multilingual support and 256K context on the coder tags.
- Wide size range, so the same family scales from a laptop to a workstation.

### Gemma

- Excellent instruction following and a very good quality-per-GB ratio.
- `gemma4` adds vision, audio, and thinking modes.
- E2B / E4B tags are effective-parameter variants tuned for small devices.
- Excellent MLX and Ollama support.

### gpt-oss

- OpenAI's open-weight family under Apache 2.0.
- Reasoning effort is adjustable, which makes latency easy to trade against quality.
- `20b` fits a 24 GB GPU; `120b` needs ~48 GB or the `:cloud` tag.

### DeepSeek

- Designed for software engineering; strong code generation and debugging.
- `deepseek-r1` remains a good local chain-of-thought reasoner.
- The v4 flagship tiers are cloud-served.

### Ornith

- Released June 2026 by DeepReinforce AI under MIT, built on top of
  pretrained Gemma 4 and Qwen 3.5.
- Self-scaffolding: the model learns its own agent harness — planning,
  tool use, and error recovery — rather than relying on a hand-written one.
- Ornith-1.0-397B posts 82.4 on SWE-Bench Verified and 77.5 on Terminal-Bench 2.1.
- `ornith-1.5` extends the self-improvement loop to task generation and
  strategy discovery, and adds vision. Tags: `9b`, `35b`, `397b`, all 256K context.
- `ornith-1.5:35b` (23 GB) is the sweet spot for a 32 GB machine.

### GLM

- Strong long-horizon reasoning and agentic coding.
- `glm-ocr` is a purpose-built multimodal OCR model for complex documents.
- Flagship sizes are cloud-only.

### Kimi

- Focuses on long-context reasoning and autonomous agents.
- Strong planning capability.
- Mostly reached through `:cloud` tags; older cloud tags are periodically retired.

### LFM (Liquid Foundation Models)

- Hybrid (non-pure-transformer) architecture optimized for on-device speed.
- Focuses on efficient inference rather than larger parameter counts.
- `lfm2.5:8b` is an 8B-A1B MoE at 5.2 GB with 125K context, built for
  reliable tool calling on consumer hardware.
- `lfm2:24b-a2b` activates only ~2.3B parameters per token and fits 32 GB unified memory.
- Sub-1B variants (350M, 700M, 1.2B) live on Hugging Face and community registries
  rather than the official Ollama library.
- Excellent choice for edge devices and Apple Silicon.

### Nemotron

- Optimized for enterprise AI and multi-agent execution.
- Nano / Super / Ultra tiers cover 4B through cloud-scale.

### Llama

- Largest open ecosystem with a huge number of community fine-tunes.
- Best choice when you plan to fine-tune rather than use off the shelf.

### Mistral

- Excellent performance per parameter and very fast local inference.
- `mistral-nemo:12b` offers 128K context in a size most GPUs can hold.

### Phi

- Small but surprisingly capable; strong on reasoning benchmarks for its size.
- `phi4-mini` is a solid 8 GB-class default.

### MiniMax

- Cloud-only in Ollama; agentic and multimodal focus.

### MiniCPM

- Designed for mobile and on-device AI; very memory efficient.
- `minicpm-v` is a compact vision-language option.

### InternLM

- Strong coding models backed by active academic research.

### Yi

- General-purpose reasoning with a good balance between quality and speed.

### OLMo

- Fully open training pipeline — data, code, and checkpoints.
- Excellent for research and reproducibility work.

### SmolLM

- Extremely lightweight; suitable for edge and embedded devices.
