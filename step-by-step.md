---
layout: default
title: Step by Step
---

<style>
.prompt {
  border-left: 4px solid #b5e853;
  padding-left: 12px;
  margin: 12px 0;
  position: relative;
}
.prompt::before {
  content: "▶ Prompt";
  display: block;
  color: #b5e853;
  font-weight: bold;
  font-size: 0.85em;
  margin-bottom: 4px;
}
.prompt pre {
  position: relative;
}
.copy-btn {
  position: absolute;
  top: 6px;
  right: 6px;
  background: #333;
  color: #b5e853;
  border: 1px solid #b5e853;
  border-radius: 4px;
  padding: 2px 8px;
  font-size: 0.75em;
  cursor: pointer;
  opacity: 0;
  transition: opacity 0.2s;
}
.prompt pre:hover .copy-btn {
  opacity: 1;
}
.copy-btn:hover {
  background: #b5e853;
  color: #151515;
}
</style>

<script>
document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll(".prompt pre").forEach(function (pre) {
    var btn = document.createElement("button");
    btn.className = "copy-btn";
    btn.textContent = "Copy";
    btn.addEventListener("click", function () {
      var code = pre.querySelector("code");
      var text = code ? code.textContent : pre.textContent;
      navigator.clipboard.writeText(text.trim()).then(function () {
        btn.textContent = "Copied!";
        setTimeout(function () { btn.textContent = "Copy"; }, 1500);
      });
    });
    pre.style.position = "relative";
    pre.appendChild(btn);
  });
});
</script>

# Step-by-Step Guide

Follow these prompts in order inside **Claude Code** or **Codex CLI**. Type each prompt, wait for the AI to finish, then move to the next.

Prompts you need to type are marked with <span style="color: #b5e853; font-weight: bold;">▶ Prompt</span>.

**Prerequisites**: Install your AI coding tool. See the [Setup Guide](setup-guide) if needed.

---

# Part A: Build a Coding Project

## Step 1: Install Tools

<div class="prompt" markdown="1">
```
Install https://github.com/obra/superpowers and gh (GitHub CLI) if not already installed.
```
</div>

Then choose your model by typing `/model`:
- Claude Code: **Opus 4.6** (high effort)
- Codex CLI: **GPT-5.4** (xhigh effort)

---

## Step 2: Brainstorm Your Idea

<div class="prompt" markdown="1">
```
Brainstorm with me: <describe your project idea here>. use superpower skill
```
</div>

Replace `<describe your project idea here>` with what you want to build. For example:
*"Brainstorm with me: Build a symbolic engine for quantum symbolic simplification with rust. use superpower skill"*

---

## Step 3: Research Existing Work

<div class="prompt" markdown="1">
```
Is there some package already did the same thing? Is there a package that I can take advantage of?
```
</div>

Optionally, point the AI to specific projects to learn from:

<div class="prompt" markdown="1">
```
What can I learn from this project to improve my own: https://github.com/some-user/some-repo
```
</div>

---

## Step 4: Initialize and Publish the Repo

<div class="prompt" markdown="1">
```
initialize a repo with the current design file, sync to github with gh, create a test plan for human verification (file an issue), add the tests to integration tests as well.
```
</div>

---

## Step 5: Write a Plan

<div class="prompt" markdown="1">
```
/superpowers:writing-plans
```
</div>

Choose the **subagent-driven approach** when prompted.

---

## Step 6: Execute the Plan

<div class="prompt" markdown="1">
```
/superpowers:executing-plans
```
</div>

---

## Step 7: Set Up Project Config

After initial code implementation, generate a project config:

<div class="prompt" markdown="1">
```
/init
```
</div>

This creates a `CLAUDE.md` or `AGENTS.md` that helps the AI understand your project in future sessions.

---

# Part B: Create a Skill

A **skill** is a reusable prompt file that teaches the AI a specific workflow. Skills live in the [superpowers](https://github.com/obra/superpowers) framework and can be shared with others. See the [Complete Guide to Building Skills for Claude](https://resources.anthropic.com/hubfs/The-Complete-Guide-to-Building-Skill-for-Claude.pdf) for background.

## Step 1: Install Tools

Same as Part A — install superpowers and gh if not already done.

<div class="prompt" markdown="1">
```
Install https://github.com/obra/superpowers and gh (GitHub CLI) if not already installed.
```
</div>

---

## Step 2: Confirm Your Idea Is Suited for a Skill

<div class="prompt" markdown="1">
```
I want to <describe what the skill does>. Is this task suited to be implemented as a skill?
```
</div>

For example: *"I want to automate literature survey from a list of arxiv links. Is this task suited to be implemented as a skill?"*

---

## Step 3: Brainstorm Your Skill Idea

<div class="prompt" markdown="1">
```
Brainstorm with me: I want to create a skill that <describe what the skill does>. use superpower skill
```
</div>

---

## Step 4: Create the Skill

<div class="prompt" markdown="1">
```
/superpowers:writing-skills
```
</div>

This guides you through creating, naming, and writing the skill file.

---

## Step 5: Test the Skill

<div class="prompt" markdown="1">
```
/agentic-tests:test-skill
```
</div>

This simulates a user interacting with your skill and produces a test report.

---

## Step 6: Publish

<div class="prompt" markdown="1">
```
Upload code to GitHub with gh (if gh is missing, install and configure it first)
```
</div>

---

## Bonus: Quick Prompts to Improve Your Code

Copy-paste any of these at any time:

<div class="prompt" markdown="1">
```
Upload code to GitHub with gh (if gh is missing, install and configure it first)
```
</div>

<div class="prompt" markdown="1">
```
Generate Makefile/skills file to automate tasks
```
</div>

<div class="prompt" markdown="1">
```
Improve coverage to >95%, setup CI/CD and add README badge (if not yet done)
```
</div>

<div class="prompt" markdown="1">
```
Inspect the API design, follow the KISS principle, Follow the DRY principle
```
</div>

<div class="prompt" markdown="1">
```
Inspect the UI/UX logic, follow the HCI principles
```
</div>

---

## Going Further

Questions worth asking the AI to deepen your project:

- What is Mathematica's design for symbolic simplification? What can we learn from it?
- Is egraph useful for symbolic simplification?
- If my goal is LLM-driven theorem proving, brainstorm with me, what is the best strategy to build a package?

Useful references:

- [Makefile example](https://github.com/CodingThrust/problem-reductions/blob/main/Makefile) — automate your build
- [Agentic tests example](https://github.com/GiggleLiu/agentic-tests) — test your skill with AI agents
- [mdBook](https://rust-lang.github.io/mdBook/) — documentation tool for Rust projects
- [D3.js](https://d3js.org/) — interactive visualizations for documentation

### Makefile Target for Autonomous Plan Execution

Add this to your `Makefile` to let Claude execute a plan file autonomously:

```makefile
run-plan:
	@NL=$$'\n'; \
	BRANCH=$$(git branch --show-current); \
	PLAN_FILE="$(PLAN_FILE)"; \
	if [ "$(AGENT_TYPE)" = "claude" ]; then \
		PROCESS="1. Read the plan file$${NL}2. Execute the plan — it specifies which skill(s) to use$${NL}3. Push: git push origin $$BRANCH$${NL}4. If a PR already exists for this branch, skip. Otherwise create one."; \
	else \
		PROCESS="1. Read the plan file$${NL}2. Execute the tasks step by step. For each task, implement and test before moving on.$${NL}3. Push: git push origin $$BRANCH$${NL}4. If a PR already exists for this branch, skip. Otherwise create one."; \
	fi; \
	PROMPT="Execute the plan in '$$PLAN_FILE'."; \
	if [ -n "$(INSTRUCTIONS)" ]; then \
		PROMPT="$${PROMPT}$${NL}$${NL}## Additional Instructions$${NL}$(INSTRUCTIONS)"; \
	fi; \
	PROMPT="$${PROMPT}$${NL}$${NL}## Process$${NL}$${PROCESS}$${NL}$${NL}## Rules$${NL}- Tests should be strong enough to catch regressions.$${NL}- Do not modify tests to make them pass.$${NL}- Test failure must be reported."; \
	echo "=== Prompt ===" && echo "$$PROMPT" && echo "===" ; \
	claude --dangerously-skip-permissions \
		--model opus \
		--verbose \
		--max-turns 500 \
		-p "$$PROMPT" 2>&1 | tee "$(OUTPUT)"
```
