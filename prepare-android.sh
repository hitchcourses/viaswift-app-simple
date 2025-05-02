#!/bin/bash

# Exit on error
set -e

# STEP 1: Make sure we have the latest capacitor.config.json
echo "Updating Capacitor configuration..."
cat > capacitor.config.json << EOL
{
  "appId": "io.viaswift.app",
  "appName": "ViaSwift",
  "webDir": "dist",
  "bundledWebRuntime": true,
  "appVersion": "1.0.0",
  "appBuild": "1",
  "plugins": {
    "SplashScreen": {
      "launchShowDuration": 3000,
      "backgroundColor": "#222222",
      "androidSplashResourceName": "splash",
      "androidScaleType": "CENTER_CROP"
    },
    "Geolocation": {
      "locationWhenInUsePermissionDescription": "We need your location to find rides and deliveries near you.",
      "locationAlwaysPermissionDescription": "We need your location to track rides and deliveries."
    },
    "LocalNotifications": {
      "smallIcon": "ic_stat_notification",
      "iconColor": "#FF9800"
    }
  }
}
EOL

# STEP 2: Update Android build configuration
echo "Updating Android configuration..."

# Update build.gradle if it exists
if [ -f android/app/build.gradle ]; then
  echo "Updating Android build.gradle..."
  # Set minSdkVersion to 22 and targetSdkVersion to 33
  sed -i 's/minSdkVersion.*/minSdkVersion = 22/' android/app/build.gradle
  sed -i 's/targetSdkVersion.*/targetSdkVersion = 33/' android/app/build.gradle
  # Update version code and name
  sed -i 's/versionCode.*/versionCode = 1/' android/app/build.gradle
  sed -i 's/versionName.*/versionName = "1.0.0"/' android/app/build.gradle
fi

# STEP 3: Sync with Capacitor
echo "Syncing with Capacitor..."
npx cap sync android

echo "Copying web assets to Android..."
npx cap copy android

echo "✅ Android preparation complete!"
echo "You can now build the Android app using one of the following methods:"
echo "1. Open in Android Studio: npx cap open android"
echo "2. Build using AppFlow cloud builds"
echo "3. Build using the GitHub repository"
