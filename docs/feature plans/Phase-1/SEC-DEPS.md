# SEC-DEPS - Dependency scanning

- **Status**: Accepted as consideration
- **Date**: 2026-11-25

## Added Features

- CI that scans project dependencies and reports known vulnerabilities.
- CI fails on detection of compromised dependencies to alert group.

## Risks

- Failure to detect dependencies and/or fetch known vulnerabilities leading to use of compromised dependencies.
