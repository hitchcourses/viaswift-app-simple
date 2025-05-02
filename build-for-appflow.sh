#!/bin/bash

# Exit on error
set -e

# STEP 1: Clean up directories
echo "Cleaning directories..."
mkdir -p dist/public
rm -rf dist/public/*

# STEP 2: Create index.html in dist directory
echo "Creating index.html..."
cat > dist/index.html << EOL
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ViaSwift</title>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
      background-color: #6f42c1;
      color: white;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      height: 100vh;
      margin: 0;
      text-align: center;
    }
    .logo {
      font-size: 2rem;
      font-weight: bold;
      margin-bottom: 1rem;
    }
    .subtitle {
      margin-bottom: 2rem;
    }
  </style>
</head>
<body>
  <div class="logo">ViaSwift</div>
  <div class="subtitle">Ride-Sharing & Delivery</div>
  <p>Loading application...</p>
</body>
</html>
EOL

# Copy index.html to public directory
cp dist/index.html dist/public/

# STEP 3: Create pro-manifest.json
echo "Creating pro-manifest.json..."
cat > dist/pro-manifest.json << EOL
{
  "name": "ViaSwift",
  "id": "io.viaswift.app",
  "version": "1.0.0"
}
EOL

# Copy pro-manifest.json to public directory
cp dist/pro-manifest.json dist/public/

# STEP 4: Update capacitor.config.json to use correct webDir
echo "Updating capacitor.config.json..."
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

# STEP 5: Create assets directory with minimal CSS and JS
echo "Creating assets..."
mkdir -p dist/assets
cat > dist/assets/index-main.css << EOL
body{font-family:sans-serif;margin:0;padding:0;background:#f7f7f9;color:#333}
.container{max-width:1200px;margin:0 auto;padding:20px}
.btn{display:inline-block;background:#6f42c1;color:#fff;padding:10px 15px;border-radius:4px;text-decoration:none}
.header{background:#6f42c1;color:#fff;padding:20px 0}
.footer{background:#343a40;color:#fff;padding:20px 0;margin-top:30px}
@media (prefers-color-scheme:dark){body{background:#121212;color:#eee}}
EOL

cat > dist/assets/index-main.js << EOL
console.log("ViaSwift Application Loading");
EOL

# Copy assets to public directory
cp -r dist/assets dist/public/

echo "✅ AppFlow build preparation complete!"
echo "The application files have been prepared for AppFlow deployment."
