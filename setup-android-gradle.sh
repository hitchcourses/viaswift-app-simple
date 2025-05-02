#!/bin/bash

# Exit on error
set -e

# Create Android directory if it doesn't exist
echo "Setting up Android Gradle environment..."
mkdir -p android/app

# Run capacitor add android to ensure Android platform is added
echo "Adding Android platform if not present..."
npx cap add android

# Make sure we have the latest capacitor.config.json
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

# Sync with Capacitor to ensure Android project is up to date
echo "Syncing with Capacitor..."
npx cap sync android

# Check if gradlew exists
if [ ! -f "android/gradlew" ]; then
  echo "Creating Gradle wrapper..."
  cd android
  gradle wrapper
  cd ..
fi

# Ensure gradlew is executable
echo "Making gradlew executable..."
chmod +x android/gradlew

# Copy gradlew to the root for some CI systems that expect it there
cp android/gradlew .
cp -r android/gradle .

echo "✅ Android Gradle setup complete!"
echo "You can now build the Android app using:"
echo "./gradlew assembleDebug    # For debug APK"
echo "./gradlew assembleRelease  # For release APK (requires signing)"
