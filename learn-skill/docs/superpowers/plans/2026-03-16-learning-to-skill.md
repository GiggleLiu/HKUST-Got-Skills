# learning-to-skill Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a skill that guides academic researchers through discovering automatable workflows and building their first Claude Code skill.

**Architecture:** Single SKILL.md file at `~/.claude/skills/learning-to-skill/SKILL.md`. No supporting files. The skill delegates to `superpowers:brainstorming` and `superpowers:writing-plans` for heavy lifting.

**Tech Stack:** Markdown (SKILL.md format with YAML frontmatter)

**Spec:** `/home/leo/Documents/learn-skill/docs/superpowers/specs/2026-03-16-learning-to-skill-design.md`

---

## Chunk 1: Write and Install the Skill

### Task 1: Write the SKILL.md

**Files:**
- Create: `~/.claude/skills/learning-to-skill/SKILL.md`

- [ ] **Step 1: Create the skill directory**

```bash
mkdir -p ~/.claude/skills/learning-to-skill
```

- [ ] **Step 2: Write the SKILL.md file**

Create `~/.claude/skills/learning-to-skill/SKILL.md` with the following **literal content** (copy verbatim):

````markdown
---
name: learning-to-skill
description: Use when an academic researcher wants to automate a workflow with a Claude Code skill, learn how skills work, or identify which of their repetitive workflows would benefit from a skill — guides discovery, selection, and hands-on skill creation
---

# Learning to Skill

A skill that walks you through finding a repetitive workflow worth automating and building a Claude Code skill for it. One workflow per session — re-invoke for the next one.

## Phase 1: Setup & Discovery

### Step 1: Prerequisites

Check and install two tools. For each, explain what it does and why the researcher needs it.

**GitHub CLI (`gh`):**
- Check: run `gh --version`
- Install if missing: macOS `brew install gh`, Ubuntu/Debian `sudo apt install gh`, other: https://cli.github.com/
- After install: `gh auth login`
- Explain: "`gh` is the GitHub CLI — it lets Claude interact with GitHub on your behalf: creating PRs, checking CI, managing issues. Many skills use it under the hood."

**Superpowers plugin:**
- Check: look for directory `~/.claude/plugins/cache/claude-plugins-official/superpowers/`
- Install if missing: run `claude plugins install superpowers` in the terminal
- Explain: "Skills live inside plugins. Superpowers is a plugin that comes with a collection of skills — including the `brainstorming` skill we'll use in the next phase."

### Step 2: Environment Observation

Scan the researcher's environment without narrating each step. Look at:
- Project structure (files, directories, languages)
- Shell history (`~/.zsh_history` or `~/.bash_history` — best-effort, skip if inaccessible)
- Git log (recent commit patterns, workflows)
- Existing scripts, Makefiles, config files
- Any existing skills in `~/.claude/skills/`

Use findings to seed candidate generation. Look for: commands repeated 3+ times, multi-step git workflows, file transformation patterns, recurring manual processes.

### Step 3: Direction & Candidates

Ask the researcher: **"What area of your work feels repetitive but not trivially scriptable?"**

Combining their answer with your observations, propose **3 workflow candidates** plus a 4th option: **"Change a batch"** (generates 3 new suggestions).

Candidates must sit in the sweet spot. Explain these criteria to the researcher:
- **Not too mechanical** — a bash script could handle it (e.g., "rename files"). Too simple for a skill.
- **Not too creative** — requires genuine novelty (e.g., "generate research ideas"). Agents produce cheap ideas easily; this isn't the right target.
- **Just right** — repeatable structure that still requires human judgment (e.g., "literature review with structured extraction," "experiment log formatting with analysis prompts," "preparing a conference submission package").

For each candidate, explain **why** it's a good skill target.

### Step 4: Selection & Transition

Researcher picks one. Summarize the choice, then say:

> "Now we'll use the `brainstorming` skill to design your new skill. Brainstorming is itself a skill — it's guiding this conversation right now. By the end, you'll have built something like it for your own workflow."

## Phase 2: Educate & Build

### Step 1: Meta-Learning Moment

Before invoking brainstorming, explain:

> "We're about to invoke the `brainstorming` skill. This is a skill just like the one you're about to build — it structures a conversation to produce a design. Notice how it asks questions, proposes approaches, and presents designs in sections. Your skill will do the same kind of thing for your workflow."

### Step 2: Invoke Brainstorming

Use the Skill tool with `skill: "superpowers:brainstorming"`. Pass the chosen workflow as `args`, including educational callout instructions. Example args format:

> "Design a skill for [chosen workflow description]. This is being built as part of a learning exercise — at natural transition points during the design process, include brief (1-2 sentence) educational callouts: when drafting the spec, explain what frontmatter is (name and description fields) and why the description matters for skill triggering; when presenting the design, point out the structural patterns (overview, process, quick reference) and why they're organized that way; when approaching implementation, explain that skills live in ~/.claude/skills/ and how Claude discovers them. These callouts should yield to your normal brainstorming flow — don't let them disrupt approval gates."

Brainstorming will handle: clarifying questions (one at a time), proposing 2-3 approaches, presenting design in sections with approval gates, and writing a spec document.

### Step 3: Write the Skill (via writing-plans)

After brainstorming produces a spec, invoke the Skill tool with `skill: "superpowers:writing-plans"` to create an implementation plan. Execute the plan to:

1. Write the new skill's SKILL.md file
2. Place it in `~/.claude/skills/<skill-name>/SKILL.md`
3. Smoke-test: ask the researcher to start a **new Claude Code session** and describe their workflow. Verify the skill triggers from its frontmatter alone. If it doesn't trigger, adjust the `description` field and retry.

### Step 4: Wrap-Up

Summarize what the researcher learned, anchored by a key framework — **two types of skills:**

**Mentor skills** — More knowledgeable than you in some aspect. They interact by asking questions, analyzing pros and cons, and making recommendations with reasons. They *teach* you.
- `brainstorming` — guided the design conversation just now
- `systematic-debugging` — asks diagnostic questions before jumping to fixes
- `learning-to-skill` itself — the skill that just walked you through this process

**Worker skills** — Do the heavy lifting. They execute structured work that would be tedious or error-prone to do manually. They *apply* what you've learned.
- `executing-plans` — runs through implementation steps
- A custom "prepare submission package" skill — assembles files, checks formatting, validates references

*"Mentor skills help you learn. Worker skills utilize what you've learned. The skill you just built could be either — and now you know how to build both."*

Finally:
- Remind them where their skill lives (`~/.claude/skills/<name>/SKILL.md`) and that they can edit it directly
- Invite them to re-invoke `learning-to-skill` for their next workflow
````

- [ ] **Step 3: Verify frontmatter is valid**

Check:
- `name` contains only letters, numbers, hyphens: `learning-to-skill` ✓
- `description` starts with "Use when": ✓
- `description` under 1024 chars: count and verify
- No extra frontmatter fields

- [ ] **Step 4: Verify the file is concise**

The skill should be complete but not bloated. Keep it concise — every section should earn its place.

### Task 2: Smoke Test

- [ ] **Step 1: Verify file exists at correct path**

```bash
ls -la ~/.claude/skills/learning-to-skill/SKILL.md
```

Expected: file exists with non-zero size.

- [ ] **Step 2: Verify frontmatter parses correctly**

```bash
head -5 ~/.claude/skills/learning-to-skill/SKILL.md
```

Expected: starts with `---`, contains `name: learning-to-skill`, contains `description: Use when...`, ends with `---`.

- [ ] **Step 3: Manual trigger test**

Ask the user to start a new Claude Code session and type something like:
- "I want to automate one of my research workflows"
- "Help me create a skill for my work"

Expected: Claude discovers and loads the `learning-to-skill` skill.

If it doesn't trigger, adjust the `description` field to better match the researcher's phrasing and repeat.

- [ ] **Step 4: Commit plan and skill to project repo**

```bash
cd /home/leo/Documents/learn-skill
git add docs/superpowers/plans/2026-03-16-learning-to-skill.md
git commit -m "docs: add implementation plan for learning-to-skill"
```
