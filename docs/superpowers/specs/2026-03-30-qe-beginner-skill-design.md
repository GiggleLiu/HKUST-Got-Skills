# QE Beginner Skill: Design Spec

**Date**: 2026-03-30
**Status**: Approved
**Approach**: Skill + Python CLI toolkit (Approach 2)

## Problem

A researcher with zero knowledge of DFT or materials simulation wants to run a Quantum ESPRESSO calculation. They have a material in mind and can obtain a CIF/POSCAR structure file, but don't know what pseudopotentials are, what energy cutoffs to use, how to write QE input files, or how to interpret output.

## Solution

Two deliverables that work together:

1. **SKILL.md** -- A mentor-style conversational guide that teaches the AI agent how to walk a beginner through their first SCF calculation
2. **`qe-beginner`** -- A Python CLI tool that handles all technical operations (structure conversion, pseudopotential selection, execution, output parsing, visualization)

The skill owns the conversation and pedagogy. The CLI tool owns correctness. The agent never writes QE input files directly.

## Architecture

```
┌─────────────────────────────────────────────────┐
│  SKILL.md  (mentor-style conversational guide)  │
│                                                 │
│  Teaches the AI agent how to:                   │
│  1. Greet user, check environment               │
│  2. Accept CIF/POSCAR, explain what it contains │
│  3. Run qe-beginner commands at each step       │
│  4. Explain results in plain English             │
│  5. Show visualization                          │
└──────────────────┬──────────────────────────────┘
                   │ calls
                   ▼
┌─────────────────────────────────────────────────┐
│  qe-beginner  (Python CLI tool)                 │
│                                                 │
│  Subcommands:                                   │
│  • check-env     → detect QE, offer install     │
│  • convert       → CIF/POSCAR → QE input        │
│  • run           → execute pw.x (local or SSH)   │
│  • parse         → extract results from output   │
│  • visualize     → crystal structure + summary   │
└─────────────────────────────────────────────────┘
```

## Scope

- **Calculation type**: SCF only (pw.x)
- **Execution targets**: Local machine + HPC via SSH
- **Material input**: CIF or POSCAR file (no natural-language guessing)
- **Pseudopotentials**: Automatic selection from SSSP Efficiency library
- **Post-calculation**: Plain-English summary + crystal structure visualization (PNG)
- **QE installation**: Auto-install via conda on local; check-only on HPC

## Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Scope | SCF only | Foundation for everything else; keeps skill focused and buildable in 3 days |
| Material input | CIF/POSCAR file | Avoids LLM hallucinating crystal structures; databases like Materials Project provide authoritative files |
| Pseudopotentials | Auto from SSSP | Beginners can't choose; SSSP Efficiency is a curated, tested set with recommended cutoffs |
| Input generation | pymatgen, not LLM | LLM may produce subtly wrong QE input syntax; pymatgen handles units, symmetry, formatting correctly |
| Visualization | matplotlib | Lightweight, no browser needed, works in terminal + SSH |

## `qe-beginner` CLI Tool

### Subcommands

#### `qe-beginner check-env`
- Checks if `pw.x` is on PATH (or reachable via `module load`)
- Reports QE version if found
- If not found locally: prints the install command (`conda install -c conda-forge qe`) and exits with a specific return code so the agent can offer to run it
- If on HPC (detected via `--hpc` flag): reports missing and exits with guidance to check `module avail`
- Checks Python deps (pymatgen, matplotlib); prints install commands if missing
- Output: JSON status report

#### `qe-beginner convert <file.cif|POSCAR> [--ecutwfc N] [--kpoints N N N]`
- Parses structure using `pymatgen.core.Structure.from_file()`
- Auto-selects pseudopotentials from bundled SSSP Efficiency metadata (element -> PP filename + ecutwfc + ecutrho)
- Uses highest ecutwfc among all elements as default
- Generates complete `scf.in` with sensible defaults:
  - `calculation = 'scf'`
  - `ecutwfc` / `ecutrho` from SSSP
  - k-points from pymatgen's automatic mesh (density-based)
  - `conv_thr = 1.0d-6`
  - `ibrav=0` with explicit `CELL_PARAMETERS`
- Downloads needed pseudopotential files from QE repository if not present
- Output: path to `scf.in` + human-readable summary

#### `qe-beginner run [--np N] [--ssh user@host] [--remote-dir /path]`
- Local mode: `mpirun -np N pw.x < scf.in > scf.out` (default `np=1`)
- SSH mode: copies `scf.in` + pseudopotentials to remote, runs via SSH, copies output back
- Streams progress (SCF iteration energies) to stdout
- Output: path to `scf.out`

#### `qe-beginner parse <scf.out>`
- Extracts: convergence status, iteration count, total energy, Fermi energy, forces per atom, pressure, wall time
- Flags warnings: non-convergence, high forces, negative pressure
- Output: JSON with all quantities + plain-English summary string

#### `qe-beginner visualize <scf.out|file.cif>`
- Renders crystal structure (ball-and-stick with element labels and unit cell box) using pymatgen + matplotlib
- Annotates with key SCF results if output file provided
- Saves as PNG
- Output: path to PNG

### Package Structure

```
qe-beginner/
├── pyproject.toml
├── src/qe_beginner/
│   ├── __init__.py
│   ├── cli.py            # click CLI entry point
│   ├── environment.py    # check-env logic
│   ├── convert.py        # CIF → QE input generation
│   ├── runner.py         # local + SSH execution
│   ├── parser.py         # output parsing
│   ├── visualize.py      # structure rendering
│   └── sssp/
│       └── sssp_efficiency.json  # bundled SSSP metadata
└── tests/
    ├── test_convert.py
    ├── test_parser.py
    └── fixtures/
        ├── Si.cif
        └── scf_si.out
```

### Dependencies
- Python >= 3.9
- pymatgen (structure I/O, k-point mesh, symmetry)
- matplotlib (visualization)
- click (CLI framework)

## SKILL.md Conversational Flow

### Phase 1: Environment Setup
- Agent greets user, runs `qe-beginner check-env`
- Handles missing QE (conda install locally; guidance for HPC module)
- Confirms environment is ready

### Phase 2: Structure Input
- Asks user for CIF/POSCAR file path
- Runs `qe-beginner convert <file>`
- Presents human-readable summary of material, lattice, pseudopotentials, cutoffs, k-points
- Offers to explain any parameter before proceeding

### Phase 3: Run Calculation
- Explains what SCF means in one sentence
- Asks: local or SSH?
- Runs `qe-beginner run` with appropriate flags
- Relays iteration progress
- Reports completion with timing

### Phase 4: Results & Visualization
- Runs `qe-beginner parse scf.out`
- Presents plain-English summary with key quantities
- Interprets results for the beginner (e.g., "low forces mean the structure is at equilibrium")
- Runs `qe-beginner visualize scf.out`
- Shows crystal structure PNG

### Phase 5: Next Steps (optional)
- Suggests natural follow-ups: vary lattice constant, check cutoff convergence, try another material
- Answers questions about results

### Error Handling
The skill instructs the agent how to handle:
- **Non-convergence**: suggest increasing ecutwfc or k-points
- **Missing pseudopotential**: try alternative download source
- **SSH timeout**: check if job is still running remotely
- **Crash/segfault**: suggest reducing system size or increasing cores

## Testing Strategy

### `qe-beginner` CLI
- **Unit tests for `convert.py`**: CIF for silicon -> verify `scf.in` has correct `nat`, `ntyp`, `CELL_PARAMETERS`, `ATOMIC_POSITIONS`, `ecutwfc`
- **Unit tests for `parser.py`**: parse bundled reference `scf_si.out` -> verify extracted energy, forces, convergence match expected values
- **Smoke test for `visualize.py`**: verify PNG is produced without crash
- **No tests for `runner.py`**: requires QE installed, not worth it for hackathon

### SKILL.md
- Manual walkthrough with silicon CIF
- Optionally: `/agentic-tests:test-skill` for automated role-play testing

### Test fixtures
- `tests/fixtures/Si.cif` -- silicon crystal structure
- `tests/fixtures/scf_si.out` -- reference QE output for silicon SCF
