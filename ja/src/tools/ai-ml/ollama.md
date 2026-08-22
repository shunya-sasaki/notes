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

Ollama は、大規模言語モデルを自分のマシン上でダウンロード・管理・
提供するためのオープンソースのランタイムです。
推論エンジン、モデルレジストリのクライアント、HTTP サーバーを
単一の CLI の背後にまとめているため、ビルドパイプラインを組まなくても
コマンド 1 つでモデルを実行できます。

主な特徴:

- **One-command models** - `ollama run <model>` でモデルの取得・ロード・
  チャット開始までを行います。
- **Local HTTP API** - `http://localhost:11434` で待ち受け、
  任意のアプリケーションから利用できます。
- **OpenAI / Anthropic compatibility** - `/v1/chat/completions` と
  `/v1/messages` エンドポイントがそのまま使え、既存の SDK や
  コーディングエージェントと連携できます。
- **GPU acceleration** - Apple Silicon (Metal)、NVIDIA (CUDA)、AMD (ROCm)。
- **Capabilities** - ツール呼び出し、thinking / reasoning モード、ビジョン、
  オーディオ、構造化出力、埋め込み。
- **Cloud models** - `:cloud` タグの付いたモデルは Ollama のデータセンターの
  ハードウェア上で動作し、ローカルモデルとまったく同じコマンドと API で
  利用できます。
- **Modelfile** - システムプロンプト、パラメータ、テンプレートを
  カスタマイズし、その結果をレジストリ経由で共有できます。

## Install

### macOS

macOS Sonoma (v14) 以降が必要です。
Apple M シリーズでは CPU と GPU がサポートされ、x86 では CPU のみです。

👉 [Download the macOS app](https://ollama.com/download/mac)

または Homebrew でインストールします。

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

AMD GPU を使う場合は、追加の ROCm パッケージも展開します。

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

NVIDIA GPU を使う場合は `--gpus=all` を追加します。

## Setup

### Start the server

デスクトップアプリはサーバーを自動的に起動します。
手動で実行する場合は次のようにします。

```sh
ollama serve
```

動作していることを確認します。

```sh
ollama -v
curl http://localhost:11434/api/version
```

### Environment variables

これらは `ollama serve` の前に設定します。
全一覧は `ollama serve --help` を実行してください。

| Variable                   | Purpose                                          | Default             |
| -------------------------- | ------------------------------------------------ | ------------------- |
| `OLLAMA_HOST`              | サーバーがバインドするアドレス                   | `127.0.0.1:11434`   |
| `OLLAMA_MODELS`            | モデルの blob を保存するディレクトリ             | `~/.ollama/models`  |
| `OLLAMA_CONTEXT_LENGTH`    | デフォルトのコンテキスト長                       | VRAM に応じて 4k/32k/256k |
| `OLLAMA_KEEP_ALIVE`        | モデルをメモリ上に保持する時間                   | `5m`                |
| `OLLAMA_NUM_PARALLEL`      | 並列リクエストの最大数                           | auto                |
| `OLLAMA_MAX_LOADED_MODELS` | GPU あたりのロード済みモデルの最大数             | auto                |
| `OLLAMA_FLASH_ATTENTION`   | flash attention を有効にします                   | off                 |
| `OLLAMA_KV_CACHE_TYPE`     | K/V キャッシュの量子化タイプ                     | `f16`               |
| `OLLAMA_NO_CLOUD`          | クラウド推論と Web 検索を無効にします            | off                 |
| `OLLAMA_DEBUG`             | 追加のデバッグ情報を表示します                   | off                 |

> [!TIP]
> Ollama を LAN に公開するには `OLLAMA_HOST=0.0.0.0:11434` を設定します。
> Ollama には認証機構がないため、信頼できるネットワークでのみ行ってください。

### Context length

Ollama は利用可能な VRAM からデフォルトのコンテキスト長を決定します。

| VRAM      | Default context |
| --------- | --------------- |
| < 24 GiB  | 4k              |
| 24–48 GiB | 32k             |
| >= 48 GiB | 256k            |

エージェント、コーディングツール、Web 検索では、デフォルトの 4k では
まったく足りません。これらのワークロードでは少なくとも 64k を設定します。

```sh
OLLAMA_CONTEXT_LENGTH=64000 ollama serve
```

コンテキスト長を大きくするとメモリ消費も増えるため、VRAM に余裕があるか
確認してください。クラウドモデルは常に最大のコンテキスト長に設定されます。

### Sign in for cloud models

クラウドモデルは `:cloud` サフィックスを持ち、Ollama のサーバー上で
動作しますが、ローカルの CLI と API のインタフェースは同一です。

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

`ollama run` の中では、`/` で始まる行はコマンドとして扱われます。

| Command            | Description                          |
| ------------------ | ------------------------------------ |
| `/bye`             | セッションを終了します               |
| `/?`               | ヘルプを表示します                   |
| `/set parameter …` | 実行時パラメータを変更します         |
| `/set system …`    | システムプロンプトを設定します       |
| `/show info`       | 現在のモデルの詳細を表示します       |
| `/clear`           | 会話のコンテキストをクリアします     |
| `/save <name>`     | セッションを新しいモデルとして保存します |

複数行の入力は `"""` で囲みます。

```text
>>> """Hello,
... world!
... """
```

### Modelfile

`Modelfile` は、既存のモデルの上にシステムプロンプト、パラメータ、
テンプレートを重ねて定義します。

```dockerfile
FROM qwen3.5:9b

PARAMETER temperature 0.3
PARAMETER num_ctx 65536

SYSTEM """
You are a terse Rust reviewer.
Answer with a diff whenever possible.
"""
```

ビルドして実行します。

```sh
ollama create rust-reviewer -f Modelfile
ollama run rust-reviewer
```

👉 [Modelfile reference](https://docs.ollama.com/modelfile)

### REST API

サーバーは `http://localhost:11434` で待ち受けます。

| Method | Endpoint        | Description                          |
| ------ | --------------- | ------------------------------------ |
| POST   | `/api/generate` | 単一プロンプトの補完                 |
| POST   | `/api/chat`     | 履歴付きのチャット補完               |
| POST   | `/api/embed`    | 埋め込みの生成                       |
| POST   | `/api/create`   | Modelfile からモデルを作成           |
| POST   | `/api/pull`     | レジストリからモデルを取得           |
| POST   | `/api/push`     | レジストリにモデルを送信             |
| POST   | `/api/show`     | モデルの詳細を表示                   |
| POST   | `/api/copy`     | モデルをコピー                       |
| DELETE | `/api/delete`   | モデルを削除                         |
| GET    | `/api/tags`     | インストール済みモデルの一覧         |
| GET    | `/api/ps`       | 実行中モデルの一覧                   |
| GET    | `/api/version`  | サーバーのバージョン                 |

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

レスポンスはデフォルトでストリーミングされます。単一の JSON オブジェクトを
得るには `"stream": false` を設定します。

### OpenAI and Anthropic compatible APIs

Ollama は両方の互換レイヤーを提供しているため、ほとんどの既存 SDK が
変更なしで動作します。

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

`ollama launch` は、サポートされているツールをローカルモデルに対して
設定し、起動します。

```sh
# Interactive picker
ollama launch

# Launch a specific integration and model
ollama launch claude --model qwen3-coder

# Configure without launching
ollama launch droid --config
```

サポートされている連携先には、Claude Code、OpenCode、Codex、VS Code、
Cline、Zed、JetBrains、Goose、Droid、n8n などがあります。

👉 [Integration list](https://docs.ollama.com/integrations)

### Web search

ホスティングされた検索 API により、モデルは最新のページに基づいた回答を
生成できます。無料の Ollama アカウントと
[API key](https://ollama.com/settings/keys) が必要です。

```sh
curl https://ollama.com/api/web_search \
  --header "Authorization: Bearer $OLLAMA_API_KEY" \
  -d '{ "query": "what is ollama?", "max_results": 5 }'
```

## Choosing a Model

### By VRAM budget

サイズは、ほとんどのタグでデフォルトとなっている 4 bit 量子化 (`Q4_K_M`)
を前提としています。

| VRAM / Unified memory | Practical ceiling         | Good picks                                                                      |
| --------------------- | ------------------------- | ------------------------------------------------------------------------------- |
| 8 GB                  | 4B dense                  | `qwen3.5:4b`, `gemma4:e4b`, `phi4-mini`, `lfm2.5:8b` (A1B MoE, 5.2 GB)          |
| 16 GB                 | 9–14B dense               | `qwen3.5:9b`, `gemma4:12b`, `phi4:14b`                                          |
| 24–32 GB              | 27–35B、小規模 MoE        | `qwen3-coder:30b`, `qwen3.6:27b`, `gemma4:31b`, `gpt-oss:20b`, `ornith-1.5:35b` |
| 48–64 GB              | 70B dense、120B MoE       | `gpt-oss:120b`, `nemotron-3-super:120b`                                         |
| それ以上              | —                         | ハードウェアを買うより `:cloud` タグを使います                                  |

> [!NOTE]
> MoE (Mixture-of-Experts) モデルは総パラメータ数が大きく表示されますが、
> トークンごとに一部しか活性化しないため、同じ規模の dense モデルより
> はるかに高速に動作します。`qwen3-coder:30b` は総計 30B / 活性 3.3B です。

### By use case

| Use case              | Recommended model                              | Why                                                        |
| --------------------- | ---------------------------------------------- | ---------------------------------------------------------- |
| エージェント的コーディング | `qwen3-coder:30b`, `ornith-1.5:35b`         | GB あたりの品質が最良、256K コンテキスト、安定したツール呼び出し |
| コーディング (最上位層)   | `ornith-1.5:397b`, `glm-5.2:cloud`          | SWE-Bench / Terminal-Bench でオープンウェイト最高水準のスコア |
| 汎用アシスタント          | `qwen3.6:27b`, `gemma4:12b`                 | GPU 1 枚で強力な総合的推論能力                             |
| 推論                      | `gpt-oss:20b`, `deepseek-r1`                | 推論の強度を調整可能、chain-of-thought                     |
| ビジョン / マルチモーダル | `gemma4`, `qwen3.5`, `minicpm-v`            | 画像と文書の理解                                           |
| OCR / 文書処理            | `glm-ocr`                                   | 複雑なレイアウト向けの専用設計                             |
| ノート PC / エッジ        | `lfm2.5:8b`, `gemma4:e2b`, `qwen3.5:0.8b`   | CPU や小容量のユニファイドメモリでも高速                   |
| 埋め込み / RAG            | `embeddinggemma`, `nomic-embed-text`, `bge-m3` | 低コストで高品質なベクトル                              |

## Local LLM Model Families (2026)

| Model Family                   | Publisher / Developer        | Country | Ollama Tags                                           | Typical Sizes           | Runs Locally | License                   | Primary Strengths                                         | Recommendation |
| ------------------------------ | ---------------------------- | ------- | ----------------------------------------------------- | ----------------------- | ------------ | ------------------------- | --------------------------------------------------------- | -------------- |
| Qwen                           | Alibaba Cloud                | 中国    | `qwen3.5`, `qwen3.6`, `qwen3-coder`                   | 0.8B–480B (Dense & MoE) | Yes          | Apache 2.0 (ほとんどのモデル) | コーディング、推論、最も安定したツール呼び出し        | ★★★★★          |
| Gemma                          | Google DeepMind              | 英国 / 米国 | `gemma4`, `embeddinggemma`                        | 270M–31B                | Yes          | Gemma License             | 効率的な推論、ビジョン、オーディオ、指示追従             | ★★★★★          |
| gpt-oss                        | OpenAI                       | 米国    | `gpt-oss`                                             | 20B, 120B (MoE)         | Yes          | Apache 2.0                | 推論強度の調整、長時間のリサーチ                          | ★★★★★          |
| DeepSeek                       | DeepSeek                     | 中国    | `deepseek-v4-flash`, `deepseek-v4-pro`, `deepseek-r1` | 1.5B–671B (MoE)         | Partial      | MIT                       | プログラミング、chain-of-thought 推論                     | ★★★★★          |
| Ornith                         | DeepReinforce AI             | 米国    | `ornith`, `ornith-1.5`                                | 9B–397B (Dense & MoE)   | Yes          | MIT                       | 自己改善型のエージェント的コーディング、ツール利用、デバッグ | ★★★★★        |
| GLM                            | Zhipu AI (Z.ai)              | 中国    | `glm-5.1`, `glm-5.2`, `glm-ocr`                       | 9B–744B (MoE)           | Partial      | MIT / モデルにより異なる  | 長期的な推論、エージェント的コーディング、OCR             | ★★★★★          |
| Kimi                           | Moonshot AI                  | 中国    | `kimi-k3`, `kimi-k2.7-code`                           | クラウド版とオープン版  | Partial      | Modified MIT              | 長大コンテキストの推論、エージェントのワークフロー        | ★★★★☆          |
| LFM (Liquid Foundation Models) | Liquid AI                    | 米国    | `lfm2.5:8b`, `lfm2:24b`                               | 350M–24B (A1B/A2B MoE)  | Yes          | LFM Open License          | ハイブリッドアーキテクチャ、エッジ展開、ツール呼び出し    | ★★★★☆          |
| Nemotron                       | NVIDIA                       | 米国    | `nemotron-3-nano`, `-super`, `-ultra`                 | 4B–120B+                | Partial      | NVIDIA Open Model License | エンタープライズ向け推論、マルチエージェント実行          | ★★★★☆          |
| Llama                          | Meta                         | 米国    | `llama3.1`, `llama3.2`, `llama4`                      | 1B–405B                 | Yes          | Llama Community License   | 最大のファインチューンエコシステム                        | ★★★★☆          |
| Mistral                        | Mistral AI                   | フランス | `mistral`, `mistral-nemo`, `mistral-large-3`         | 7B–123B                 | Partial      | Apache 2.0 (多くのモデル) | 効率的な推論、欧州のデータガバナンス                      | ★★★★☆          |
| Phi                            | Microsoft                    | 米国    | `phi4`, `phi4-mini`                                   | 3.8B–14B                | Yes          | MIT                       | 小規模ながら高性能なモデル                                | ★★★★☆          |
| MiniMax                        | MiniMax                      | 中国    | `minimax-m2.7`, `minimax-m3`                          | クラウドのみ            | No           | モデルにより異なる        | エージェント的ワークフロー、ビジョン                      | ★★★☆☆          |
| MiniCPM                        | OpenBMB                      | 中国    | `minicpm-v`                                           | 2B–8B                   | Yes          | Apache 2.0                | オンデバイスの視覚言語処理の効率性                        | ★★★☆☆          |
| InternLM                       | Shanghai AI Laboratory       | 中国    | `internlm2`                                           | 7B–20B                  | Yes          | Apache 2.0                | コーディング、多言語                                      | ★★★☆☆          |
| Yi                             | 01.AI                        | 中国    | `yi`                                                  | 6B–34B                  | Yes          | Apache 2.0                | 汎用的な推論                                              | ★★★☆☆          |
| OLMo                           | Allen Institute for AI (AI2) | 米国    | `olmo2`                                               | 1B–32B                  | Yes          | Apache 2.0                | 完全にオープンな学習パイプライン                          | ★★★☆☆          |
| SmolLM                         | Hugging Face                 | フランス | `smollm2`                                            | 135M–1.7B               | Yes          | Apache 2.0                | 極小のフットプリント                                      | ★★★☆☆          |

> [!NOTE]
> 「Runs Locally: Partial」は、そのファミリーが取得可能なオープンウェイトの
> タグをいくつか提供しているものの、フラッグシップのサイズは `:cloud` タグ
> 経由でしか利用できないことを意味します。

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

- コーディング能力が非常に高く、`qwen3-coder` はエージェント的ワークフローを
  直接ターゲットにしています。
- ツール呼び出しにおいて最も安定したローカルファミリーで、ツール呼び出しの
  取りこぼし率が最も低いです。
- 多言語サポートが優秀で、coder タグでは 256K コンテキストに対応します。
- サイズの幅が広く、同じファミリーがノート PC からワークステーションまで
  スケールします。

### Gemma

- 指示追従が優秀で、GB あたりの品質比も非常に良好です。
- `gemma4` はビジョン、オーディオ、thinking モードを追加しています。
- E2B / E4B タグは、小型デバイス向けにチューニングされた
  実効パラメータのバリアントです。
- MLX と Ollama のサポートが優秀です。

### gpt-oss

- Apache 2.0 で公開された OpenAI のオープンウェイトファミリーです。
- 推論の強度を調整でき、レイテンシと品質のトレードオフを取りやすいです。
- `20b` は 24 GB の GPU に収まり、`120b` には約 48 GB か
  `:cloud` タグが必要です。

### DeepSeek

- ソフトウェアエンジニアリング向けに設計されており、コード生成と
  デバッグに強みがあります。
- `deepseek-r1` は依然として優れたローカルの chain-of-thought 推論モデルです。
- v4 のフラッグシップ層はクラウド提供です。

### Ornith

- 2026 年 6 月に DeepReinforce AI が MIT ライセンスで公開し、
  事前学習済みの Gemma 4 と Qwen 3.5 を基盤としています。
- 自己スキャフォールディング: 手書きのハーネスに頼るのではなく、
  モデル自身がエージェントのハーネス (プランニング、ツール利用、
  エラー回復) を学習します。
- Ornith-1.0-397B は SWE-Bench Verified で 82.4、
  Terminal-Bench 2.1 で 77.5 を記録しています。
- `ornith-1.5` は自己改善ループをタスク生成と戦略探索まで拡張し、
  ビジョンも追加しています。タグは `9b`、`35b`、`397b` で、
  いずれも 256K コンテキストです。
- `ornith-1.5:35b` (23 GB) は 32 GB のマシンにとって最適な選択です。

### GLM

- 長期的な推論とエージェント的コーディングに強みがあります。
- `glm-ocr` は複雑な文書向けに専用設計されたマルチモーダル OCR モデルです。
- フラッグシップのサイズはクラウド専用です。

### Kimi

- 長大コンテキストの推論と自律エージェントに注力しています。
- プランニング能力が高いです。
- 主に `:cloud` タグ経由で利用します。古いクラウドタグは定期的に廃止されます。

### LFM (Liquid Foundation Models)

- オンデバイスでの速度に最適化されたハイブリッド
  (純粋な Transformer ではない) アーキテクチャです。
- パラメータ数を増やすことより、効率的な推論に注力しています。
- `lfm2.5:8b` は 5.2 GB・125K コンテキストの 8B-A1B MoE で、
  コンシューマ向けハードウェアでの安定したツール呼び出しを目的としています。
- `lfm2:24b-a2b` はトークンあたり約 2.3B のパラメータのみを活性化し、
  32 GB のユニファイドメモリに収まります。
- 1B 未満のバリアント (350M、700M、1.2B) は公式の Ollama ライブラリではなく、
  Hugging Face やコミュニティのレジストリで公開されています。
- エッジデバイスや Apple Silicon には最適な選択肢です。

### Nemotron

- エンタープライズ AI とマルチエージェント実行に最適化されています。
- Nano / Super / Ultra の各層が 4B からクラウド規模までをカバーします。

### Llama

- コミュニティによる膨大なファインチューンを擁する最大のオープンエコシステムです。
- 既製のまま使うのではなくファインチューンを予定している場合に最適です。

### Mistral

- パラメータあたりの性能が優秀で、ローカル推論が非常に高速です。
- `mistral-nemo:12b` は、ほとんどの GPU に収まるサイズで
  128K コンテキストを提供します。

### Phi

- 小型ながら驚くほど高性能で、サイズの割に推論ベンチマークが優秀です。
- `phi4-mini` は 8 GB クラスの堅実なデフォルトです。

### MiniMax

- Ollama ではクラウド専用で、エージェントとマルチモーダルに注力しています。

### MiniCPM

- モバイルとオンデバイス AI 向けに設計されており、メモリ効率が非常に優れています。
- `minicpm-v` はコンパクトな視覚言語モデルの選択肢です。

### InternLM

- 活発な学術研究に支えられた、コーディングに強いモデルです。

### Yi

- 品質と速度のバランスが良い汎用的な推論モデルです。

### OLMo

- データ、コード、チェックポイントまで含めて完全にオープンな学習パイプラインです。
- 研究や再現性の検証に最適です。

### SmolLM

- 極めて軽量で、エッジデバイスや組み込み機器に適しています。
