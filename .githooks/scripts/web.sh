#!/usr/bin/env bash
set -euo pipefail

cd web

npm ci

npx prettier --write .
npx eslint . --fix

npm run typecheck
npm test -- --run
npm run build
