#!/bin/bash

# Deployment Script for Globe.dev
# Usage: ./scripts/deploy_globe.sh [Project Name]

echo "🚀 Starting deployment to Globe.dev..."

# 1. Build the project first to bundle 'shared' dependencies
echo "🔨 Building Dart Frog project..."
cd server
dart_frog build
if [ $? -ne 0 ]; then
    echo "❌ Build failed. Please fix errors before deploying."
    exit 1
fi

# 2. Navigate to the build directory (which is self-contained)
cd build

# Restore globe.yaml if we have it saved
if [ -f "../globe.yaml" ]; then
    echo "♻️  Restoring globe.yaml..."
    cp ../globe.yaml .
fi

echo "📦 Deploying form 'server/build'..."
# We deploy the build artifact which has all dependencies locally resolved in .dart_frog_path_dependencies
globe deploy

# Save globe.yaml back to server directory so we don't have to re-link next time
if [ -f "globe.yaml" ]; then
    echo "💾 Saving globe.yaml for future deployments..."
    cp globe.yaml ../globe.yaml
fi

echo "🎉 Deployment command finished."
