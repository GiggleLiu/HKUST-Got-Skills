# QE Beginner Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Claude Code skill + Python CLI tool that guides complete beginners through their first Quantum ESPRESSO SCF calculation.

**Architecture:** A SKILL.md mentor-style guide orchestrates conversation, delegating all technical operations to a `qe-beginner` Python CLI tool. The CLI uses pymatgen for structure I/O, bundles SSSP metadata for pseudopotential selection, and matplotlib for visualization.

**Tech Stack:** Python 3.9+, pymatgen, matplotlib, click, pytest

**Spec:** `docs/superpowers/specs/2026-03-30-qe-beginner-skill-design.md`

---

## File Structure

```
qe-beginner/                          # project root (new repo)
├── pyproject.toml                    # package config, dependencies, CLI entry point
├── README.md                         # usage instructions
├── src/qe_beginner/
│   ├── __init__.py                   # version string
│   ├── cli.py                        # click CLI: wires subcommands
│   ├── environment.py                # check-env: detect QE, deps
│   ├── convert.py                    # CIF/POSCAR → scf.in generation
│   ├── runner.py                     # local + SSH pw.x execution
│   ├── parser.py                     # scf.out → structured results
│   ├── visualize.py                  # crystal structure PNG rendering
│   └── sssp/
│       ├── __init__.py               # load_sssp_data() helper
│       └── sssp_efficiency.json      # bundled SSSP metadata
├── tests/
│   ├── conftest.py                   # shared fixtures
│   ├── test_environment.py
│   ├── test_convert.py
│   ├── test_parser.py
│   ├── test_visualize.py
│   └── fixtures/
│       ├── Si.cif                    # diamond cubic silicon
│       └── scf_si.out               # reference QE output
└── .claude/
    └── skills/
        └── qe-beginner/
            └── SKILL.md              # the Claude Code skill
```

---

### Task 1: Project Scaffolding

**Files:**
- Create: `pyproject.toml`
- Create: `src/qe_beginner/__init__.py`
- Create: `tests/conftest.py`
- Create: `tests/fixtures/Si.cif`
- Create: `tests/fixtures/scf_si.out`

- [ ] **Step 1: Initialize repo and create pyproject.toml**

```bash
mkdir qe-beginner && cd qe-beginner && git init
```

Create `pyproject.toml`:

```toml
[build-system]
requires = ["setuptools>=68.0"]
build-backend = "setuptools.backends._legacy:_Backend"

[project]
name = "qe-beginner"
version = "0.1.0"
description = "CLI tool to help beginners run Quantum ESPRESSO SCF calculations"
requires-python = ">=3.9"
dependencies = [
    "pymatgen>=2024.1.1",
    "matplotlib>=3.7",
    "click>=8.0",
]

[project.optional-dependencies]
dev = ["pytest>=7.0"]

[project.scripts]
qe-beginner = "qe_beginner.cli:main"

[tool.setuptools.packages.find]
where = ["src"]
```

- [ ] **Step 2: Create package init**

Create `src/qe_beginner/__init__.py`:

```python
__version__ = "0.1.0"
```

- [ ] **Step 3: Create test fixtures - Si.cif**

Create `tests/fixtures/Si.cif`:

```
data_Si
_symmetry_space_group_name_H-M   'F d -3 m'
_cell_length_a   5.431
_cell_length_b   5.431
_cell_length_c   5.431
_cell_angle_alpha   90.000
_cell_angle_beta   90.000
_cell_angle_gamma   90.000

loop_
_atom_site_label
_atom_site_type_symbol
_atom_site_fract_x
_atom_site_fract_y
_atom_site_fract_z
Si1 Si 0.00000 0.00000 0.00000
Si2 Si 0.25000 0.25000 0.25000
```

- [ ] **Step 4: Create test fixtures - scf_si.out**

Create `tests/fixtures/scf_si.out`:

```

     Program PWSCF v.7.2 starts on 30Mar2026 at 10: 0: 0

     This program is part of the open-source Quantum ESPRESSO suite
     for quantum simulation of materials; please cite
         "P. Giannozzi et al., J. Phys.:Condens. Matter 21 395502 (2009);
         "P. Giannozzi et al., J. Phys.:Condens. Matter 29 465901 (2017);
         "P. Giannozzi et al., J. Chem. Phys. 152 154105 (2020);
          URL http://www.quantum-espresso.org",
     in publications or presentations arising from this work. More details at
     http://www.quantum-espresso.org/quote

     Parallel version (MPI), running on     1 processors

     Reading input from scf.in

     Current dimensions of program PWSCF are:
     Max number of different atomic species (ntypx) = 10
     Max number of k-points (npk) =  40000

     Subspace diagonalization in iterative solution of the eigenvalue problem:
     a serial algorithm will be used


     G-vector sticks info
     --------------------
     sticks:   dense  smooth    PW     G-vecs:    dense   smooth      PW
     Sum         283     283    91                 3119     3119     531

     Using Slab Decomposition


     bravais-lattice index     =            0
     lattice parameter (alat)  =  10.2625 a.u.
     unit-cell volume          =  270.1693 (a.u.)^3
     number of atoms/cell      =            2
     number of atomic types    =            1
     number of electrons       =         8.00
     number of Kohn-Sham states=            4
     kinetic-energy cutoff     =  30.0000  Ry
     charge-density cutoff     = 240.0000  Ry
     scf convergence threshold =  1.0E-06
     mixing beta               =       0.7000
     number of iterations used =            8  plain     mixing
     Exchange-correlation= PBE
                           (   1   4   3   4   0   0   0)

     celldm(1)=  10.262500  celldm(2)=   0.000000  celldm(3)=   0.000000
     celldm(4)=   0.000000  celldm(5)=   0.000000  celldm(6)=   0.000000

     crystal axes: (cart. coord. in units of alat)
               a(1) = (   0.000000   0.500000   0.500000 )
               a(2) = (   0.500000   0.000000   0.500000 )
               a(3) = (   0.500000   0.500000   0.000000 )

     number of k points=    10
                       cart. coord. in units 2pi/alat
        k(    1) = (   0.0000000   0.0000000   0.0000000), wk =   0.0160000

     Self-consistent Calculation

     iteration #  1     ecut=    30.00 Ry     beta= 0.70
     Energy is    -15.85418765 Ry
     estimated scf accuracy <       0.06085255 Ry

     iteration #  2     ecut=    30.00 Ry     beta= 0.70
     Energy is    -15.85644521 Ry
     estimated scf accuracy <       0.00399537 Ry

     iteration #  3     ecut=    30.00 Ry     beta= 0.70
     Energy is    -15.85661472 Ry
     estimated scf accuracy <       0.00008413 Ry

     iteration #  4     ecut=    30.00 Ry     beta= 0.70
     Energy is    -15.85661823 Ry
     estimated scf accuracy <       0.00000147 Ry

     iteration #  5     ecut=    30.00 Ry     beta= 0.70
     Energy is    -15.85661832 Ry
     estimated scf accuracy <       0.00000003 Ry

     convergence has been achieved in   5 iterations

     Forces acting on atoms (cartesian axes, Ry/au):

     atom    1 type  1   force =     0.00000000    0.00000000    0.00000000
     atom    2 type  1   force =     0.00000000    0.00000000    0.00000000

     Total force =     0.000000     Total SCF correction =     0.000000


     Computing stress (Cartesian axis) for a]

          total   stress  (Ry/bohr**3)                   (kbar)     P=       0.12
   0.00000082   0.00000000   0.00000000            0.12        0.00        0.00
   0.00000000   0.00000082   0.00000000            0.00        0.12        0.00
   0.00000000   0.00000000   0.00000082            0.00        0.00        0.12

     the Fermi energy is     6.3539 ev

!    total energy              =     -15.85661832 Ry
     estimated scf accuracy    <       0.00000003 Ry

     The total energy is the sum of the following terms:
     one-electron contribution =       4.83255169 Ry
     hartree contribution      =       1.08337295 Ry
     xc contribution           =      -4.83206565 Ry
     ewald contribution        =     -16.94047730 Ry

     convergence has been achieved in   5 iterations

     Writing all to output data dir ./tmp/si.save/

     PWSCF        :      0.45s CPU      0.52s WALL

     This run was terminated on:  10: 0: 1  30Mar2026

=------------------------------------------------------------------------------=
   JOB DONE.
=------------------------------------------------------------------------------=
```

- [ ] **Step 5: Create conftest.py with shared fixtures**

Create `tests/conftest.py`:

```python
from pathlib import Path

import pytest

FIXTURES_DIR = Path(__file__).parent / "fixtures"


@pytest.fixture
def si_cif_path():
    return FIXTURES_DIR / "Si.cif"


@pytest.fixture
def scf_si_out_path():
    return FIXTURES_DIR / "scf_si.out"
```

- [ ] **Step 6: Install in dev mode and verify**

```bash
cd qe-beginner
pip install -e ".[dev]"
pytest --co  # should collect 0 tests, no errors
```

Expected: clean install, no import errors.

- [ ] **Step 7: Commit**

```bash
git add -A
git commit -m "feat: project scaffolding with pyproject.toml and test fixtures"
```

---

### Task 2: SSSP Metadata Module

**Files:**
- Create: `src/qe_beginner/sssp/__init__.py`
- Create: `src/qe_beginner/sssp/sssp_efficiency.json`

- [ ] **Step 1: Create SSSP efficiency JSON**

Create `src/qe_beginner/sssp/sssp_efficiency.json`:

This contains a curated subset of elements from the SSSP Efficiency v1.3 library. Each entry maps an element symbol to its recommended pseudopotential filename, cutoffs, and type.

```json
{
  "H": {
    "filename": "H.pbe-rrkjus_psl.1.0.0.UPF",
    "ecutwfc": 30,
    "ecutrho": 240,
    "pp_type": "US"
  },
  "He": {
    "filename": "He.pbe-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 40,
    "ecutrho": 320,
    "pp_type": "PAW"
  },
  "Li": {
    "filename": "Li.pbe-s-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 40,
    "ecutrho": 320,
    "pp_type": "PAW"
  },
  "Be": {
    "filename": "Be.pbe-n-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 40,
    "ecutrho": 320,
    "pp_type": "PAW"
  },
  "B": {
    "filename": "B.pbe-n-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 40,
    "ecutrho": 320,
    "pp_type": "PAW"
  },
  "C": {
    "filename": "C.pbe-n-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 40,
    "ecutrho": 320,
    "pp_type": "PAW"
  },
  "N": {
    "filename": "N.pbe-n-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 40,
    "ecutrho": 320,
    "pp_type": "PAW"
  },
  "O": {
    "filename": "O.pbe-n-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 45,
    "ecutrho": 360,
    "pp_type": "PAW"
  },
  "F": {
    "filename": "F.pbe-n-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 45,
    "ecutrho": 360,
    "pp_type": "PAW"
  },
  "Na": {
    "filename": "Na.pbe-spn-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 40,
    "ecutrho": 320,
    "pp_type": "PAW"
  },
  "Mg": {
    "filename": "Mg.pbe-spn-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 40,
    "ecutrho": 320,
    "pp_type": "PAW"
  },
  "Al": {
    "filename": "Al.pbe-n-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 30,
    "ecutrho": 240,
    "pp_type": "PAW"
  },
  "Si": {
    "filename": "Si.pbe-n-rrkjus_psl.1.0.0.UPF",
    "ecutwfc": 30,
    "ecutrho": 240,
    "pp_type": "US"
  },
  "P": {
    "filename": "P.pbe-n-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 30,
    "ecutrho": 240,
    "pp_type": "PAW"
  },
  "S": {
    "filename": "S.pbe-n-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 35,
    "ecutrho": 280,
    "pp_type": "PAW"
  },
  "Cl": {
    "filename": "Cl.pbe-n-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 40,
    "ecutrho": 320,
    "pp_type": "PAW"
  },
  "K": {
    "filename": "K.pbe-spn-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 40,
    "ecutrho": 320,
    "pp_type": "PAW"
  },
  "Ca": {
    "filename": "Ca.pbe-spn-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 40,
    "ecutrho": 320,
    "pp_type": "PAW"
  },
  "Ti": {
    "filename": "Ti.pbe-spn-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 40,
    "ecutrho": 320,
    "pp_type": "PAW"
  },
  "Fe": {
    "filename": "Fe.pbe-spn-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 45,
    "ecutrho": 360,
    "pp_type": "PAW"
  },
  "Co": {
    "filename": "Co.pbe-spn-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 45,
    "ecutrho": 360,
    "pp_type": "PAW"
  },
  "Ni": {
    "filename": "Ni.pbe-spn-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 45,
    "ecutrho": 360,
    "pp_type": "PAW"
  },
  "Cu": {
    "filename": "Cu.pbe-dn-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 45,
    "ecutrho": 360,
    "pp_type": "PAW"
  },
  "Zn": {
    "filename": "Zn.pbe-dn-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 45,
    "ecutrho": 360,
    "pp_type": "PAW"
  },
  "Ga": {
    "filename": "Ga.pbe-dn-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 40,
    "ecutrho": 320,
    "pp_type": "PAW"
  },
  "Ge": {
    "filename": "Ge.pbe-dn-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 40,
    "ecutrho": 320,
    "pp_type": "PAW"
  },
  "As": {
    "filename": "As.pbe-n-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 35,
    "ecutrho": 280,
    "pp_type": "PAW"
  },
  "Se": {
    "filename": "Se.pbe-dn-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 35,
    "ecutrho": 280,
    "pp_type": "PAW"
  },
  "Mo": {
    "filename": "Mo.pbe-spn-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 40,
    "ecutrho": 320,
    "pp_type": "PAW"
  },
  "Ag": {
    "filename": "Ag.pbe-n-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 45,
    "ecutrho": 360,
    "pp_type": "PAW"
  },
  "Au": {
    "filename": "Au.pbe-n-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 45,
    "ecutrho": 360,
    "pp_type": "PAW"
  },
  "Pb": {
    "filename": "Pb.pbe-dn-kjpaw_psl.1.0.0.UPF",
    "ecutwfc": 40,
    "ecutrho": 320,
    "pp_type": "PAW"
  }
}
```

- [ ] **Step 2: Create SSSP loader module**

Create `src/qe_beginner/sssp/__init__.py`:

```python
import json
from pathlib import Path

_SSSP_PATH = Path(__file__).parent / "sssp_efficiency.json"
_SSSP_DATA = None

PP_BASE_URL = "https://pseudopotentials.quantum-espresso.org/upf_files"


def load_sssp_data() -> dict:
    """Load SSSP Efficiency metadata. Cached after first call."""
    global _SSSP_DATA
    if _SSSP_DATA is None:
        with open(_SSSP_PATH) as f:
            _SSSP_DATA = json.load(f)
    return _SSSP_DATA


def get_pp_info(element: str) -> dict:
    """Get pseudopotential info for an element.

    Returns dict with keys: filename, ecutwfc, ecutrho, pp_type.
    Raises KeyError if element not in SSSP database.
    """
    data = load_sssp_data()
    if element not in data:
        raise KeyError(
            f"Element '{element}' not found in bundled SSSP database. "
            f"Available: {', '.join(sorted(data.keys()))}"
        )
    return data[element]
```

- [ ] **Step 3: Verify import works**

```bash
cd qe-beginner
python -c "from qe_beginner.sssp import get_pp_info; print(get_pp_info('Si'))"
```

Expected: `{'filename': 'Si.pbe-n-rrkjus_psl.1.0.0.UPF', 'ecutwfc': 30, 'ecutrho': 240, 'pp_type': 'US'}`

- [ ] **Step 4: Commit**

```bash
git add src/qe_beginner/sssp/
git commit -m "feat: add bundled SSSP Efficiency metadata for pseudopotential selection"
```

---

### Task 3: Environment Checker

**Files:**
- Create: `src/qe_beginner/environment.py`
- Create: `tests/test_environment.py`

- [ ] **Step 1: Write failing tests**

Create `tests/test_environment.py`:

```python
import json

from qe_beginner.environment import check_environment


def test_check_env_returns_json_with_required_keys():
    """check_environment() returns a dict with qe_found, qe_version, python_deps keys."""
    result = check_environment()
    assert isinstance(result, dict)
    assert "qe_found" in result
    assert "qe_version" in result
    assert "python_deps" in result
    assert isinstance(result["qe_found"], bool)
    assert isinstance(result["python_deps"], dict)


def test_check_env_detects_python_deps():
    """Python deps dict reports pymatgen and matplotlib status."""
    result = check_environment()
    deps = result["python_deps"]
    assert "pymatgen" in deps
    assert "matplotlib" in deps
    # Since we're running tests, these should be installed
    assert deps["pymatgen"] is True
    assert deps["matplotlib"] is True


def test_check_env_install_hint_when_qe_missing(monkeypatch):
    """When QE is not found, result includes install_hint."""
    # Make shutil.which always return None to simulate missing QE
    monkeypatch.setattr("shutil.which", lambda x: None)
    result = check_environment()
    assert result["qe_found"] is False
    assert "install_hint" in result
    assert "conda" in result["install_hint"]
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
pytest tests/test_environment.py -v
```

Expected: FAIL with `ModuleNotFoundError` or `ImportError` (module doesn't exist yet).

- [ ] **Step 3: Implement environment.py**

Create `src/qe_beginner/environment.py`:

```python
import importlib
import shutil
import subprocess


def check_environment(hpc: bool = False) -> dict:
    """Check if Quantum ESPRESSO and Python dependencies are available.

    Returns a JSON-serializable dict with:
        qe_found: bool
        qe_version: str or None
        python_deps: dict of {name: bool}
        install_hint: str (only if qe_found is False)
    """
    result = {
        "qe_found": False,
        "qe_version": None,
        "python_deps": {},
    }

    # Check for pw.x
    pw_path = shutil.which("pw.x")
    if pw_path:
        result["qe_found"] = True
        result["qe_version"] = _get_qe_version(pw_path)
    else:
        if hpc:
            result["install_hint"] = (
                "pw.x not found on PATH. On HPC, try: module avail qe\n"
                "or: module avail quantum-espresso"
            )
        else:
            result["install_hint"] = (
                "pw.x not found. Install via conda:\n"
                "  conda install -c conda-forge qe"
            )

    # Check Python deps
    for dep in ("pymatgen", "matplotlib"):
        try:
            importlib.import_module(dep)
            result["python_deps"][dep] = True
        except ImportError:
            result["python_deps"][dep] = False

    return result


def _get_qe_version(pw_path: str) -> str | None:
    """Extract QE version from pw.x --version output."""
    try:
        proc = subprocess.run(
            [pw_path, "--version"],
            capture_output=True,
            text=True,
            timeout=10,
        )
        # pw.x --version outputs something like "v.7.2"
        output = proc.stdout.strip() or proc.stderr.strip()
        return output if output else None
    except (subprocess.TimeoutExpired, OSError):
        return None
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
pytest tests/test_environment.py -v
```

Expected: 3 tests PASS.

- [ ] **Step 5: Commit**

```bash
git add src/qe_beginner/environment.py tests/test_environment.py
git commit -m "feat: add environment checker for QE and Python dependencies"
```

---

### Task 4: Structure Converter (CIF/POSCAR to QE Input)

**Files:**
- Create: `src/qe_beginner/convert.py`
- Create: `tests/test_convert.py`

This is the most critical module -- it must generate correct QE input files.

- [ ] **Step 1: Write failing tests**

Create `tests/test_convert.py`:

```python
from pathlib import Path

from qe_beginner.convert import convert_structure, ConvertResult


def test_convert_si_cif_produces_scf_in(si_cif_path, tmp_path):
    """Converting Si.cif produces a scf.in file in the output directory."""
    result = convert_structure(si_cif_path, output_dir=tmp_path)
    assert isinstance(result, ConvertResult)
    assert result.input_file.exists()
    assert result.input_file.name == "scf.in"


def test_convert_si_cif_correct_nat_ntyp(si_cif_path, tmp_path):
    """Silicon diamond has 2 atoms, 1 type."""
    result = convert_structure(si_cif_path, output_dir=tmp_path)
    content = result.input_file.read_text()
    assert "nat = 2" in content
    assert "ntyp = 1" in content


def test_convert_si_cif_correct_pseudopotential(si_cif_path, tmp_path):
    """Should select Si SSSP pseudopotential."""
    result = convert_structure(si_cif_path, output_dir=tmp_path)
    content = result.input_file.read_text()
    assert "Si.pbe-n-rrkjus_psl.1.0.0.UPF" in content


def test_convert_si_cif_correct_ecutwfc(si_cif_path, tmp_path):
    """SSSP recommends ecutwfc=30 for Si."""
    result = convert_structure(si_cif_path, output_dir=tmp_path)
    content = result.input_file.read_text()
    assert "ecutwfc = 30" in content
    assert "ecutrho = 240" in content


def test_convert_si_cif_has_cell_parameters(si_cif_path, tmp_path):
    """Output must have CELL_PARAMETERS block."""
    result = convert_structure(si_cif_path, output_dir=tmp_path)
    content = result.input_file.read_text()
    assert "CELL_PARAMETERS" in content


def test_convert_si_cif_has_atomic_positions(si_cif_path, tmp_path):
    """Output must have ATOMIC_POSITIONS block with 2 Si atoms."""
    result = convert_structure(si_cif_path, output_dir=tmp_path)
    content = result.input_file.read_text()
    assert "ATOMIC_POSITIONS" in content
    # Count Si lines in ATOMIC_POSITIONS section
    lines = content.split("\n")
    si_atom_lines = [l for l in lines if l.strip().startswith("Si ") and "." in l]
    assert len(si_atom_lines) == 2


def test_convert_result_summary(si_cif_path, tmp_path):
    """ConvertResult.summary contains key info for the agent to relay."""
    result = convert_structure(si_cif_path, output_dir=tmp_path)
    assert "Si" in result.summary
    assert "2" in result.summary  # nat
    assert "30" in result.summary  # ecutwfc


def test_convert_custom_ecutwfc(si_cif_path, tmp_path):
    """User can override ecutwfc."""
    result = convert_structure(si_cif_path, output_dir=tmp_path, ecutwfc=60)
    content = result.input_file.read_text()
    assert "ecutwfc = 60" in content
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
pytest tests/test_convert.py -v
```

Expected: FAIL with `ImportError`.

- [ ] **Step 3: Implement convert.py**

Create `src/qe_beginner/convert.py`:

```python
from dataclasses import dataclass, field
from pathlib import Path

import numpy as np
from pymatgen.core import Structure
from pymatgen.io.pwscf import PWInput
from pymatgen.symmetry.analyzer import SpacegroupAnalyzer

from qe_beginner.sssp import get_pp_info


@dataclass
class ConvertResult:
    input_file: Path
    summary: str
    pseudopotentials: dict = field(default_factory=dict)
    ecutwfc: float = 0.0
    ecutrho: float = 0.0
    kpoints_grid: tuple = (1, 1, 1)


def convert_structure(
    structure_file: Path | str,
    output_dir: Path | str = Path("."),
    ecutwfc: float | None = None,
    kpoints: tuple[int, int, int] | None = None,
) -> ConvertResult:
    """Convert a CIF or POSCAR file to a QE SCF input file.

    Args:
        structure_file: Path to CIF or POSCAR file.
        output_dir: Directory to write scf.in into.
        ecutwfc: Override wavefunction cutoff (Ry). If None, use SSSP recommendation.
        kpoints: Override k-point grid. If None, auto-generate from structure.

    Returns:
        ConvertResult with path to generated scf.in and a human-readable summary.
    """
    structure_file = Path(structure_file)
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    # Load structure
    structure = Structure.from_file(str(structure_file))

    # Get unique elements
    elements = sorted(set(str(s) for s in structure.species))

    # Look up pseudopotentials and cutoffs from SSSP
    pseudopotentials = {}
    max_ecutwfc = 0.0
    max_ecutrho = 0.0
    for el in elements:
        pp_info = get_pp_info(el)
        pseudopotentials[el] = pp_info["filename"]
        if pp_info["ecutwfc"] > max_ecutwfc:
            max_ecutwfc = pp_info["ecutwfc"]
            max_ecutrho = pp_info["ecutrho"]

    # Apply overrides
    final_ecutwfc = ecutwfc if ecutwfc is not None else max_ecutwfc
    final_ecutrho = ecutwfc * 8 if ecutwfc is not None else max_ecutrho

    # Determine k-point grid
    if kpoints is not None:
        kpoints_grid = kpoints
    else:
        kpoints_grid = _auto_kpoints(structure)

    # Build QE input content manually for full control
    content = _build_scf_input(
        structure=structure,
        pseudopotentials=pseudopotentials,
        ecutwfc=final_ecutwfc,
        ecutrho=final_ecutrho,
        kpoints_grid=kpoints_grid,
    )

    # Write scf.in
    input_file = output_dir / "scf.in"
    input_file.write_text(content)

    # Determine space group for summary
    try:
        sga = SpacegroupAnalyzer(structure)
        spacegroup = sga.get_space_group_symbol()
    except Exception:
        spacegroup = "unknown"

    # Build summary
    formula = structure.composition.reduced_formula
    nat = len(structure)
    ntyp = len(elements)
    lattice = structure.lattice
    summary = (
        f"Material: {formula} ({ntyp} type(s), {nat} atoms)\n"
        f"Space group: {spacegroup}\n"
        f"Lattice: a={lattice.a:.3f}, b={lattice.b:.3f}, c={lattice.c:.3f} Ang\n"
        f"Pseudopotentials: {', '.join(pseudopotentials.values())}\n"
        f"ecutwfc = {final_ecutwfc:.0f} Ry, ecutrho = {final_ecutrho:.0f} Ry\n"
        f"K-point grid: {kpoints_grid[0]}x{kpoints_grid[1]}x{kpoints_grid[2]}\n"
        f"Output: {input_file}"
    )

    return ConvertResult(
        input_file=input_file,
        summary=summary,
        pseudopotentials=pseudopotentials,
        ecutwfc=final_ecutwfc,
        ecutrho=final_ecutrho,
        kpoints_grid=kpoints_grid,
    )


def _auto_kpoints(structure: Structure) -> tuple[int, int, int]:
    """Generate k-point grid based on lattice parameters.

    Uses the rule: k_i = max(1, round(30 / a_i)) where a_i is in Angstrom.
    This gives roughly 30 k-points per reciprocal Angstrom.
    """
    lattice = structure.lattice
    k1 = max(1, round(30 / lattice.a))
    k2 = max(1, round(30 / lattice.b))
    k3 = max(1, round(30 / lattice.c))
    return (k1, k2, k3)


def _build_scf_input(
    structure: Structure,
    pseudopotentials: dict[str, str],
    ecutwfc: float,
    ecutrho: float,
    kpoints_grid: tuple[int, int, int],
) -> str:
    """Build a complete QE SCF input file as a string."""
    elements = sorted(set(str(s) for s in structure.species))
    nat = len(structure)
    ntyp = len(elements)

    lines = []

    # &CONTROL
    lines.append("&CONTROL")
    lines.append("  calculation = 'scf'")
    lines.append("  pseudo_dir = './'")
    lines.append("  outdir = './tmp'")
    lines.append("  tprnfor = .true.")
    lines.append("  tstress = .true.")
    lines.append("/")

    # &SYSTEM
    lines.append("&SYSTEM")
    lines.append("  ibrav = 0")
    lines.append(f"  nat = {nat}")
    lines.append(f"  ntyp = {ntyp}")
    lines.append(f"  ecutwfc = {ecutwfc:.1f}")
    lines.append(f"  ecutrho = {ecutrho:.1f}")
    lines.append("/")

    # &ELECTRONS
    lines.append("&ELECTRONS")
    lines.append("  conv_thr = 1.0d-6")
    lines.append("/")

    # ATOMIC_SPECIES
    lines.append("")
    lines.append("ATOMIC_SPECIES")
    for el in elements:
        # Atomic mass from pymatgen
        from pymatgen.core import Element
        mass = Element(el).atomic_mass
        lines.append(f"  {el}  {mass:.4f}  {pseudopotentials[el]}")

    # CELL_PARAMETERS (angstrom)
    lines.append("")
    lines.append("CELL_PARAMETERS {angstrom}")
    matrix = structure.lattice.matrix
    for i in range(3):
        lines.append(f"  {matrix[i][0]:.10f}  {matrix[i][1]:.10f}  {matrix[i][2]:.10f}")

    # ATOMIC_POSITIONS (crystal)
    lines.append("")
    lines.append("ATOMIC_POSITIONS {crystal}")
    for site in structure:
        el = str(site.specie)
        fc = site.frac_coords
        lines.append(f"  {el}  {fc[0]:.10f}  {fc[1]:.10f}  {fc[2]:.10f}")

    # K_POINTS
    lines.append("")
    lines.append("K_POINTS {automatic}")
    lines.append(f"  {kpoints_grid[0]} {kpoints_grid[1]} {kpoints_grid[2]}  0 0 0")
    lines.append("")

    return "\n".join(lines)
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
pytest tests/test_convert.py -v
```

Expected: all 8 tests PASS.

- [ ] **Step 5: Commit**

```bash
git add src/qe_beginner/convert.py tests/test_convert.py
git commit -m "feat: add CIF/POSCAR to QE SCF input converter with SSSP auto-selection"
```

---

### Task 5: Output Parser

**Files:**
- Create: `src/qe_beginner/parser.py`
- Create: `tests/test_parser.py`

- [ ] **Step 1: Write failing tests**

Create `tests/test_parser.py`:

```python
import json

from qe_beginner.parser import parse_scf_output, ParseResult


def test_parse_detects_convergence(scf_si_out_path):
    result = parse_scf_output(scf_si_out_path)
    assert isinstance(result, ParseResult)
    assert result.converged is True


def test_parse_iteration_count(scf_si_out_path):
    result = parse_scf_output(scf_si_out_path)
    assert result.n_iterations == 5


def test_parse_total_energy(scf_si_out_path):
    result = parse_scf_output(scf_si_out_path)
    assert abs(result.total_energy_ry - (-15.85661832)) < 1e-6


def test_parse_fermi_energy(scf_si_out_path):
    result = parse_scf_output(scf_si_out_path)
    assert abs(result.fermi_energy_ev - 6.3539) < 1e-3


def test_parse_forces(scf_si_out_path):
    result = parse_scf_output(scf_si_out_path)
    assert len(result.forces) == 2
    # All forces are zero for perfect silicon
    for force in result.forces:
        assert abs(force[0]) < 1e-10
        assert abs(force[1]) < 1e-10
        assert abs(force[2]) < 1e-10


def test_parse_total_force(scf_si_out_path):
    result = parse_scf_output(scf_si_out_path)
    assert abs(result.total_force) < 1e-6


def test_parse_pressure(scf_si_out_path):
    result = parse_scf_output(scf_si_out_path)
    assert abs(result.pressure_kbar - 0.12) < 0.01


def test_parse_wall_time(scf_si_out_path):
    result = parse_scf_output(scf_si_out_path)
    assert result.wall_time == "0.52s"


def test_parse_summary_is_readable(scf_si_out_path):
    result = parse_scf_output(scf_si_out_path)
    summary = result.summary
    assert "Converged" in summary or "converged" in summary
    assert "5" in summary  # iterations
    assert "-15.85" in summary  # energy


def test_parse_warnings_empty_for_good_run(scf_si_out_path):
    result = parse_scf_output(scf_si_out_path)
    assert result.warnings == []


def test_parse_to_json(scf_si_out_path):
    result = parse_scf_output(scf_si_out_path)
    j = result.to_json()
    data = json.loads(j)
    assert data["converged"] is True
    assert "total_energy_ry" in data
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
pytest tests/test_parser.py -v
```

Expected: FAIL with `ImportError`.

- [ ] **Step 3: Implement parser.py**

Create `src/qe_beginner/parser.py`:

```python
import json
import re
from dataclasses import dataclass, field
from pathlib import Path


@dataclass
class ParseResult:
    converged: bool = False
    n_iterations: int = 0
    total_energy_ry: float = 0.0
    fermi_energy_ev: float | None = None
    forces: list[tuple[float, float, float]] = field(default_factory=list)
    total_force: float = 0.0
    pressure_kbar: float = 0.0
    wall_time: str = ""
    warnings: list[str] = field(default_factory=list)
    summary: str = ""

    def to_json(self) -> str:
        return json.dumps(
            {
                "converged": self.converged,
                "n_iterations": self.n_iterations,
                "total_energy_ry": self.total_energy_ry,
                "total_energy_ev": self.total_energy_ry * 13.605698,
                "fermi_energy_ev": self.fermi_energy_ev,
                "forces": self.forces,
                "total_force": self.total_force,
                "pressure_kbar": self.pressure_kbar,
                "wall_time": self.wall_time,
                "warnings": self.warnings,
                "summary": self.summary,
            },
            indent=2,
        )


def parse_scf_output(output_file: Path | str) -> ParseResult:
    """Parse a QE pw.x SCF output file into structured results.

    Args:
        output_file: Path to scf.out file.

    Returns:
        ParseResult with all extracted quantities and a plain-English summary.
    """
    text = Path(output_file).read_text()
    result = ParseResult()

    # Convergence
    if "convergence has been achieved" in text:
        result.converged = True
        match = re.search(r"convergence has been achieved in\s+(\d+)\s+iterations", text)
        if match:
            result.n_iterations = int(match.group(1))
    else:
        result.converged = False
        result.warnings.append("SCF did not converge")

    # Total energy (look for the final "!" line)
    match = re.search(r"!\s+total energy\s+=\s+([-\d.]+)\s+Ry", text)
    if match:
        result.total_energy_ry = float(match.group(1))

    # Fermi energy
    match = re.search(r"the Fermi energy is\s+([-\d.]+)\s+ev", text, re.IGNORECASE)
    if match:
        result.fermi_energy_ev = float(match.group(1))

    # Forces per atom
    force_pattern = re.compile(
        r"atom\s+\d+\s+type\s+\d+\s+force\s+=\s+([-\d.]+)\s+([-\d.]+)\s+([-\d.]+)"
    )
    for m in force_pattern.finditer(text):
        result.forces.append((float(m.group(1)), float(m.group(2)), float(m.group(3))))

    # Total force
    match = re.search(r"Total force\s+=\s+([-\d.]+)", text)
    if match:
        result.total_force = float(match.group(1))

    # Pressure
    match = re.search(r"P=\s+([-\d.]+)", text)
    if match:
        result.pressure_kbar = float(match.group(1))

    # Wall time
    match = re.search(r"PWSCF\s+:\s+[\d.]+s CPU\s+([\d.]+s)\s+WALL", text)
    if match:
        result.wall_time = match.group(1)

    # Warnings for unusual results
    if result.total_force > 0.05:
        result.warnings.append(
            f"Large forces detected (total force = {result.total_force:.4f} Ry/Bohr). "
            "The structure may not be at equilibrium."
        )
    if result.pressure_kbar < -10 or result.pressure_kbar > 10:
        result.warnings.append(
            f"Significant pressure ({result.pressure_kbar:.1f} kbar). "
            "The unit cell may need optimization."
        )

    # Build summary
    energy_ev = result.total_energy_ry * 13.605698
    summary_parts = []
    if result.converged:
        summary_parts.append(f"Converged in {result.n_iterations} iterations.")
    else:
        summary_parts.append("WARNING: SCF did NOT converge.")
    summary_parts.append(
        f"Total energy: {result.total_energy_ry:.8f} Ry ({energy_ev:.4f} eV)"
    )
    if result.fermi_energy_ev is not None:
        summary_parts.append(f"Fermi energy: {result.fermi_energy_ev:.4f} eV")
    summary_parts.append(f"Total force: {result.total_force:.6f} Ry/Bohr")
    summary_parts.append(f"Pressure: {result.pressure_kbar:.2f} kbar")
    if result.wall_time:
        summary_parts.append(f"Wall time: {result.wall_time}")
    if result.warnings:
        summary_parts.append("Warnings: " + "; ".join(result.warnings))

    result.summary = "\n".join(summary_parts)
    return result
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
pytest tests/test_parser.py -v
```

Expected: all 11 tests PASS.

- [ ] **Step 5: Commit**

```bash
git add src/qe_beginner/parser.py tests/test_parser.py
git commit -m "feat: add QE SCF output parser with structured results and summary"
```

---

### Task 6: Visualizer

**Files:**
- Create: `src/qe_beginner/visualize.py`
- Create: `tests/test_visualize.py`

- [ ] **Step 1: Write failing smoke test**

Create `tests/test_visualize.py`:

```python
from pathlib import Path

from qe_beginner.visualize import visualize_structure


def test_visualize_cif_produces_png(si_cif_path, tmp_path):
    """Visualizing a CIF file produces a PNG."""
    output_png = tmp_path / "structure.png"
    result_path = visualize_structure(si_cif_path, output_path=output_png)
    assert result_path.exists()
    assert result_path.suffix == ".png"
    assert result_path.stat().st_size > 0


def test_visualize_with_scf_results(si_cif_path, scf_si_out_path, tmp_path):
    """Visualizing with SCF results annotates the image."""
    output_png = tmp_path / "structure_annotated.png"
    result_path = visualize_structure(
        si_cif_path, output_path=output_png, scf_output=scf_si_out_path
    )
    assert result_path.exists()
    assert result_path.stat().st_size > 0
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
pytest tests/test_visualize.py -v
```

Expected: FAIL with `ImportError`.

- [ ] **Step 3: Implement visualize.py**

Create `src/qe_beginner/visualize.py`:

```python
from pathlib import Path

import matplotlib
matplotlib.use("Agg")  # Non-interactive backend
import matplotlib.pyplot as plt
import numpy as np
from pymatgen.core import Structure

from qe_beginner.parser import parse_scf_output

# Element colors (CPK-ish)
ELEMENT_COLORS = {
    "H": "#FFFFFF", "He": "#D9FFFF", "Li": "#CC80FF", "Be": "#C2FF00",
    "B": "#FFB5B5", "C": "#909090", "N": "#3050F8", "O": "#FF0D0D",
    "F": "#90E050", "Na": "#AB5CF2", "Mg": "#8AFF00", "Al": "#BFA6A6",
    "Si": "#F0C8A0", "P": "#FF8000", "S": "#FFFF30", "Cl": "#1FF01F",
    "K": "#8F40D4", "Ca": "#3DFF00", "Ti": "#BFC2C7", "Fe": "#E06633",
    "Co": "#F090A0", "Ni": "#50D050", "Cu": "#C88033", "Zn": "#7D80B0",
    "Ga": "#C28F8F", "Ge": "#668F8F", "As": "#BD80E3", "Se": "#FFA100",
    "Mo": "#54B5B5", "Ag": "#C0C0C0", "Au": "#FFD123", "Pb": "#575961",
}
DEFAULT_COLOR = "#FF69B4"


def visualize_structure(
    structure_file: Path | str,
    output_path: Path | str = Path("structure.png"),
    scf_output: Path | str | None = None,
) -> Path:
    """Render a crystal structure as a ball-and-stick PNG.

    Args:
        structure_file: Path to CIF or POSCAR.
        output_path: Where to save the PNG.
        scf_output: Optional path to scf.out to annotate with results.

    Returns:
        Path to the saved PNG.
    """
    output_path = Path(output_path)
    structure = Structure.from_file(str(structure_file))

    fig = plt.figure(figsize=(8, 8))
    ax = fig.add_subplot(111, projection="3d")

    # Draw unit cell edges
    _draw_unit_cell(ax, structure.lattice.matrix)

    # Draw atoms
    for site in structure:
        coords = site.coords
        el = str(site.specie)
        color = ELEMENT_COLORS.get(el, DEFAULT_COLOR)
        ax.scatter(*coords, s=200, c=color, edgecolors="black", linewidth=0.5, zorder=5)
        ax.text(coords[0], coords[1], coords[2] + 0.3, el, fontsize=9, ha="center")

    # Axis labels
    ax.set_xlabel("x (Ang)")
    ax.set_ylabel("y (Ang)")
    ax.set_zlabel("z (Ang)")

    formula = structure.composition.reduced_formula
    title = f"{formula} unit cell"

    # Add SCF annotation if provided
    if scf_output is not None:
        parsed = parse_scf_output(scf_output)
        energy_ev = parsed.total_energy_ry * 13.605698
        annotation = (
            f"E = {parsed.total_energy_ry:.6f} Ry ({energy_ev:.2f} eV)\n"
            f"{'Converged' if parsed.converged else 'NOT converged'} "
            f"in {parsed.n_iterations} iter"
        )
        title += f"\n{annotation}"

    ax.set_title(title, fontsize=11)
    plt.tight_layout()
    fig.savefig(output_path, dpi=150, bbox_inches="tight")
    plt.close(fig)

    return output_path


def _draw_unit_cell(ax, matrix: np.ndarray):
    """Draw the 12 edges of a parallelepiped unit cell."""
    a, b, c = matrix[0], matrix[1], matrix[2]
    origin = np.array([0.0, 0.0, 0.0])

    # 8 corners
    corners = [
        origin, a, b, c,
        a + b, a + c, b + c,
        a + b + c,
    ]

    # 12 edges as pairs of corner indices
    edges = [
        (0, 1), (0, 2), (0, 3),
        (1, 4), (1, 5),
        (2, 4), (2, 6),
        (3, 5), (3, 6),
        (4, 7), (5, 7), (6, 7),
    ]

    for i, j in edges:
        pts = np.array([corners[i], corners[j]])
        ax.plot3D(*pts.T, color="gray", linewidth=0.8, alpha=0.6)
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
pytest tests/test_visualize.py -v
```

Expected: 2 tests PASS.

- [ ] **Step 5: Commit**

```bash
git add src/qe_beginner/visualize.py tests/test_visualize.py
git commit -m "feat: add crystal structure 3D visualization with matplotlib"
```

---

### Task 7: Runner (Local + SSH Execution)

**Files:**
- Create: `src/qe_beginner/runner.py`

No tests per spec (requires QE installed).

- [ ] **Step 1: Implement runner.py**

Create `src/qe_beginner/runner.py`:

```python
import shutil
import subprocess
import sys
from pathlib import Path


def run_scf(
    input_file: Path | str = Path("scf.in"),
    np: int = 1,
    ssh: str | None = None,
    remote_dir: str | None = None,
) -> Path:
    """Run pw.x SCF calculation locally or via SSH.

    Args:
        input_file: Path to scf.in.
        np: Number of MPI processes (local mode).
        ssh: SSH target (e.g., "user@host"). If None, run locally.
        remote_dir: Remote working directory for SSH mode.

    Returns:
        Path to scf.out.
    """
    input_file = Path(input_file)
    if not input_file.exists():
        raise FileNotFoundError(f"Input file not found: {input_file}")

    if ssh is not None:
        return _run_remote(input_file, ssh, remote_dir or "~/qe-beginner-run")
    else:
        return _run_local(input_file, np)


def _run_local(input_file: Path, np: int) -> Path:
    """Run pw.x locally."""
    work_dir = input_file.parent
    output_file = work_dir / "scf.out"

    # Build command
    pw_path = shutil.which("pw.x")
    if not pw_path:
        raise RuntimeError(
            "pw.x not found on PATH. Install QE first:\n"
            "  conda install -c conda-forge qe"
        )

    if np > 1:
        mpirun = shutil.which("mpirun") or shutil.which("mpiexec")
        if not mpirun:
            print("Warning: mpirun not found, running with single process", file=sys.stderr)
            cmd = [pw_path, "-in", str(input_file)]
        else:
            cmd = [mpirun, "-np", str(np), pw_path, "-in", str(input_file)]
    else:
        cmd = [pw_path, "-in", str(input_file)]

    print(f"Running: {' '.join(cmd)}")
    print(f"Working directory: {work_dir}")

    with open(output_file, "w") as outf:
        proc = subprocess.Popen(
            cmd,
            cwd=str(work_dir),
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
        )
        for line in proc.stdout:
            outf.write(line)
            # Stream SCF iteration progress
            if "Energy is" in line or "estimated scf accuracy" in line:
                print(line.rstrip())
            elif "convergence has been achieved" in line:
                print(line.rstrip())
            elif "JOB DONE" in line:
                print(line.rstrip())
        proc.wait()

    if proc.returncode != 0:
        raise RuntimeError(
            f"pw.x exited with code {proc.returncode}. Check {output_file} for details."
        )

    print(f"Output written to: {output_file}")
    return output_file


def _run_remote(input_file: Path, ssh_target: str, remote_dir: str) -> Path:
    """Run pw.x on a remote host via SSH."""
    work_dir = input_file.parent
    output_file = work_dir / "scf.out"

    # Collect files to copy: scf.in + any .UPF files in the same directory
    files_to_copy = [input_file]
    for f in work_dir.glob("*.UPF"):
        files_to_copy.append(f)

    # Create remote directory
    print(f"Setting up remote directory: {ssh_target}:{remote_dir}")
    subprocess.run(
        ["ssh", ssh_target, f"mkdir -p {remote_dir}"],
        check=True,
    )

    # Copy files
    for f in files_to_copy:
        print(f"Copying {f.name} to remote...")
        subprocess.run(
            ["scp", str(f), f"{ssh_target}:{remote_dir}/"],
            check=True,
        )

    # Run pw.x remotely
    remote_cmd = f"cd {remote_dir} && pw.x -in scf.in > scf.out 2>&1"
    print(f"Running pw.x on {ssh_target}...")
    subprocess.run(
        ["ssh", ssh_target, remote_cmd],
        check=True,
    )

    # Copy output back
    print("Copying results back...")
    subprocess.run(
        ["scp", f"{ssh_target}:{remote_dir}/scf.out", str(output_file)],
        check=True,
    )

    print(f"Output written to: {output_file}")
    return output_file
```

- [ ] **Step 2: Commit**

```bash
git add src/qe_beginner/runner.py
git commit -m "feat: add local and SSH runner for pw.x SCF calculations"
```

---

### Task 8: CLI Entry Point

**Files:**
- Create: `src/qe_beginner/cli.py`

- [ ] **Step 1: Implement cli.py wiring all subcommands**

Create `src/qe_beginner/cli.py`:

```python
import json
import sys

import click

from qe_beginner import __version__


@click.group()
@click.version_option(version=__version__)
def main():
    """QE Beginner: guided Quantum ESPRESSO for newcomers."""
    pass


@main.command("check-env")
@click.option("--hpc", is_flag=True, help="HPC mode: only check, don't offer to install")
def check_env(hpc):
    """Check if Quantum ESPRESSO and Python dependencies are available."""
    from qe_beginner.environment import check_environment

    result = check_environment(hpc=hpc)
    click.echo(json.dumps(result, indent=2))

    if not result["qe_found"]:
        click.echo(f"\n{result['install_hint']}", err=True)
        sys.exit(1)

    missing_deps = [k for k, v in result["python_deps"].items() if not v]
    if missing_deps:
        click.echo(
            f"\nMissing Python packages: {', '.join(missing_deps)}\n"
            f"Install with: pip install {' '.join(missing_deps)}",
            err=True,
        )
        sys.exit(1)

    click.echo("\nEnvironment is ready.", err=True)


@main.command()
@click.argument("structure_file", type=click.Path(exists=True))
@click.option("--ecutwfc", type=float, default=None, help="Override wavefunction cutoff (Ry)")
@click.option(
    "--kpoints",
    nargs=3,
    type=int,
    default=None,
    help="Override k-point grid (e.g., --kpoints 8 8 8)",
)
@click.option(
    "--output-dir",
    type=click.Path(),
    default=".",
    help="Directory to write scf.in into",
)
def convert(structure_file, ecutwfc, kpoints, output_dir):
    """Convert a CIF or POSCAR file to QE SCF input."""
    from pathlib import Path
    from qe_beginner.convert import convert_structure

    result = convert_structure(
        structure_file,
        output_dir=Path(output_dir),
        ecutwfc=ecutwfc,
        kpoints=tuple(kpoints) if kpoints else None,
    )
    click.echo(result.summary)


@main.command()
@click.option("--np", "num_procs", type=int, default=1, help="Number of MPI processes")
@click.option("--ssh", type=str, default=None, help="SSH target (e.g., user@host)")
@click.option("--remote-dir", type=str, default=None, help="Remote working directory")
@click.option(
    "--input-file",
    type=click.Path(exists=True),
    default="scf.in",
    help="Path to scf.in",
)
def run(num_procs, ssh, remote_dir, input_file):
    """Run pw.x SCF calculation (local or via SSH)."""
    from pathlib import Path
    from qe_beginner.runner import run_scf

    output = run_scf(
        input_file=Path(input_file),
        np=num_procs,
        ssh=ssh,
        remote_dir=remote_dir,
    )
    click.echo(f"Done. Output: {output}")


@main.command()
@click.argument("output_file", type=click.Path(exists=True))
@click.option("--json-output", is_flag=True, help="Output raw JSON instead of summary")
def parse(output_file, json_output):
    """Parse QE SCF output and show results."""
    from qe_beginner.parser import parse_scf_output

    result = parse_scf_output(output_file)
    if json_output:
        click.echo(result.to_json())
    else:
        click.echo(result.summary)


@main.command()
@click.argument("structure_file", type=click.Path(exists=True))
@click.option("--scf-output", type=click.Path(exists=True), default=None, help="Annotate with SCF results")
@click.option("--output", "-o", type=click.Path(), default="structure.png", help="Output PNG path")
def visualize(structure_file, scf_output, output):
    """Render crystal structure as a PNG image."""
    from pathlib import Path
    from qe_beginner.visualize import visualize_structure

    result_path = visualize_structure(
        structure_file,
        output_path=Path(output),
        scf_output=scf_output,
    )
    click.echo(f"Saved: {result_path}")
```

- [ ] **Step 2: Verify CLI wiring works**

```bash
cd qe-beginner
pip install -e ".[dev]"
qe-beginner --version
qe-beginner --help
qe-beginner convert --help
```

Expected: version prints `0.1.0`, help shows all 5 subcommands.

- [ ] **Step 3: Smoke-test convert subcommand**

```bash
cd qe-beginner
qe-beginner convert tests/fixtures/Si.cif --output-dir /tmp/qe-test
cat /tmp/qe-test/scf.in
```

Expected: prints summary, scf.in file is correct.

- [ ] **Step 4: Smoke-test parse subcommand**

```bash
qe-beginner parse tests/fixtures/scf_si.out
qe-beginner parse tests/fixtures/scf_si.out --json-output
```

Expected: human-readable summary, then JSON output.

- [ ] **Step 5: Commit**

```bash
git add src/qe_beginner/cli.py
git commit -m "feat: add click CLI entry point wiring all subcommands"
```

---

### Task 9: SKILL.md

**Files:**
- Create: `.claude/skills/qe-beginner/SKILL.md`

- [ ] **Step 1: Write the SKILL.md**

Create `.claude/skills/qe-beginner/SKILL.md`:

````markdown
---
name: qe-beginner
description: Guide a complete beginner through their first Quantum ESPRESSO SCF calculation, from CIF file to interpreted results with visualization
---

# QE Beginner: Your First DFT Calculation

You are a patient mentor guiding a researcher who has **never used Quantum ESPRESSO or DFT** through their first SCF (self-consistent field) calculation. You use the `qe-beginner` CLI tool for all technical operations -- never write QE input files manually.

## Prerequisites

The user must have `qe-beginner` installed:
```
pip install qe-beginner
```

## Workflow

Follow these phases in order. At each phase, explain what you're doing and why in simple terms.

### Phase 1: Check Environment

Run the environment check:
```bash
qe-beginner check-env
```

**If QE is not found (exit code 1):**
- Read the JSON output and the install hint
- For local machines, offer to run: `conda install -c conda-forge qe`
- For HPC (if user mentions cluster/SSH), suggest: `module avail qe` or `module avail quantum-espresso`
- Re-run `qe-beginner check-env` after installation to confirm

**If Python deps are missing:**
- Offer to run: `pip install pymatgen matplotlib`

**Once all green**, tell the user:
> "Your environment is ready! QE [version] is installed and all dependencies are available."

### Phase 2: Accept Structure File

Ask the user:
> "Do you have a CIF or POSCAR file for the material you want to simulate? These are standard crystal structure formats -- you can download them from databases like the Materials Project (materialsproject.org) or the Crystallography Open Database (crystallography.net)."

Once the user provides a file path, convert it:
```bash
qe-beginner convert <path-to-file> --output-dir ./qe-run
```

**Read the output summary and present it to the user in plain English:**
- What material was detected (formula, number of atoms)
- Crystal system and space group
- What pseudopotentials were selected and why ("These describe how core electrons interact with valence electrons -- think of them as pre-computed approximations that make the calculation feasible")
- Energy cutoff ("This controls the precision of the calculation -- higher means more accurate but slower")
- K-point grid ("These are sampling points in reciprocal space -- think of it as how finely we sample the electronic structure")

Ask: "Does this look right? Want me to explain any of these parameters, or shall we proceed to run the calculation?"

### Phase 3: Run the Calculation

Explain briefly:
> "We're about to run an SCF calculation. This iteratively solves quantum mechanical equations to find the ground-state electron density of your material. Each iteration gets closer to the true answer."

Ask: "Should I run this on your local machine, or on a remote cluster via SSH?"

**Local:**
```bash
qe-beginner run --input-file ./qe-run/scf.in --np <cores>
```
Ask how many CPU cores to use (default 1). For small systems like Si, 1 is fine.

**SSH:**
```bash
qe-beginner run --input-file ./qe-run/scf.in --ssh <user@host> --remote-dir <path>
```
Ask for SSH address and remote directory.

**While running:** relay any progress output (iteration energies, convergence messages) to the user.

**On completion:** tell the user the calculation finished and how long it took.

### Phase 4: Parse and Explain Results

Parse the output:
```bash
qe-beginner parse ./qe-run/scf.out
```

**Present the results with explanations:**

- **Convergence**: "The calculation converged in N iterations -- this means it successfully found a self-consistent solution."
- **Total energy**: "The total energy is X Ry (Y eV). This number by itself isn't very meaningful, but it becomes useful when you compare it across different structures or lattice constants."
- **Fermi energy**: "The Fermi energy is Z eV -- this is the highest occupied energy level at zero temperature."
- **Forces**: "The forces on each atom are [values]. Small forces (< 0.001 Ry/Bohr) mean the atoms are at their equilibrium positions."
- **Pressure**: "The pressure is P kbar. Small pressure means the unit cell volume is close to equilibrium."

**If there are warnings**, explain them clearly and suggest fixes.

### Phase 5: Visualize

Generate a structure visualization:
```bash
qe-beginner visualize <original-cif-file> --scf-output ./qe-run/scf.out -o ./qe-run/structure.png
```

Show the PNG to the user and explain what they're seeing.

### Phase 6: Suggest Next Steps

> "Congratulations on your first DFT calculation! Here are natural next steps:
> 1. **Convergence test**: Increase ecutwfc (e.g., 40, 50, 60 Ry) and re-run to check if the energy changes. When it stops changing, you've found a reliable cutoff.
> 2. **Lattice optimization**: Try different lattice constants to find the DFT equilibrium -- plot energy vs. lattice constant.
> 3. **Different material**: Bring another CIF file and repeat the process.
>
> Want to try any of these?"

## Error Handling

- **"SCF did NOT converge"**: "The calculation didn't converge. Let me try increasing the energy cutoff or k-point density." Re-run convert with `--ecutwfc <higher>` or `--kpoints <denser>`.
- **"pw.x not found"**: Go back to Phase 1 environment check.
- **"Element not found in SSSP database"**: "This element isn't in our default pseudopotential set. You may need to find a suitable pseudopotential file manually."
- **SSH connection failed**: "I couldn't connect. Please check your SSH credentials and that the host is reachable."
- **QE crash/segfault**: "QE crashed -- this often means the system is too large for available memory, or there's a problem with the pseudopotential. Try using fewer k-points or more CPU cores."

## Key Principles

- **Never write QE input files yourself** -- always use `qe-beginner convert`
- **Explain every step** in terms a non-expert can understand
- **Be patient** -- the user may ask "what is a pseudopotential?" and that's fine
- **Flag warnings proactively** -- don't let the user proceed with bad results
- **One phase at a time** -- don't skip ahead
````

- [ ] **Step 2: Commit**

```bash
git add .claude/skills/qe-beginner/SKILL.md
git commit -m "feat: add qe-beginner Claude Code skill for guided SCF calculations"
```

---

### Task 10: Final Integration Test

- [ ] **Step 1: Run full test suite**

```bash
cd qe-beginner
pytest -v
```

Expected: all tests pass (test_environment: 3, test_convert: 8, test_parser: 11, test_visualize: 2 = 24 tests total).

- [ ] **Step 2: Verify CLI end-to-end**

```bash
qe-beginner check-env
qe-beginner convert tests/fixtures/Si.cif --output-dir /tmp/qe-final
qe-beginner parse tests/fixtures/scf_si.out
qe-beginner visualize tests/fixtures/Si.cif --scf-output tests/fixtures/scf_si.out -o /tmp/qe-final/si.png
ls -la /tmp/qe-final/
```

Expected: scf.in generated, parse output shown, PNG created.

- [ ] **Step 3: Commit any final fixes**

```bash
git add -A
git commit -m "chore: final integration verification"
```
