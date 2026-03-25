---
layout: default
title: Setup Guide
---

# AI Coding Tool Setup Guide

This guide covers installation and configuration of four mainstream AI coding tools, tailored for university students in China.

> **Network note**: Some tools require access to overseas services. Make sure you have a working proxy (e.g. Clash, V2Ray). Common default ports: Clash `7890`, V2Ray `10808`.

> **Windows users**: Except for Cursor, terminal tools are recommended to run inside WSL 2 (same experience as macOS / Linux). To install WSL: open PowerShell (Admin), run `wsl --install`, restart, and follow the prompts. All terminal commands below apply to macOS / Linux / WSL.

---

## Comparison

| Tool | Type | Cost | Highlights | Payment |
|------|------|------|------------|---------|
| **Claude Code** | Terminal CLI | \$20/mo (Pro) – \$200/mo (Max) | Highest quality, autonomous planning & execution | Requires non-mainland China credit card |
| **Codex CLI** | Terminal CLI | Included with ChatGPT Plus (\$20/mo) | Open-source (Rust), good value | Works with existing OpenAI account |
| **OpenCode** | Terminal CLI | Free tool (built-in free models available) | Open-source, 75+ model providers, bring your own API key | Zero-cost entry, or pay per model |

---

## 1. Claude Code — Best Support to Skills

Claude Code is Anthropic's official AI coding assistant. It can autonomously plan, edit, run tests, and fix issues. Available as a terminal CLI, VS Code / JetBrains extension, desktop app, and web interface.

> **Docs**: [code.claude.com/docs](https://code.claude.com/docs/en/overview)
>
> **Note**: Claude Code subscription requires a non-mainland China credit card (e.g. Hong Kong or US card, or a virtual card service).

### 1.1 Installation

See the [official setup guide](https://code.claude.com/docs/en/setup). Quick install:

```bash
curl -fsSL https://claude.ai/install.sh | bash
claude doctor       # verify installation
```

### 1.2 Authentication

On first run of `claude`, follow the prompts to log in with a Claude Pro or Max account. See [claude.ai/pricing](https://claude.ai/pricing) for plans.

### 1.3 Recommended Model

- `opus-4.6`

---

## 2. Codex CLI — OpenAI Terminal Tool

Codex CLI is OpenAI's open-source (Apache-2.0) terminal AI coding assistant, written in Rust. If you already have a ChatGPT Plus account, you can use it at no extra cost.

> **Repository**: [github.com/openai/codex](https://github.com/openai/codex)
>
> **Best for**: Users with an existing OpenAI account.

### 2.1 Installation

See the [official setup guide](https://github.com/openai/codex#readme). Supports npm, Homebrew, and direct binary download.

### 2.2 Recommended Model

- `gpt-5.3-codex`
- See the latest models at [Codex models](https://developers.openai.com/codex/models).

---

## 3. OpenCode — Open-Source Free Terminal Tool

OpenCode is a fully open-source (MIT) AI coding assistant supporting 75+ model providers. It's ideal for:
- Users on a budget or who want flexible configuration
- Users who value open-source software
- Users without VPN access

> **Website**: [opencode.ai](https://opencode.ai) | **GitHub**: [github.com/anomalyco/opencode](https://github.com/anomalyco/opencode)
>
> **Pros**: Free tool; start with built-in free models, or plug in your own API key.
> **Cons**: Quality depends on the chosen model; generally not as good as Claude Code.

### 3.1 Installation

See the [official setup guide](https://github.com/anomalyco/opencode#readme). Quick install:

```bash
curl -fsSL https://opencode.ai/install | bash
```

Also available via Homebrew (`brew install opencode-ai/tap/opencode`), Go install, and AUR.

### 3.2 Recommended Models

In addition to the international models above:
- GLM 5
- Kimi 2.5
- DeepSeek V3

---

## FAQ

**Q: Proxy is configured but still can't connect?**
A: Check the following:
1. Is your proxy software running (e.g. Clash, V2Ray)?
2. Is the port correct (Clash default `7890`, V2Ray default `10808`)?
3. Run `curl -I https://api.anthropic.com` to test connectivity.
4. If using Pandafan, enable "Enhanced Mode" for the proxy to work properly.

**Q: Should Windows users use WSL or native?**
A: We recommend WSL 2 (`wsl --install`). Terminal tools (Claude Code, Codex CLI, OpenCode) work the same as on macOS / Linux under WSL. Cursor is a standalone IDE — install it natively on Windows.

**Q: Should I use Chinese or English when coding with AI?**
A: English reportedly produces better results.
