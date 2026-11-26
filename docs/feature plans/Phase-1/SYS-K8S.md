# SYS-K8S - Container orchestration

- **Status**: Accepted as consideration
- **Date**: 2026-11-25

## Added Features

- A Helm chart that deploys the whole product: API, worker, web, and the database used by local deployments.
- The same chart deploys to a local cluster and a managed cluster through different values files.
- The API can run with multiple replicas; the worker is a separate deployment that can be scaled independently.
- Non-sensitive configuration is supplied through chart values and ConfigMaps.
- Sensitive configuration is supplied through Secrets.
- Services expose the API and web components.
- Deployments use readiness and liveness probes.
- Resource requests and limits are set for each container.

## Chart Decision

Use a **Helm chart** to package the Kubernetes manifests.

- One chart renders the whole product; local and managed clusters differ through values rather than separate manifest sets.
- Values cover replica counts, image tags, resource limits, ingress, and database settings.
- The chart renders plain Kubernetes YAML, so the cluster receives the same objects as a manual manifest deployment.
- Helm is chosen over separate plain-YAML sets because those would duplicate or hand-edit manifests for each environment.

## Deliverables

- A chart under `charts/arehaj/` with `Chart.yaml`, `values.yaml`, `values-local.yaml`, `values-managed.yaml`, and `templates/`.
- A short README with install, upgrade, and uninstall commands.
- No application code changes are required to deploy.
- The feature does not provision a cluster or a managed Kubernetes service.

## Done When

- `helm install` deploys the product to a local cluster using the local values file.
- The API is reachable and can run with more than one replica.
- The worker runs separately and can be scaled through values.
- Configuration changes are made in values or ConfigMaps; secrets are not stored in the chart.
- The same chart deploys to a managed cluster using the managed values file.
- Pods become ready, serve traffic, and recover after a pod restart.

## Risks

- Secrets committed to Git or exposed in values files, rendered manifests, or logs.
- Chart values drift from the application's actual configuration.
- Local-only assumptions such as storage class, ingress, or image registry break on a managed cluster.
- Missing or excessive resource limits cause eviction or wasted capacity.
- Misconfigured probes cause restart loops.
- Helm release state drifts from the cluster; upgrades need review.

## References

- [ADR-0004: PostgreSQL database](../../ADR/0004-use-postgresql-for-database.md)
- [SYS-HEALTH](SYS-HEALTH.md)
- [SYS-SECRETS](SYS-SECRETS.md)
- [SYS-RELEASE](SYS-RELEASE.md)
