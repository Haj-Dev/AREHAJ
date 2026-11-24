#!/usr/bin/env bash
set -euo pipefail

cd mobile

dart format .

flutter pub get --enforce-lockfile
flutter analyze
flutter test
flutter build apk --debug
