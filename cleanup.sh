#!/bin/bash

# 🧹 Letting Experts Deep Clean Script
# This script reclaims disk space by removing redundant developer caches and build artifacts.
# Total estimated recovery: ~3.4GB

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Starting Workspace Deep Clean ===${NC}"

# 1. Flutter Clean (Project Level)
echo -e "\n${BLUE}[1/5] Cleaning Flutter Build Artifacts...${NC}"
flutter clean
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✔ Project build artifacts removed.${NC}"
else
    echo -e "${RED}✘ flutter clean failed. Skipping...${NC}"
fi

# 2. Pub Cache Clean
echo -e "\n${BLUE}[2/5] Cleaning Pub Cache...${NC}"
echo "This will remove all downloaded package sources. They will be re-downloaded on next 'pub get'."
flutter pub cache clean --force
echo -e "${GREEN}✔ Pub cache cleared.${NC}"

# 3. Gradle Cache (Android)
echo -e "\n${BLUE}[3/5] Cleaning Gradle Cache (~1.6GB)...${NC}"
if [ -d "$HOME/.gradle" ]; then
    rm -rf "$HOME/.gradle"
    echo -e "${GREEN}✔ Gradle cache removed.${NC}"
else
    echo "No Gradle cache found."
fi

# 4. Xcode DerivedData (iOS/macOS)
echo -e "\n${BLUE}[4/5] Cleaning Xcode DerivedData (~92MB)...${NC}"
if [ -d "$HOME/Library/Developer/Xcode/DerivedData" ]; then
    rm -rf "$HOME/Library/Developer/Xcode/DerivedData"
    echo -e "${GREEN}✔ Xcode DerivedData removed.${NC}"
else
    echo "No Xcode DerivedData found."
fi

# 5. General System Caches
echo -e "\n${BLUE}[5/5] Cleaning General User Caches (~1.3GB)...${NC}"
if [ -d "$HOME/Library/Caches" ]; then
    # We only remove contents to keep the directory structure
    rm -rf "$HOME/Library/Caches"/*
    echo -e "${GREEN}✔ General caches cleared.${NC}"
else
    echo "No general caches found."
fi

echo -e "\n${GREEN}=== 🧹 Workspace Cleaned! Recovered estimated 3.4GB ===${NC}"
echo -e "${BLUE}Note: Your next build might take longer as it re-downloads dependencies.${NC}"
