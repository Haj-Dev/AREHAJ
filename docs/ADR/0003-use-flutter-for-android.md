# ADR-0003: Use Flutter for the Android Application

- **Status**: Accepted
- **Date**: 2026-11-23
- **Scope**: Installable Android application technology

## Context

AREHAJ requires an Android application in addition to its ReactJS browser frontend. Both clients use the Rust backend API and share authoritative data stored in PostgreSQL.

The Android comparison covers Kotlin/Jetpack Compose, Flutter, React Native, Rust/Tauri, and Java/Android Views. The project has explicitly selected Flutter.

“Native Android application” here means an installable Android application with device integration, not a requirement that every UI element be an Android toolkit control. Flutter renders its own widgets and is not a website packaged inside a WebView.

## Decision

Use **Flutter with Dart** to implement the Android application.

- Produce signed Android release artifacts: APKs for appropriate installation/testing workflows and AABs for Google Play publishing where applicable.
- Consume the Rust backend API rather than connecting directly to PostgreSQL.
- Use reviewed Flutter plugins and platform channels to Kotlin/Java when required for Android features.
- Keep the ReactJS browser frontend separate; this decision does not select Flutter Web.

Other native platforms are outside this ADR's scope.

## Rationale

- Flutter provides a declarative widget framework with control over custom layouts and visual behavior.
- Hot reload supports iterative UI development.
- Release compilation and native integration support an installable Android product without a WebView-based application shell.
- The same backend contracts can serve Flutter and ReactJS without requiring a shared UI framework.

These capabilities do not establish that Flutter is universally faster than Kotlin or that all required plugins are available. Device-level validation remains necessary.

## Alternatives Considered

| Alternative | Relevant trade-off |
| --- | --- |
| Kotlin / Jetpack Compose | Direct Android toolkit integration and a strong Android-only baseline; not the selected UI stack |
| React Native | React knowledge reuse and native UI components; native dependency compatibility still needs maintenance |
| Rust / Tauri 2 | Rust and web UI reuse, but WebView rendering and mobile plugin trade-offs |
| Java / Android Views | Established Android integration, particularly for an existing Java app; more boilerplate for many new workflows |

ReactJS for the website does not imply React Native for Android. Rust for the backend does not imply a Rust mobile UI or Rust code embedded in the app.

## Consequences

### Positive

- Android receives a dedicated installable application rather than a browser wrapper.
- Flutter provides a consistent widget and development model for the Android UI.
- The API boundary allows the mobile UI and backend to evolve independently, subject to compatibility.

### Costs and Risks

- The project maintains Dart/Flutter and ReactJS UI implementations separately.
- Android lifecycle, permissions, background behavior, signing, and publishing policies still apply.
- Missing or incompatible plugins can require custom Kotlin/Java integration and additional maintenance.
- Flutter rendering needs practical accessibility, text scaling, focus, and platform-behavior testing.
- Existing installed clients may remain in use after backend deployments, making API compatibility important.

## Follow-up Decisions and Validation

Not selected by this ADR: state-management library, navigation package, minimum Android version, supported architectures, distribution channel, local database, offline support, or synchronization design.

Verify required plugins early. Test release builds on representative physical Android devices, including TalkBack, process recreation, network interruption, session expiry, memory use, startup, and frame pacing.

Keep signing credentials and server secrets out of the repository and application bundle. Store sensitive client credentials using an appropriate platform-backed mechanism.

## References

- [Android frontend comparative study](../comparative%20studies/Frontend-Language-Comparison.md)
- [ADR-0001: Rust backend](0001-use-rust-for-backend.md)
- [ADR-0002: ReactJS web frontend](0002-use-reactjs-for-web-frontend.md)
- [ADR-0004: PostgreSQL database](0004-use-postgresql-for-database.md)
