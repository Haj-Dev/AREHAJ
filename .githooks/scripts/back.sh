#!/usr/bin/env bash
set -euo pipefail

cd backend

cargo fmt --all

cargo clippy --workspace --all-targets --fix \
  --allow-dirty --allow-staged -- -D warnings

cargo check --workspace
cargo test --workspace
