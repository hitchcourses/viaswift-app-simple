# ViaSwift CI/CD Setup Guide

This guide provides instructions for setting up Continuous Integration and Continuous Deployment (CI/CD) for the ViaSwift mobile app using Codemagic or other CI/CD platforms.

## Prerequisites

- GitHub repository with ViaSwift code
- Codemagic account or similar CI/CD platform
- Firebase project (for app distribution)
- App Store Connect account (for iOS distribution)
- Google Play Console account (for Android distribution)

## Setup Instructions

### 1. Initial Setup

When setting up a new CI/CD pipeline, ensure the repository has the following scripts available:

- `setup-android-gradle.sh`: Creates the Android Gradle environment
- `fixed-appflow-build.sh` (or `build-for-appflow.sh`): Prepares the app for Ionic AppFlow
- `prepare-android.sh`: Configures Android build settings

### 2. Handling the "Missing gradlew" Error

If you encounter the error `Couldn't find gradlew at path '/builds/[path]/gradlew'`, run the `setup-android-gradle.sh` script first in your CI/CD pipeline:

```yaml
scripts:
  - name: Setup Android Gradle
    script: |
      chmod +x ./setup-android-gradle.sh
      ./setup-android-gradle.sh
```

### 3. Codemagic Configuration Example

Here's a sample `codemagic.yaml` configuration:

```yaml
workflows:
  android-workflow:
    name: Android Build
    instance_type: mac_mini_m1
    environment:
      vars:
        FIREBASE_PROJECT_ID: $FIREBASE_PROJECT_ID
    scripts:
      - name: Setup Android Gradle
        script: |
          chmod +x ./setup-android-gradle.sh
          ./setup-android-gradle.sh
      - name: Build Android app
        script: |
          cd android
          ./gradlew assembleRelease
    artifacts:
      - android/app/build/outputs/**/*.apk
  
  ios-workflow:
    name: iOS Build
    instance_type: mac_mini_m1
    environment:
      vars:
        BUNDLE_ID: "io.viaswift.app"
        XCODE_SCHEME: "App"
    scripts:
      - name: Prepare iOS build
        script: |
          npx cap add ios
          npx cap sync ios
      - name: Build iOS app
        script: |
          cd ios/App
          xcodebuild -scheme "$XCODE_SCHEME" -configuration Release archive -archivePath "$XCODE_SCHEME.xcarchive"
    artifacts:
      - ios/App/*.xcarchive
```

### 4. GitHub Actions Configuration Example

```yaml
name: Mobile App Build

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build_android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up JDK 17
        uses: actions/setup-java@v3
        with:
          java-version: '17'
          distribution: 'temurin'
      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 18
      - name: Install dependencies
        run: npm ci
      - name: Setup Android Gradle
        run: |
          chmod +x ./setup-android-gradle.sh
          ./setup-android-gradle.sh
      - name: Build Android app
        run: |
          cd android
          ./gradlew assembleDebug
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: app-debug.apk
          path: android/app/build/outputs/apk/debug/app-debug.apk
```

## Troubleshooting

### Common Issues

1. **Missing Android SDK Tools**:
   Solution: Add SDK tools installation to your CI script:
   ```bash
   sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"
   ```

2. **iOS Code Signing Issues**:
   Solution: Configure code signing profiles in your CI environment and add to your build script:
   ```bash
   xcodebuild -exportArchive -archivePath "$XCODE_SCHEME.xcarchive" -exportPath ./build -exportOptionsPlist exportOptions.plist
   ```

3. **Network Timeouts During Build**:
   Solution: Add retry logic and increase timeout settings:
   ```bash
   ./gradlew assembleRelease --no-daemon --max-workers 2 --build-cache
   ```

## Resources

- [Capacitor CI/CD Documentation](https://capacitorjs.com/docs/guides/ci-cd)
- [Codemagic Documentation for Ionic](https://docs.codemagic.io/yaml-quick-start/ionic-app-configuration/)
- [GitHub Actions for Mobile Development](https://docs.github.com/en/actions/guides/building-and-testing-nodejs)
