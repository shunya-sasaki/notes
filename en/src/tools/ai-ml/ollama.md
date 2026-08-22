# Ollama

## What is Ollama?

# Local LLM Model Families (2026)

| Model Family                   | Publisher / Developer        | Country | First Released | Typical Sizes         | Open Weights | License                   | Primary Strengths                                  | Best Use Cases                     | Recommendation |
| ------------------------------ | ---------------------------- | ------- | -------------- | --------------------- | ------------ | ------------------------- | -------------------------------------------------- | ---------------------------------- | -------------- |
| Gemma                          | Google DeepMind              | UK / US | 2024           | 2B–27B                | Yes          | Gemma License             | Efficient reasoning, instruction following         | Agents, coding, assistants         | ★★★★★          |
| Qwen                           | Alibaba Cloud                | China   | 2023           | 0.5B–100B+            | Yes          | Apache 2.0 (most models)  | Coding, reasoning, multilingual                    | AI agents, software engineering    | ★★★★★          |
| DeepSeek                       | DeepSeek                     | China   | 2024           | 1.5B–600B+ (MoE)      | Yes          | MIT                       | Programming, reasoning                             | Coding agents, research            | ★★★★★          |
| Ornith                         | DeepReinforce AI             | US      | 2026           | 9B–397B (Dense & MoE) | Yes          | MIT                       | Agentic coding, tool use, planning, debugging      | Autonomous coding agents           | ★★★★★          |
| Kimi                           | Moonshot AI                  | China   | 2024           | Cloud & open variants | Partial      | Varies by model           | Long-context reasoning, agent workflows            | Autonomous agents                  | ★★★★★          |
| LFM (Liquid Foundation Models) | Liquid AI                    | US      | 2024           | 1.2B–24B+             | Yes          | Apache 2.0                | Efficient inference, edge deployment, tool calling | On-device assistants, embedded AI  | ★★★★★          |
| Nemotron                       | NVIDIA                       | US      | 2024           | 4B–120B+              | Yes          | NVIDIA Open Model License | Enterprise reasoning, multi-agent execution        | Enterprise AI, large agent systems | ★★★★☆          |
| Llama                          | Meta                         | US      | 2023           | 1B–400B+              | Yes          | Llama Community License   | General-purpose ecosystem                          | Fine-tuning, research              | ★★★★☆          |
| Mistral                        | Mistral AI                   | France  | 2023           | 3B–123B               | Yes          | Apache 2.0 (many models)  | Efficient inference                                | Local assistants, coding           | ★★★★☆          |
| GLM                            | Zhipu AI                     | China   | 2023           | 2B–62B+               | Partial      | Varies by model           | Long-horizon reasoning, multilingual               | General assistants                 | ★★★★☆          |
| Phi                            | Microsoft                    | US      | 2023           | 3B–14B                | Yes          | MIT                       | Small but capable models                           | Lightweight assistants             | ★★★★☆          |
| MiniCPM                        | OpenBMB                      | China   | 2024           | 2B–8B                 | Yes          | Apache 2.0                | Excellent on-device efficiency                     | Mobile and edge AI                 | ★★★★☆          |
| InternLM                       | Shanghai AI Laboratory       | China   | 2023           | 7B–20B                | Yes          | Apache 2.0                | Coding, multilingual                               | Research, development              | ★★★☆☆          |
| Yi                             | 01.AI                        | China   | 2023           | 6B–34B                | Yes          | Apache 2.0                | General reasoning                                  | General assistants                 | ★★★☆☆          |
| OLMo                           | Allen Institute for AI (AI2) | US      | 2024           | 1B–32B                | Yes          | Apache 2.0                | Fully open research models                         | Academic research                  | ★★★☆☆          |
| SmolLM                         | Hugging Face                 | France  | 2024           | 135M–1.7B             | Yes          | Apache 2.0                | Tiny footprint                                     | Edge devices                       | ★★★☆☆          |

## Recommended Models for AI Agent Development

### Tier 1 — Excellent

- Gemma
- Qwen
- DeepSeek
- Kimi
- LFM

### Tier 2 — Very Good

- Nemotron
- Llama
- Mistral
- GLM
- Phi

### Tier 3 — Specialized

- MiniCPM
- InternLM
- Yi
- OLMo
- SmolLM

## Notes

### Gemma

- Excellent instruction following.
- Optimized for coding and AI agents.
- Excellent MLX and Ollama support.

### Qwen

- Outstanding coding capability.
- Strong reasoning.
- Excellent multilingual support.
- One of the strongest open-weight models.

### DeepSeek

- Designed for software engineering.
- Excellent code generation and debugging.
- Strong reasoning models.

### Kimi

- Focuses on long-context reasoning.
- Designed for autonomous agents.
- Strong planning capability.

### LFM (Liquid Foundation Models)

- Developed by Liquid AI.
- Focuses on efficient inference rather than larger parameter counts.
- Excellent choice for edge devices and Apple Silicon.

### Nemotron

- Developed by NVIDIA.
- Optimized for enterprise AI.
- Strong reasoning and multi-agent execution.

### Llama

- Largest open ecosystem.
- Huge number of community fine-tunes.

### Mistral

- Excellent performance per parameter.
- Very fast local inference.

### GLM

- Strong multilingual capability.
- Good long-context variants.

### Phi

- Small but surprisingly capable.
- Excellent efficiency.

### MiniCPM

- Designed for mobile and on-device AI.
- Very memory efficient.

### InternLM

- Strong coding models.
- Active academic research.

### Yi

- General-purpose reasoning model.
- Good balance between quality and speed.

### OLMo

- Fully open training pipeline.
- Excellent for research.

### SmolLM

- Extremely lightweight.
- Suitable for edge and embedded devices.
