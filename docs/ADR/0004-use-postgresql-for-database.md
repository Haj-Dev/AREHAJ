# ADR-0004: Use PostgreSQL as the Authoritative Database

- **Status**: Accepted
- **Date**: 2026-11-23
- **Scope**: Authoritative backend application storage

## Context

AREHAJ's ReactJS browser frontend and Flutter Android application need shared authoritative storage through the Rust backend API.

The database comparison considers PostgreSQL, MySQL/InnoDB, SQLite, and MongoDB. The project has explicitly selected PostgreSQL. The schema, workload, hosting environment, availability objectives, and recovery requirements still need definition; this decision does not claim that they have been validated.

## Decision

Use **PostgreSQL** as the authoritative application database.

- The Rust backend owns database access, transaction handling, migrations, and connection management.
- Neither the browser frontend nor the Android application receives direct database credentials.
- Model relationships and key invariants using appropriate relational constraints and transactions.
- Use JSONB selectively when the data model justifies it, rather than replacing deliberate schema design with unstructured documents.
- Keep schema migrations under version control and plan compatibility with application deployments.

This decision does not select a device-local database or introduce offline synchronization.

## Rationale

- Relational constraints and transactions support consistent updates across related records.
- Expressive SQL supports evolving filters, joins, aggregation, and reporting needs.
- JSONB offers flexibility for selected attributes alongside relational data.
- PostgreSQL provides established backup, recovery, replication, and operational tooling.

These capabilities make PostgreSQL a suitable architectural baseline, but actual durability, performance, and availability depend on configuration, infrastructure, and tested procedures.

## Alternatives Considered

| Alternative    | Relevant trade-off                                                                                                                                              |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| MySQL / InnoDB | Credible transactional relational alternative; existing expertise or hosting could favor it in another context                                                  |
| SQLite         | Strong embedded/local-storage option and viable for suitable small backend topologies; single-writer behavior and shared deployment constraints need evaluation |
| MongoDB        | Document-oriented modeling can suit aggregate-based access; cross-document relationships and invariants have different trade-offs                               |

SQLite remains a possible separate Android-local storage decision, not an adopted component or a replacement for PostgreSQL on the server.

## Consequences

### Positive

- Both clients use one authoritative data model through the Rust API.
- Database constraints can reinforce backend correctness.
- Relational and selected document-shaped data can coexist without immediately introducing another database service.

### Costs and Risks

- PostgreSQL requires operational ownership, even when a managed service is used.
- Indexes, query plans, vacuum health, long transactions, connections, and schema locks require monitoring and maintenance.
- Schema changes and backfills must account for existing data and overlapping application releases.
- Replication alone is not a backup, and a managed service does not prove recovery works.
- Database selection does not automatically provide regulatory compliance, tenant isolation, encryption policy, or secure authorization.

## Follow-up Decisions and Validation

Not selected by this ADR: PostgreSQL version, hosting provider, Rust driver or ORM, migration tool, extensions, pooling solution, replication topology, or database-level authorization policies.

Before production:

- Define schema, access patterns, retention, and expected concurrency.
- Set recovery point and recovery time objectives and choose backup retention accordingly.
- Test migrations, representative queries, concurrent updates, and transaction retries where applicable.
- Automate backups and verify restores in an isolated environment.
- Configure least-privilege accounts, restricted network access, secure transport, and secret management.
- Monitor capacity, query latency, errors, and connection usage.

## References

- [Database comparative study](../comparative%20studies/Database-Comparison.md)
- [ADR-0001: Rust backend](0001-use-rust-for-backend.md)
- [ADR-0002: ReactJS web frontend](0002-use-reactjs-for-web-frontend.md)
- [ADR-0003: Flutter Android application](0003-use-flutter-for-android.md)
