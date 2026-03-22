---
name: learn-skill
description: Use when an academic researcher wants to automate a workflow with a Claude Code skill, learn how skills work, or identify which of their repetitive workflows would benefit from a skill — guides discovery, selection, and hands-on skill creation
---

# Learn Skill

A skill that walks you through finding a repetitive workflow worth automating and building a Claude Code skill for it. One workflow per session — re-invoke for the next one.

## Phase 1: Setup & Discovery

### Step 1: Prerequisites

Check and install two tools. Do the checks silently (run `gh --version` and check for `~/.claude/plugins/cache/claude-plugins-official/superpowers/`). Only ask the researcher to act if something is missing.

If **`gh` CLI** is missing, explain in plain language and guide install:
> "`gh` is a tool that lets Claude talk to GitHub for you — things like creating pull requests or checking if tests passed. Let's install it first."
- macOS: `brew install gh`, Ubuntu/Debian: `sudo apt install gh`, other: https://cli.github.com/
- After install: `gh auth login`

If **superpowers plugin** is missing, explain and guide install:
> "Skills live inside plugins — think of a plugin as a toolbox, and skills are the individual tools inside it. Superpowers is a plugin with many useful skills, including the `brainstorming` skill we'll use soon. Let's install it."
- Install: `claude plugins install superpowers`

If both are already installed, briefly confirm and explain what they are so the researcher understands.

### Step 2: Direction & Candidates

Use the `AskUserQuestion` tool to ask the researcher what area of their work feels repetitive. Before asking, explain the "sweet spot" concept in plain language:

> "Not every workflow makes a good skill. Here's the sweet spot we're looking for:"
> - **Too mechanical** = a simple script could do it (e.g., renaming files). No need for a skill.
> - **Too creative** = requires genuine novelty (e.g., coming up with research ideas). AI produces cheap ideas easily — that's not the right target.
> - **Just right** = work that follows a repeatable pattern but still needs your judgment at key points.

Then use `AskUserQuestion` with:
- question: "What area of your work feels repetitive but not trivially scriptable? Think about tasks you do regularly that follow a pattern but still require your judgment."
- Provide 3 concrete example options as starting points (tailored if possible, otherwise use generic academic examples like "literature review with structured extraction," "preparing a conference submission," "reviewing and formatting experiment results")
- Always include a 4th option as "Change a batch" — which generates 3 new suggestions

After the researcher picks one (or describes their own), summarize the choice.

### Step 3: Transition

Explain the next step in plain language, then transition:

> "Now we'll use the `brainstorming` skill to design your new skill. `brainstorming` is itself a skill — notice how it's about to guide this conversation by asking you questions, proposing options, and building a design step by step. By the end, you'll have built something that works the same way, but for your own workflow."

## Phase 2: Educate & Build

### Step 1: Invoke Brainstorming

Use the `Skill` tool with `skill: "superpowers:brainstorming"`. Pass the chosen workflow as `args`, including educational callout instructions. Example args format:

> "Design a skill for [chosen workflow description]. This is being built as part of a learning exercise — at natural transition points during the design process, include brief (1-2 sentence) educational callouts: when drafting the spec, explain what frontmatter is (name and description fields) and why the description matters for skill triggering; when presenting the design, point out the structural patterns (overview, process, quick reference) and why they're organized that way; when approaching implementation, explain that skills live in ~/.claude/skills/ and how Claude discovers them. These callouts should yield to your normal brainstorming flow — don't let them disrupt approval gates."

Brainstorming will handle: clarifying questions (one at a time), proposing 2-3 approaches, presenting design in sections with approval gates, and writing a spec document.

### Step 3: Write the Skill (via writing-plans)

After brainstorming produces a spec, invoke the Skill tool with `skill: "superpowers:writing-plans"` to create an implementation plan. Execute the plan to:

1. Write the new skill's SKILL.md file
2. Place it in `~/.claude/skills/<skill-name>/SKILL.md`
3. Smoke-test: ask the researcher to start a **new Claude Code session** and describe their workflow. Verify the skill triggers from its frontmatter alone. If it doesn't trigger, adjust the `description` field and retry.

### Step 4: Wrap-Up

Summarize what the researcher learned in plain language, anchored by a key framework — **two types of skills:**

**Mentor skills** — These are like a knowledgeable colleague looking over your shoulder. They guide you by asking questions, weighing pros and cons, and making recommendations with reasons. They *teach* you.
- `brainstorming` — guided the design conversation just now
- `systematic-debugging` — asks diagnostic questions before jumping to fixes
- `learn-skill` itself — the skill that just walked you through this process

**Worker skills** — These are like a reliable assistant handling the tedious parts. They execute structured work that would be repetitive or error-prone to do by hand. They *apply* what you've learned.
- `executing-plans` — runs through implementation steps one by one
- A custom "prepare submission package" skill — assembles files, checks formatting, validates references

*"Mentor skills help you learn. Worker skills utilize what you've learned. The skill you just built could be either — and now you know how to build both."*

Finally:
- Remind them where their skill lives (`~/.claude/skills/<name>/SKILL.md`) — it's just a text file they can open and edit anytime
- Invite them to re-invoke `learn-skill` for their next workflow
