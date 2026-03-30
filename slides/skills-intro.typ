#import "@preview/touying:0.6.1": *
#import "@preview/pixel-family:0.2.0": *
#import "@preview/touying-simpl-hkustgz:0.1.2": *
#import "@preview/cetz:0.4.0": canvas, draw, tree

#set cite(style: "apa")

#let myslide(left, right, gutter: 20pt) = {
  grid(columns: (1fr, 1fr), gutter: gutter, left, right)
}

// Hearthstone class color palette
#let mage-bg = gradient.linear(rgb("#1a0a2e"), rgb("#4a1a8a"), angle: 90deg)
#let mage-border = rgb("#b388ff")
#let warrior-bg = gradient.linear(rgb("#2a0a0a"), rgb("#8c1a1a"), angle: 90deg)
#let warrior-border = rgb("#ff8a80")
#let paladin-bg = gradient.linear(rgb("#2a1f00"), rgb("#7c5a00"), angle: 90deg)
#let paladin-border = rgb("#ffd54f")
#let hunter-bg = gradient.linear(rgb("#0a2a1a"), rgb("#1a6a3a"), angle: 90deg)
#let hunter-border = rgb("#81c784")

#let draw-card(x, y, bg-color, border-color, suit, title, prompt, cast-when, stars, w: 3.8, h: 5.5) = {
  import draw: *
    let sw = w / 3.8
    let sh = h / 5.5
    let s = calc.min(sw, sh)

    rect((x, y), (x + w, y + h), fill: bg-color, stroke: border-color + 2pt, radius: 0.2 * s)
    rect((x + 0.15 * sw, y + 0.15 * sh), (x + w - 0.15 * sw, y + h - 0.15 * sh), fill: none, stroke: border-color.lighten(30%) + 0.8pt, radius: 0.15 * s)

    rect((x + 0.5 * sw, y + h * 0.836), (x + w - 0.5 * sw, y + h * 0.927), fill: border-color.darken(20%), stroke: none, radius: 0.1 * s)
    content((x + w / 2, y + h * 0.885), text(size: 11pt * s, fill: white, weight: "bold")[#suit #title])

    rect((x + 0.3 * sw, y + h * 0.25), (x + w - 0.3 * sw, y + h * 0.8), fill: rgb("#f5f0e1"), stroke: rgb("#c4b89b") + 0.8pt, radius: 0.1 * s)
    content((x + w / 2, y + h * 0.58), text(size: 8pt * s, fill: rgb("#4a3c2a"), [#prompt]))

    content((x + w / 2, y + h * 0.178), text(size: 8pt * s, fill: white, style: "italic")[#cast-when])

    let star-str = "★" * stars + "☆" * (5 - stars)
    content((x + w / 2, y + h * 0.118), text(size: 10pt * s, fill: rgb("#ffd700"))[#star-str])
}


#show: hkustgz-theme.with(
  config-info(
    title: [All you need is skill],
    subtitle: [an introduction to automation with AI agents],
    author: [Jin-Guo Liu],
    date: datetime.today(),
    institution: [HKUST(GZ) - FUNH - Advanced Materials Thrust],
  ),
)

#title-slide()

== Automation: the era of AI agents

#figure(
  canvas({
    import draw: *

    circle((0, 0), radius: 1.35, fill: rgb("#bbdefb"), stroke: none)
    circle((0, 0), radius: 1.2, fill: rgb("#e3f2fd"), stroke: (paint: rgb("#1976d2"), thickness: 2pt))
    content((0, 0), text(size: 14pt, weight: "bold", fill: rgb("#1565c0"))[AI Agent])

    let tools = (
      (name: "Web Search", angle: 90deg, color: rgb("#fafafa"), stroke: rgb("#9e9e9e")),
      (name: "Code Editor", angle: 30deg, color: rgb("#fafafa"), stroke: rgb("#9e9e9e")),
      (name: "Human", angle: 150deg, color: rgb("#fff3e0"), stroke: rgb("#e65100")),
      (name: "Database", angle: 210deg, color: rgb("#fafafa"), stroke: rgb("#9e9e9e")),
      (name: "File System", angle: 270deg, color: rgb("#fafafa"), stroke: rgb("#9e9e9e")),
      (name: "Git / GitHub", angle: 330deg, color: rgb("#fafafa"), stroke: rgb("#9e9e9e")),
    )

    let radius = 3.2

    for tool in tools {
      let x = radius * calc.cos(tool.angle)
      let y = radius * calc.sin(tool.angle)
      let is-human = tool.name == "Human"

      let inner-x = 1.2 * calc.cos(tool.angle)
      let inner-y = 1.2 * calc.sin(tool.angle)
      let outer-x = (radius - 0.95) * calc.cos(tool.angle)
      let outer-y = (radius - 0.95) * calc.sin(tool.angle)

      if is-human {
        line((inner-x, inner-y), (outer-x, outer-y), stroke: (paint: rgb("#e65100"), thickness: 2.5pt))
      } else {
        line((inner-x, inner-y), (outer-x, outer-y), stroke: (paint: rgb("#bdbdbd"), thickness: 1pt, dash: "dashed"))
      }

      if is-human {
        circle((x, y), radius: 1.05, fill: rgb("#ffe0b2"), stroke: none)
        circle((x, y), radius: 0.9, fill: tool.color, stroke: (paint: tool.stroke, thickness: 3pt))
        content((x, y), text(size: 11pt, weight: "bold", fill: rgb("#e65100"))[#tool.name])
      } else {
        circle((x, y), radius: 0.9, fill: tool.color, stroke: (paint: tool.stroke, thickness: 1pt))
        content((x, y), text(size: 10pt, fill: rgb("#616161"))[#tool.name])
      }
    }
  })
)

- Agents use *tools* (Model Context Protocol, MCP or command line interface, CLI) to act.
- *Skills* teach them how to use these tools to automate a task.

== To build skills, understand MCP/CLI first

#myslide(
  [
    *MCP*: agents call tools over the web, e.g. arXiv search. Supports multimedia inputs and outputs, e.g. image, video, etc.

    *CLI*: agents run commands on your computer, e.g. `git`, `python`, `make`.

#text(size: 14pt, fill: rgb("#555"))[
  _"The Unix philosophy accidentally built the perfect interface for AI agents."_ — *Andrej Karpathy* (co-founder of OpenAI).

  CLI tools are composable, scriptable, and growing fast — major services (Google, GitHub, AWS, ...) now ship CLIs alongside their GUIs.
]


  ],
  [
    #figure(
      image("images/gcloud-cli.png"),
      caption: [`gcloud` — manage Google Cloud from the terminal],
    )
  ],
)

== List of MCP/CLI tools


== What is a skill?

A *markdown file* that teaches an AI agent a *workflow*:

#text(size: 16pt)[
```markdown
---
name: paper-writing
description: Write an academic paper from outline to submission
---
## Steps
1. Discuss scope and contributions with the user
2. Draft the outline and section structure
3. Write each section iteratively
4. Search literature and add citations
5. Generate figures and tables
6. Proofread and format for the target venue
```
]

*Key insight*: small & explicit tasks $arrow$ reliable agent. Skills decompose big tasks into such pieces.

== Example
Research style skill: https://github.com/QuantumBFS/sci-brain/tree/main/skills/researchstyle

*Writing skill is easy*. The skill to write skills: `superpowers:writing-skills`

== The duality of skills and tools

Based on your workflow, you can write:
- Skills
- Skills + simple scripts (e.g. bash/makefile/python)
- Skills + CLI/MCP

Principle: *Advanced tools* $arrow.r$ *Simple skills*

== Complexity conservation law

#align(center, scale(150%,
  canvas(length: 1cm, {
    import draw: *

    let bar-h = 0.6
    let max-w = 8
    let y-gap = 1.8

    // --- Case 1: Sophisticated tool, simple skill ---
    content((-1.5, 0), text(size: 10pt, fill: rgb("#888"))[Case 1])

    // Tool bar (long)
    let tool-w1 = 6.5
    rect((0, bar-h / 2), (tool-w1, -bar-h / 2), fill: rgb("#1565c0"), stroke: none, radius: 0.15)
    content((tool-w1 / 2, 0), text(size: 10pt, fill: white, weight: "bold")[🔧 Sophisticated Tool])

    // Skill bar (short)
    let skill-w1 = max-w - tool-w1 - 0.2
    rect((tool-w1 + 0.2, bar-h / 2), (max-w, -bar-h / 2), fill: green.lighten(30%), stroke: none, radius: 0.15)
    content((tool-w1 + 0.2 + skill-w1 / 2, 0), text(size: 9pt, weight: "bold")[📜])

    // --- Case 2: Simple tool, sophisticated skill ---
    content((-1.5, -y-gap), text(size: 10pt, fill: rgb("#888"))[Case 2])

    // Tool bar (short)
    let tool-w2 = 1.8
    rect((0, -y-gap + bar-h / 2), (tool-w2, -y-gap - bar-h / 2), fill: rgb("#1565c0"), stroke: none, radius: 0.15)
    content((tool-w2 / 2, -y-gap), text(size: 9pt, fill: white, weight: "bold")[🔧])

    // Skill bar (long)
    let skill-w2 = max-w - tool-w2 - 0.2
    rect((tool-w2 + 0.2, -y-gap + bar-h / 2), (max-w, -y-gap - bar-h / 2), fill: green.lighten(30%), stroke: none, radius: 0.15)
    content((tool-w2 + 0.2 + skill-w2 / 2, -y-gap), text(size: 10pt, weight: "bold")[📜 Sophisticated Skill])

    // Legend
    rect((0, -y-gap - bar-h / 2 - 0.7), (1.2, -y-gap - bar-h / 2 - 1.1), fill: rgb("#1565c0"), stroke: none, radius: 0.1)
    content((1.6, -y-gap - bar-h / 2 - 0.9), anchor: "west", text(size: 9pt)[CLI / MCP Tool])
    rect((4.2, -y-gap - bar-h / 2 - 0.7), (5.4, -y-gap - bar-h / 2 - 1.1), fill: green.lighten(30%), stroke: none, radius: 0.1)
    content((5.8, -y-gap - bar-h / 2 - 0.9), anchor: "west", text(size: 9pt)[Skill (recipe)])
  })
))

== How the hackathon works?

1. Decide what to build: *MCP/CLI or skills?*, must check: https://giggleliu.github.io/HKUST-Got-Skills/resources . File an issue on GitHub: https://github.com/GiggleLiu/HKUST-Got-Skills/issues (15 min), about the brief idea of what to build. I will help you group (with skills by similarity).
2. Every group confirm "what & how to build" at the help desk after initial design, for technical feasibility check.
3. *Grouping*: 1-4 people per group, use skills by similarity. Find a room in Maker space to work together.
4. *Task*: Each group presents a skill (or mcp/cli tool) they have built on Wednesday.

Check the program: https://giggleliu.github.io/HKUST-Got-Skills/program

== Key resources

- *Help desk*: On the main stage. The online communication is via both WeChat and GitHub discussion (technical discussion).
- *Room booking*: Ask help desk for more available rooms. We will refresh the list of available rooms on WeChat group.
- *Tea time*: 10:00-10:30, 15:00-15:30, for casual gathering and discussion.
- *Pixel art*: If you want a cool pixel art (#bob()), you can register at the help desk.

== Live coding

Live coding: https://giggleliu.github.io/HKUST-Got-Skills/step-by-step
- *CLI* to simulate materials with Quantum ESPRESSO
- *Skill* to let a beginner (zero knowledge to materials simulation) to access this tool with AI agent

=== Tips
1. Carefully check the *available tools* from our website resources page before moving on.
2. Identify the *creative part* of your skill and use the `AskUserQuestion` tool to ask the user for input. It is a tool that allows the agent to utilize human's expertise.
3. Identify the *mechanical parts* of your skill and write bash/makefile/python scripts to improve the performance.