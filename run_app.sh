#!/bin/bash

# 🚀 Letting Experts Run Script
# This script ensures dependencies are installed and runs the application locally.

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Starting Letting Experts App ===${NC}"

# 1. Fetch Dependencies (Fixes IDE errors after cleanup)
echo -e "\n${BLUE}[1/2] Fetching Dependencies...${NC}"
flutter pub get

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✔ Dependencies resolved successfully.${NC}"
else
    echo -e "${RED}✘ 'flutter pub get' failed!${NC}"
    echo -e "If you see a 'Permission denied' error on macOS, you may need to run:"
    echo -e "sudo xattr -rd com.apple.quarantine /opt/homebrew/share/flutter"
    exit 1
fi

# 2. Run the Application
echo -e "\n${BLUE}[2/2] Launching Application...${NC}"
echo "Select a device if prompted (e.g., macOS, Chrome, iOS Simulator)."

flutter run

# Note: If you want to automatically run on a specific device, you can change the line above to:
# flutter run -d chrome    # For Web
# flutter run -d macos     # For macOS Desktop
