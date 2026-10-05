# Variables
PYTHON      ?= python3
PIP         ?= pip3
DEP_MNGR    ?= uv
DOCS_DIR   ?= docs

# Directories and files to clean
CACHE_DIRS  = .mypy_cache .pytest_cache .ruff_cache
COVERAGE    = .coverage htmlcov coverage.xml
DIST_DIRS   = dist junit
TMP_DIRS   = site

.DEFAULT_GOAL := help

.PHONY: help
help: ## Show help messages for all available targets
	@grep -E '^[a-zA-Z_-]+:.*## .*$$' Makefile | \
	awk 'BEGIN {FS = ":.*## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Setup and Installation
.PHONY: setup
setup: ## Install system dependencies and dependency manager
	sudo apt-get update
	sudo apt-get install -y python3-pip
	$(PIP) install --upgrade pip
	$(PIP) install $(DEP_MNGR)

.PHONY: install
install: ## Install Python dependencies
	$(DEP_MNGR) sync --all-groups --all-extras

# Quality and Testing
.PHONY: test
test: ## Run tests with pytest and xdist
	$(DEP_MNGR) run pytest -n auto

.PHONY: test-unit
test-unit: ## Run unit tests
	$(DEP_MNGR) run pytest -m unit

.PHONY: test-hardware
test-hardware: ## Run hardware tests
	$(DEP_MNGR) run pytest -m hardware

.PHONY: test-quantization
test-quantization: ## Run quantization tests
	$(DEP_MNGR) run pytest -m quantization

.PHONY: format
format: ## Format code with Ruff
	$(DEP_MNGR) run ruff format

.PHONY: lint
lint: ## Check code style and docstrings with Ruff
	$(DEP_MNGR) run ruff check

.PHONY: lint-fix
lint-fix: ## Fix auto-fixable Ruff issues
	$(DEP_MNGR) run ruff check --fix

.PHONY: typecheck
typecheck: ## Check static types with Pyright
	$(DEP_MNGR) run pyright

.PHONY: check
check: lint typecheck test ## Run linter, type checker, and tests

.PHONY: setup-hooks
setup-hooks: ## Install Git hooks (pre-commit and pre-push)
	$(DEP_MNGR) run pre-commit install --hook-type pre-commit
	$(DEP_MNGR) run pre-commit install --hook-type pre-push
	$(DEP_MNGR) run pre-commit install-hooks

.PHONY: test-hooks
test-hooks: ## Test Git hooks on all files
	$(DEP_MNGR) run pre-commit run --all-files


# Build and Publish
.PHONY: build
build: ## Build distributions
	$(DEP_MNGR) build

# Maintenance
.PHONY: clean
clean: ## Remove caches and build artifacts
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -exec rm -rf {} +
	rm -rf $(CACHE_DIRS) $(COVERAGE) $(DIST_DIRS) $(TMP_DIRS)
