# ENG-ASYNC - Asynchronous execution

- **Status**: Accepted as consideration
- **Date**: 2026-11-25

> "A slow partner must not hold the whole product hostage or lose work."

## Added Features

- Workflow runs are accepted by the API and executed by a worker separate from the API server.
- The API answers before the run finishes and returns an identifier used to query the run status.
- Pending runs are stored in a durable job queue, not in memory.
- The queue is PostgreSQL-backed and uses an existing job-queue library.
- A run and its queue entry are committed in one transaction, so accepted work is not lost between them.
- The worker can be stopped, have work queued, and be restarted without losing accepted runs.
- Every third-party call has a documented, finite timeout and bounded retries.
- Worker concurrency and replica count are changed through configuration, not source changes.

## Queue Decision

Pending work is carried by **PostgreSQL** using the existing `apalis-postgres` job queue.

- PostgreSQL is already the authoritative database ([ADR-0004](../../ADR/0004-use-postgresql-for-database.md)), so no new broker service is introduced.
- The run row and queue job can be written in the same transaction.
- Durability and recovery follow the existing database backup and restore process.
- Redis and RabbitMQ are rejected for Phase 1 because they add a separate stateful service and would require an outbox to avoid a dual-write window.

## Done When

- A run request returns before the workflow finishes, and the run completes afterwards.
- The API can be restarted after accepting a run without losing it.
- The worker can be stopped, runs can be queued, and the worker can be restarted with no accepted run lost.
- A partner that never responds fails within the documented timeout, and retries stop at the configured limit.
- Worker capacity changes through configuration or replica count only.
- Pending work is visible in the queue and can be inspected after a failure.

## Risks

- At-least-once delivery can duplicate partner calls; workflow steps must be idempotent.
- The queue adds load to PostgreSQL; queue depth and connection usage must be monitored.
- A crashed worker leaves work leased until it is reclaimed; lease duration must be set carefully.
- Poison jobs need a retry limit and a dead-letter or archive path.
- Timeouts that are too short cause false failures; timeouts that are too long hold capacity.

## References

- [ADR-0001: Rust backend](../../ADR/0001-use-rust-for-backend.md)
- [ADR-0004: PostgreSQL database](../../ADR/0004-use-postgresql-for-database.md)
- [SYS-HEALTH](SYS-HEALTH.md)
- [SYS-K8S](SYS-K8S.md)
