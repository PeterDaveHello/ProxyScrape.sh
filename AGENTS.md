# Repository Guidelines

## Dos and Don’ts

- Do run `bash -n ProxyScrape.sh` before committing to catch syntax issues early.
- Do keep edits minimal and aligned with the current bash style; prefer small focused diffs.
- Do confirm required CLI tools (`wc`, `curl`, `flock`, `mktemp`, `mv`, `dos2unix`, `sort`, `uniq`, `xargs`) exist via `command -v` when changing dependencies.
- Don’t introduce new external dependencies or restructure the script without agreement from maintainers.
- Don’t store fetched proxy lists or credentials in the repository; keep output paths outside version control.

## Project Structure and Module Organization

- The project is a single bash script that aggregates and tests SOCKS5 proxies.
- Root files: `ProxyScrape.sh` (main workflow), `README.md` (usage overview), `LICENSE`.
- There are no subdirectories for source, tests, or assets; all logic resides in `ProxyScrape.sh`.
- No CI workflows are configured; if adding one, use `.github/workflows/`.

## Build, Test, and Development Commands

- Make the script executable when cloning on a new machine: `chmod +x ProxyScrape.sh`.
- Static syntax check: `bash -n ProxyScrape.sh` (runs locally without network access).
- Run the scraper (requires outbound HTTPS and the listed CLI tools): `./ProxyScrape.sh`.
- Override defaults when verifying fixes, e.g. `PROXY_TIMEOUT=5 TEST_TARGET_HOST=https://www.wikipedia.org ./ProxyScrape.sh`; expect failures if the network or proxy sources are unreachable.

## Coding Style and Naming Conventions

- Bash scripting with `set -e`; keep function definitions and loops formatted like existing blocks (4-space indentation, space before `do`).
- Keep color-echoing helper functions following the `echo.ColorName` pattern and uppercase environment/config variables.
- Comments use `#` with concise en-US phrasing; place comments above the code they describe.

## Testing Guidelines

- There is no automated test suite; validate changes by executing `./ProxyScrape.sh` with representative targets and reviewing the generated proxy list.
- When networking is unavailable, at least run `bash -n ProxyScrape.sh` and manual spot checks of modified logic.
- Use temporary output paths (`mktemp` or env-configured files) to avoid overwriting prior results during verification.

## Commit and Pull Request Guidelines

- Follow the existing commit style: imperative subject, no trailing period, capitalized first word (e.g., “Remove source - proxyscan.io, seems unavailable for a while”).
- Keep commits focused on a single concern and describe the motivation in the body when relevant.
- Ensure the script runs without errors before requesting review; note any network limitations or manual steps in the PR description.

## Safety and Permissions

- Ask before adding dependencies, renaming files, or introducing new directories or configuration.
- You may list files, read docs, and run file-scoped commands (e.g., `bash -n ProxyScrape.sh`) without approval.
- Avoid mass reformatting or wholesale rewrites; prefer minimal, auditable changes.
- Never commit fetched proxy data or sensitive endpoints; keep verification artifacts out of the repo.
