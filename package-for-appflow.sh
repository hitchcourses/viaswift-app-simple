#!/bin/bash

# Exit on error
set -e

# Check for Ionic token
if [ -z "$IONIC_TOKEN" ]; then
  echo "Error: IONIC_TOKEN environment variable is not set."
  echo "Please set it with your Ionic AppFlow token."
  exit 1
fi

# Run the build preparation script first
chmod +x fixed-appflow-build.sh
./fixed-appflow-build.sh

# Set up Ionic CLI configuration
echo "Configuring Ionic CLI..."
echo $IONIC_TOKEN > ~/.ionicrc
ionic config set -g backend pro

# Prepare AppFlow package
echo "Preparing AppFlow package..."
rm -rf viaswift_appflow_package.zip

# Create zip package
echo "Creating zip package..."
cd dist
zip -r ../viaswift_appflow_package.zip * -x "*node_modules*" "*android*" "*ios*"
cd ..

# Add capacitor.config.json and package.json to the zip
zip -r viaswift_appflow_package.zip capacitor.config.json package.json

echo "✅ AppFlow package created: viaswift_appflow_package.zip"
echo ""
echo "To upload to AppFlow:"
echo "1. Log in to the AppFlow dashboard at https://dashboard.ionicframework.com"
echo "2. Navigate to your app (io.viaswift.app)"
echo "3. Go to the Packages section and upload viaswift_appflow_package.zip manually"
echo "4. Create a build using this package"
