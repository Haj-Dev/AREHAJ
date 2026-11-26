# ADR-0001: Use Rust for the Backend

- **Status**: Accepted
- **Date**: 2026-11-23
- **Scope**: Backend implementation language and shared API boundary

## Context

AREHAJ will have a React with TypeScript browser frontend and a Flutter Android application. Both clients need access to shared business logic and authoritative data stored in PostgreSQL.

The backend comparison considers Rust, Go, Python, Java, and Node.js. The project has explicitly selected Rust. This record captures that decision; it does not assert that implementation or performance validation has been completed.

## Decision

Use **Rust** to implement the backend API shared by both clients.

The backend is responsible for:

- Authentication and authorization of client requests.
- Validation of inputs and enforcement of business rules.
- Access to PostgreSQL, including transaction handling and connection management.
- Returning API responses suitable for both browser and Android consumers.

Clients must not contain PostgreSQL credentials or connect directly to the authoritative database. The API contract must be documented and tested so the two independently implemented clients can use it consistently.

## Rationale

- Rust provides native compilation and control over resource usage without requiring a garbage collector.
- Ownership and borrowing prevent many memory-safety errors in safe Rust and help enforce thread-safety constraints.
- Strong typing and explicit error handling support maintainable service boundaries.
- A shared backend avoids duplicating authoritative business rules across React with TypeScript and Flutter.

These are architectural benefits, not evidence that Rust will meet a particular latency, throughput, cost, or security target without testing.

## Alternatives Considered

| Alternative | Relevant trade-off                                                                                                                       |
| ----------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Go          | Simpler onboarding and established service tooling; not the selected language                                                            |
| Python      | Rapid development and broad libraries; different runtime and resource trade-offs                                                         |
| Java        | Mature frameworks and operational ecosystem; JVM and framework trade-offs                                                                |
| Node.js     | JavaScript/TypeScript ecosystem alignment with the web client; a shared language does not eliminate the need for a server trust boundary |

These remain valid options in other contexts. They are not planned parallel backend implementations.

## Consequences

### Positive

- One authoritative API serves both clients.
- Rust's type system and safe-memory model provide useful implementation safeguards.
- PostgreSQL access and security-sensitive rules stay on the server.

### Costs and Risks

- Ownership, lifetimes, asynchronous code, and library choices require Rust expertise.
- Compile-time checks do not prevent authorization mistakes, injection, insecure configuration, or unsafe/FFI defects.
- Database queries, connection limits, and external services may dominate response latency regardless of language choice.
- API changes must remain compatible with deployed browser and Android clients or include a migration strategy.

## Follow-up Decisions and Validation

The current implementation uses axum and tokio. This ADR records only the language decision; the web framework, async runtime, PostgreSQL driver or ORM, API style, authentication mechanism, hosting, and deployment topology are not evaluated here and should be recorded separately.

Select those tools separately. Add API contract tests, integration tests with PostgreSQL, observability, and representative load tests before claiming production objectives are met.

## References

- [Backend comparative study](../comparative%20studies/Backend-Language-Comparison.md)
- [ADR-0002: React with TypeScript web frontend](0002-use-react-with-typescript-for-web-frontend.md)
- [ADR-0003: Flutter Android application](0003-use-flutter-for-android.md)
- [ADR-0004: PostgreSQL database](0004-use-postgresql-for-database.md)
