# SYS-HEALTH - Health checks

- **Status**: Accepted as consideration
- **Date**: 2026-11-25

## Added Features

- HTTP health endpoint (machine readable).
- Required dependency failure turns the answer into a failing status.
- Reports internal dependencies (DB, workers, etc).
- Reports external dependencies (services).
- 1s timeout.

## Risks

- Exposure of secrets, connection strings or stack traces.
