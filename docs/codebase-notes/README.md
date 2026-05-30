# Codebase Notes

Last verified against codebase: 2026-05-30

## Purpose

These notes are an AI-readable and developer-readable navigation aid for the repository. They are not the source of truth. The source of truth is the repository code and configuration.

## Status / Ownership

These notes describe confirmed repository facts as of the verification date above. Agents and maintainers should update them when they discover stable, confirmed knowledge during repository work.

## When To Read Each File

- `README.md`: Start here for purpose, rules, note map, unknowns, and validation instructions.
- `_template.md`: Use when adding a new durable note.
- `00-system-overview.md`: Read for repository purpose, top-level components, and supported target system.
- `01-architecture.md`: Read for Ansible playbook structure, roles, and Docker service layout.
- `02-key-flows.md`: Read for a concise index of provisioning and runtime flows.
- `03-data-and-storage.md`: Read for host directories, Docker volumes, and database/storage notes.
- `04-apis-and-integrations.md`: Read for external tools, containerized services, and network integrations.
- `05-deployment-and-config.md`: Read before changing `.env`, `deploy.sh`, inventory, or Docker Compose behavior.
- `06-known-risks.md`: Read before changing host provisioning, remote shell tasks, credentials, or generated config.
- `adr/README.md`: Read before adding architecture decision records.
- `check-notes.ps1`: Windows/PowerShell validator for the docs health checks.
- `check-notes.sh`: Linux/macOS shell validator equivalent for the same health checks.

## Major Confirmed Flows

- An Ansible control machine loads `.env` through `deploy.sh` and runs `Ansible/playbook.yml`.
- The playbook bootstraps Python first with raw commands, then applies host setup roles.
- Host setup configures SSH, apt packages, Tailscale, Docker, user shell preferences, and rfkill behavior.
- Home Assistant and add-on containers are defined in `Docker/docker-compose.yml`.
- The playbook copies Docker Compose and `.env` to the target user's home directory, initializes config files through `docker compose up -d`, adjusts generated YAML/config files, installs HACS, and starts the stack.

## Open Questions / Unknowns Index

- See `06-known-risks.md` for unsupported or unverified operating system targets, current test gaps, credential handling risk, and remote install script risk.
- See `03-data-and-storage.md` for uncertainty around MariaDB initialization and container user ownership behavior.
- See `04-apis-and-integrations.md` for integrations that require manual setup after provisioning.

## Note Creation Rules

- Inspect the repository before writing notes.
- Use breadth-first investigation first.
- Only document confirmed facts.
- Mark uncertain findings under `Unknown / Needs verification`.
- Use stable references such as file path plus role, task name, config key, service name, or file name.
- Avoid exact line-number references in durable notes.
- Avoid duplicating durable knowledge across notes.
- Prefer correcting existing notes over adding new notes.
- Prefer small incremental updates over large rewrites unless restructuring is necessary.
- Do not create placeholder flow files with generic or unconfirmed content.

## Maintenance Rules

- Update the most relevant note when confirmed knowledge changes.
- Keep `02-key-flows.md` concise and under 100 lines.
- Create domain-specific flow files only when the repository clearly contains that domain and the flow needs more detail than the index.
- Add `Last verified against codebase: YYYY-MM-DD` to every note.
- For major architectural claims, include confidence and evidence using stable repository references.

## Anti-Drift Rules

- Trust code over notes when they disagree.
- Re-check important claims against the repository before relying on them.
- Do not document generated outputs, dependency folders, local environment files, temporary/cache folders, or build artifacts unless the task explicitly requires it.
- Do not store temporary investigation transcripts or conversational summaries as durable notes.

## Bloat Control Rules

- Notes should stay human-reviewable and focused.
- If a note becomes difficult to scan quickly, split by topic only when there is enough confirmed content to justify it.
- Suggested split folders, when needed, include `flows/`, `integrations/`, and `risks/`.
- Avoid excessive cross-references that make navigation harder than reading code directly.

## Archive Guidance

- Obsolete task-specific notes may be moved to `docs/codebase-notes/archive/`.
- Do not archive facts merely because they are wrong; correct invalid facts in place.
- Do not delete historical architectural context unless it is clearly invalid.
- If a note is superseded, mark what replaced it.

## Health Check Instructions

Run the validator after changing notes or `AGENTS.md`.

Windows or PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File docs/codebase-notes/check-notes.ps1
```

PowerShell Core:

```powershell
pwsh -ExecutionPolicy Bypass -File docs/codebase-notes/check-notes.ps1
```

Linux/macOS:

```bash
bash docs/codebase-notes/check-notes.sh
```

If more than one validator is available in the environment, run each available equivalent.
