# AGENTS.md

This file provides guidance to coding agents working on TinyML playground.

## Mission

TinyML playground is an experimental environment for Tiny Machine Learning (TinyML) and embedded AI workflows.
It provides code, notebooks, and tools for model training, quantization, microcontroller deployment, and hardware integration.

Priorities, in order:

1. Reproducible embedded ML workflows: models train, quantize, and deploy consistently across constrained hardware.
2. Hardware safety and reliability: flashing procedures, serial interactions, and device connections clean up safely.
3. Accessible experimentation: clear notebooks, modular Python code, and automated tests.
4. Small, clear changes: code edits fit the existing Python environment and repository structure.

## Core Rules

- Read affected code and nearby tests before editing. Prefer focused changes, existing helpers, and standard library features.
- Use English for code, comments, documentation, and tests.
- Support Python 3.14 or newer. Development uses Python 3.14, as specified in `.python-version`. Add type annotations to functions and follow code
  quality settings.
- Use uv and `uv.lock` for Python dependencies. Run `uv add PACKAGE` or `uv add --dev PACKAGE`, and update both `pyproject.toml` and `uv.lock` when
  changing dependencies. Use `uv run` for development commands.
- Keep notebooks clean and stripped of large binary outputs or sensitive data before committing.
- Keep comments focused on behavior that the code does not make clear.
- TinyML playground source is MIT-licensed. Dependencies, firmware tools, and model weights retain their own licenses. Keep license disclosures
  accurate, and do not commit proprietary firmware binaries or secret keys.

## Writing Style

- Write in simple, plain English. Use short sentences and everyday words.
- Use Oxford commas in inline lists: "a, b, and c" not "a, b, c".
- Do not use em dashes. Restructure the sentence, or use a colon or semicolon instead.
- Avoid colorful adjectives and adverbs. Write "adjacency query" not "blazing adjacency query".
- Prefer noun phrases for checklist items over imperative verbs. Write "temp directory teardown" not "tear down the temp directory".
- Headings in Markdown files must be in title case: "Build from Source" not "Build from source". Minor words stay lowercase unless they are the first
  word: the articles (a, an, the), the coordinating conjunctions (and, but, or, nor, so, yet, for), and the short prepositions (in, on, at, to, by,
  of, up, as, from, with, into, over).
- Do not bold the lead-in of a list item. Write "Vector and set similarity: ..." not "**Vector and set similarity**: ...".
- Use sentence case for the lead-in of a list item. Write "Seed selection: ..." not "Seed Selection: ...". Proper nouns keep their capitals.
- Capitalize only the first part of a hyphenated compound: "Full-text Search" in a heading, "Breadth-first" at the start of a sentence, and
  "breadth-first search" elsewhere. Never write "Breadth-First".
- Start each sentence with a capital letter, capitalize proper nouns (Rust, Cypher, LMDB), and leave common nouns lowercase in the middle of a
  sentence.
- Write correct and complete sentences. Avoid made-up words.
- Do not use a colon in place of a verb. A colon may join two clauses inside a complete sentence, introduce the gloss of a list item, or introduce an
  enumeration. It must not turn a sentence into a label and a definition: write "Merges vector search seeds with text search seeds, then expands via
  BFS" rather than "Hybrid retrieval: merges vector search seeds with text search seeds".
- Use participial phrases and abbreviations sparingly.

## Repository Layout

- `notebooks/` contains Jupyter notebooks for model training, quantization, and evaluation experiments.
- `tests/` contains automated unit tests and test suites.
- `pyproject.toml` defines project metadata, dependencies, and package configuration.
- `uv.lock` pins the Python dependency tree.
- `Makefile` provides development commands for installation, formatting, linting, testing, and hook management.
- `.pre-commit-config.yaml` defines Git hooks for formatting and quality checks before commits and pushes.
- `.github/workflows/tests.yml` runs automated tests across supported Python versions on continuous integration.
- `flake.nix` provides optional Nix development environments with system tools. Python dependencies remain managed by uv.
- `README.md` documents project overview, features, and relevant research papers.
- `CONTRIBUTING.md` describes contribution guidelines and the development workflow.

## Behavior to Preserve

- Keep generated model checkpoints, compiled binaries, and firmware images out of version control.
- Hardware operations must use safe flashing offsets and verified partition tables. Close serial connections and release device ports promptly after
  flashing or monitoring.
- Keep dependencies synchronized across `pyproject.toml` and `uv.lock`. Run dependency updates through uv.
- Support Python 3.14 or newer across shared utilities and test suites.
- Preserve Git hygiene by excluding `.venv/`, `.pytest_cache/`, `.ruff_cache/`, build artifacts, and local secrets.

## Development Workflow

Use the existing Make targets:

```bash
make install       # Install Python dependencies.
make test          # Run tests.
make format        # Format code with Ruff.
make setup-hooks   # Install Git hooks for pre-commit and pre-push.
make test-hooks    # Run Git hooks on all files.
make clean         # Remove caches and build artifacts.
```

For Nix development, run `nix develop`, then `make install`.
Entering the shell must not install Python dependencies or start background processes.
Format Nix changes with `nix fmt`, and check flake changes with `nix flake check --no-build --no-write-lock-file`.

Run checks relevant to the change. For application code changes, run formatting, linting, type checking, and the relevant tests before declaring the
work done.
Update `README.md` when behavior or setup changes. Report any checks that could not run.

## Testing Expectations

- Keep unit tests deterministic and independent of physical microcontroller hardware, connected serial devices, and network access. Use test doubles
  or mocks for hardware interfaces.
- Use temporary directories for tests that create or modify file artifacts, firmware images, or model weights.
- Cover validation, partition parsing, image signing, and device communication protocols when modifying those behaviors.
- Keep `.venv/`, `.pytest_cache/`, `.ruff_cache/`, `.mypy_cache/`, coverage files, Jupyter checkpoints, and build artifacts out of commits and package
  distributions.
