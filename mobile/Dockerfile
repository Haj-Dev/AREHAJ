FROM plugfox/flutter:3.47.9-android
# android-arm64 = real phones. Use android-x64 for an x86 emulator.
ARG TARGET=android-arm64
WORKDIR /app
RUN flutter create . --project-name app --platforms=android

# INTERNET isn't in release manifests by default; also allow plain-http (dev only)
RUN sed -i \
    -e 's#<application#<uses-permission android:name="android.permission.INTERNET"/>\n    <application android:usesCleartextTraffic="true"#' \
    android/app/src/main/AndroidManifest.xml
RUN printf '\norg.gradle.parallel=true\norg.gradle.caching=true\norg.gradle.workers.max=%s\norg.gradle.jvmargs=-Xmx4g\n' "$(nproc)" >> android/gradle.properties

# WARM-UP LAYER: build the untouched template once. SDK parts, the gradle
# distribution and all dependencies get baked into this cached layer, so it
# only reruns if the lines above change. Slow once, then never again.
RUN flutter build apk --release --target-platform ${TARGET}

# Everything below reruns on code changes and is the fast part.
COPY pubspec.yaml ./
COPY lib ./lib
RUN flutter pub get && \
    flutter build apk --release --target-platform ${TARGET}

CMD ["cp", "/app/build/app/outputs/flutter-apk/app-release.apk", "/out/"]
