# Contributing to SmartyPants

Thank you for your interest in contributing to SmartyPants! This guide will help you get started.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Standards](#code-standards)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Issue Reporting](#issue-reporting)
- [Release Process](#release-process)
- [Project Structure](#project-structure)

## Getting Started

### Prerequisites

- [Dart SDK](https://dart.dev/get-dart) >= 2.18.0
- [Flutter SDK](https://docs.flutter.dev/get-started/install) >= 3.24.0 (for running the example app)

### Setup

1. Fork the repository on GitHub.
2. Clone your fork locally:
   ```bash
   git clone https://github.com/<your-username>/smartypants.git
   cd smartypants
   ```
3. Install dependencies:
   ```bash
   dart pub get
   ```
4. Verify everything works:
   ```bash
   dart format --output=none --set-exit-if-changed .
   dart analyze
   dart test
   ```

## Development Workflow

### Branch Model

This project uses a two-tier branch model:

```
feature/fix branches
        │
        ▼  PR (day-to-day development)
     develop        ← default PR target
        │
        ▼  PR (when ready to release)
       main         ← always reflects the latest published version
        │
        ▼  release-please (automated)
    Release PR (version bump + CHANGELOG)
        │
        ▼  merge
    git tag → pub.dev
```

- **`develop`** — the default target for all feature and fix PRs. CI runs on every PR targeting this branch.
- **`main`** — represents the latest published state. Only receives merges from `develop` when a release is planned.

### Branching Strategy

Create a branch from `develop` using the following naming convention:

| Prefix      | Purpose                             | With issue       | Without issue               |
|-------------|-------------------------------------|------------------|-----------------------------|
| `feat/`     | New features                        | `feat/#42`       | `feat/markdown-support`     |
| `fix/`      | Bug fixes                           | `fix/#15`        | `fix/cjk-angle-brackets`    |
| `ci/`       | CI/CD changes                       | `ci/#20`         | `ci/add-release-workflow`   |
| `test/`     | Test additions or modifications     | `test/#33`       | `test/add-cjk-edge-cases`   |
| `docs/`     | Documentation changes               | `docs/#10`       | `docs/update-readme`        |
| `refactor/` | Refactoring without behavior change | `refactor/#7`    | `refactor/tokenizer`        |

**When an issue exists**, always include the issue number in the branch name (e.g., `feat/#42`). This keeps branches traceable to their motivation and makes cross-referencing easy in PR reviews.

When there is no associated issue, use a short kebab-case description instead.

### Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) style — this is required, as CHANGELOG entries are generated automatically from commit messages.

```
<type>: <description>
```

Common types: `feat`, `fix`, `test`, `ci`, `docs`, `refactor`, `perf`, `chore`

Rules:
- Use **lowercase** for both the type and the description.
- Keep the description concise and imperative ("add support for…", not "added support for…").
- Do **not** use a `bump:` type — version bumps are handled automatically by the release workflow.

Examples:
```
feat: add per-transformation flags to SmartyPantsConfig
fix: prevent bitshift operators from being converted to CJK citations
test: add edge cases for ellipsis conversion in CJK mode
docs: update API usage examples in README
ci: add release-please workflow
```

## Code Standards

### Formatting

All code must be formatted with `dart format`. The CI pipeline enforces this strictly:

```bash
dart format --output=none --set-exit-if-changed .
```

### Linting

The project uses the [recommended Dart lints](https://pub.dev/packages/lints). Run static analysis before submitting:

```bash
dart analyze
```

All warnings and errors must be resolved.

## Testing

### Running Tests

```bash
# Run library tests
dart test

# Run example app tests
cd example
flutter pub get
flutter test
```

### Writing Tests

- Add unit tests for all new functionality.
- Place tests in the `test/` directory, following the existing file organization:
  - `smartypants_test.dart` — core transformation logic
  - `smartypants_cjk_test.dart` — CJK-specific behavior
  - `smartypants_html_test.dart` — HTML tokenization
- Create a new test file when introducing a distinct feature area.

## Pull Request Process

### Feature / Fix PRs (→ `develop`)

1. Ensure your branch is up to date with `develop`.
2. Verify all checks pass locally:
   ```bash
   dart format --output=none --set-exit-if-changed .
   dart analyze
   dart test
   cd example && flutter test
   ```
3. Open a pull request targeting **`develop`** and fill out the [PR template](.github/PULL_REQUEST_TEMPLATE.md).
4. Wait for CI checks to pass and for a maintainer review.

> **Note:** You do not need to update `CHANGELOG.md` manually. Changelog entries are generated automatically from your commit messages when a release is prepared.

### Release PRs (`develop` → `main`)

When `develop` has accumulated enough changes for a release, a maintainer opens a PR from `develop` to `main`. Once merged:

1. `release-please` automatically creates a Release PR on `main` with the version bump and CHANGELOG.
2. The maintainer reviews and merges the Release PR.
3. A git tag is created automatically, triggering the publish workflow.

### CI Checks

The PR check workflow runs on all PRs targeting `develop` or `main` and validates:
- Code formatting (`dart format`)
- Static analysis (`dart analyze`)
- Unit tests (`dart test`)
- Example app analysis and tests (`flutter analyze` / `flutter test`)

All checks must pass before a PR can be merged.

## Issue Reporting

Use the provided [issue templates](.github/ISSUE_TEMPLATE/) when opening an issue:

- **Bug Report** — for unexpected behavior or errors
- **Feature Request** — for proposing new functionality
- **Chore/Task** — for maintenance or infrastructure tasks
- **Design Discussion** — for architectural or design conversations
- **Documentation** — for documentation improvements

Blank issues are disabled; please choose the most appropriate template.

## Release Process

Releases are fully automated using [release-please](https://github.com/googleapis/release-please).

### How it works

```
feat/fix PRs merged to develop
          │
          ▼  (when ready to release)
  develop → main PR merged
          │
          ▼
  release-please Action runs
          │
          ▼
  "Release PR" created on main
  (CHANGELOG.md + pubspec.yaml version bump)
          │
          ▼
  Maintainer merges the Release PR
          │
          ▼
  Git tag created automatically (e.g. 0.1.0)
          │
          ▼
  publish.yml triggers → published to pub.dev
```

### What contributors need to do

Nothing — just write conventional commits. `release-please` reads your commit history and:
- Determines the next version (following [Semantic Versioning](https://semver.org/))
- Populates `CHANGELOG.md` with categorized entries
- Bumps the version in `pubspec.yaml`

### Version bumping rules

| Commit type                      | Version bump       |
|----------------------------------|--------------------|
| `fix:`, `perf:`                  | Patch (0.0.x)      |
| `feat:`                          | Minor (0.x.0)      |
| `BREAKING CHANGE` in footer      | Major (x.0.0)      |
| `chore:`, `docs:`, `test:`, `ci:`, `refactor:` | No version bump |

For breaking changes, add a `BREAKING CHANGE: <description>` footer to the commit body:

```
feat: rename SmartyPantsConfig.smart to SmartyPantsConfig.enabled

BREAKING CHANGE: the `smart` field has been renamed to `enabled`.
Callers must update their config instantiation accordingly.
```

## Project Structure

```
smartypants/
├── lib/
│   ├── smartypants.dart          # Public API exports
│   └── src/                      # Internal implementation
├── test/                         # Unit tests
├── example/                      # Flutter example app
├── .github/
│   ├── workflows/                # CI/CD pipelines
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── ISSUE_TEMPLATE/           # Issue templates
├── release-please-config.json    # release-please configuration
├── .release-please-manifest.json # Current tracked version
├── pubspec.yaml
├── analysis_options.yaml
├── CHANGELOG.md
├── ROADMAP.md
└── AUTHORS
```

For a list of planned features and priorities, see [ROADMAP.md](ROADMAP.md).
