# ENG-ASYNC - Asynchronous execution

- **Status**: Accepted as consideration
- **Date**: 2026-11-25

## Added Features

- Worker separate from server.
- Persistent queue for pending workflow run.

## Risks

- Additional complexity for handling workflows.
- Workflows runs may be lost when the queue is improperly handled.
