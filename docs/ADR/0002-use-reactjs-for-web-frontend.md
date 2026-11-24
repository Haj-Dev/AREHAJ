# ADR-0002: Use ReactJS for the Browser Frontend

- **Status**: Accepted
- **Date**: 2026-11-23
- **Scope**: Browser-based frontend technology

## Context

AREHAJ requires a web version accessed through a URL in desktop and mobile browsers. This version is distinct from the Flutter Android application: it is not an APK, a native wrapper, or a website hosted inside an application WebView.

The web comparison covers React, Vue, Angular, Svelte, Flutter Web, and Rust/Leptos. The project has explicitly selected ReactJS. Rust is selected for the backend and PostgreSQL for authoritative storage.

## Decision

Use **ReactJS (React)** to implement the browser frontend.

The web frontend communicates with the Rust backend API. Authentication enforcement, authorization, business rules, and PostgreSQL access remain backend responsibilities; client validation is for usability and does not replace server validation.

The selection is React itself, **not automatic adoption of Next.js**, React Native, or a Node.js application backend. Build-time JavaScript tooling does not change the Rust backend decision.

## Rationale

- React's component model supports reusable interface elements and interactive workflows.
- Its ecosystem offers options for routing, forms, accessibility, testing, and API integration.
- DOM-based interfaces support conventional browser behavior and semantic HTML when implemented correctly.
- A browser frontend can evolve independently of Flutter while sharing backend contracts rather than UI implementation.

This decision does not assume existing React expertise, measured hiring advantages, or verified performance for this project.

## Alternatives Considered

| Alternative        | Relevant trade-off                                                                |
| ------------------ | --------------------------------------------------------------------------------- |
| Vue / Nuxt         | Approachable component model and integrated rendering options; not selected       |
| Angular            | Integrated architecture and conventions; additional framework concepts            |
| Svelte / SvelteKit | Concise component authoring; integration availability needs assessment            |
| Flutter Web        | Potential Flutter code reuse; different rendering and browser-behavior trade-offs |
| Rust / Leptos      | Rust-centric frontend logic; specialized tooling and integration costs            |

Next.js and Vite are potential React tooling choices, not rejected competing UI technologies or adopted dependencies.

## Consequences

### Positive

- Browser delivery stays separate from Android packaging and store release processes.
- The project can use standard web semantics, CSS, and browser testing tools.
- React components and API integration can be tested independently of the Android UI.

### Costs and Risks

- React and Flutter require separate UI implementations and framework-specific tests.
- Dependency selection, state management, accessibility, and bundle size still require deliberate design.
- React does not automatically provide SEO, server rendering, secure session handling, or good performance.
- Client/server API changes must account for both frontend implementations.

## Follow-up Decisions and Validation

Not selected by this ADR: JavaScript versus TypeScript, Next.js versus Vite or other tooling, router, state-management library, design system, rendering model, hosting, or PWA/offline support.

Choose rendering based on actual content and search requirements. Any additional frontend server must have an explicit role alongside the Rust API rather than silently replacing it.

Validate accessibility, browser navigation, responsive layouts, session expiry, API failures, loading performance, and critical interactions in production-equivalent builds.

## References

- [Web frontend comparative study](../comparative%20studies/Web-Frontend-Comparison.md)
- [ADR-0001: Rust backend](0001-use-rust-for-backend.md)
- [ADR-0003: Flutter Android application](0003-use-flutter-for-android.md)
- [ADR-0004: PostgreSQL database](0004-use-postgresql-for-database.md)
