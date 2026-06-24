#!/bin/bash

# 🚀 Letting Experts Full Bootstrap & Run Script
# This script makes the clean codebase completely operational from a fresh state.

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=== Letting Experts: Automated Environment Bootstrap ===${NC}"

# 1. Environment Checks
echo -e "\n${BLUE}[1/4] Checking System Requirements...${NC}"

if ! command -v flutter &> /dev/null; then
    echo -e "${RED}✘ Flutter SDK not found in PATH! Please install Flutter first.${NC}"
    exit 1
fi
echo -e "${GREEN}✔ Flutter is installed.${NC}"

if ! command -v supabase &> /dev/null; then
    echo -e "${YELLOW}! Supabase CLI not found. Local backend cannot be started automatically.${NC}"
    echo "You can install it via: brew install supabase/tap/supabase"
else
    echo -e "${GREEN}✔ Supabase CLI is installed.${NC}"
fi

# 2. Fix macOS Permissions (The Engine Stamp issue)
echo -e "\n${BLUE}[2/4] Applying macOS Sandbox/Quarantine Fixes...${NC}"
FLUTTER_PATH=$(which flutter)
if [[ "$FLUTTER_PATH" == *"/opt/homebrew/share/flutter"* ]]; then
    echo "Detected Homebrew Flutter installation. Attempting to clear quarantine flags (may ask for password)..."
    sudo xattr -rd com.apple.quarantine /opt/homebrew/share/flutter 2>/dev/null || true
    echo -e "${GREEN}✔ Quarantine flags processed.${NC}"
else
    echo -e "Flutter is not in the Homebrew path. Skipping quarantine fix."
fi

# 3. Environment Variable Verification
echo -e "\n${BLUE}[3/4] Verifying Configuration...${NC}"
if [ ! -f .env ]; then
    echo -e "${YELLOW}! .env file not found. Creating a template...${NC}"
    echo "SUPABASE_URL=https://your-project.supabase.co" > .env
    echo "SUPABASE_ANON_KEY=your-anon-key-here" >> .env
    echo -e "${YELLOW}! Please ensure your Supabase keys are correct in the .env file.${NC}"
else
    echo -e "${GREEN}✔ .env file detected.${NC}"
fi

# 4. Bootstrap Frontend & Run
echo -e "\n${BLUE}[4/4] Fetching Dependencies & Launching App...${NC}"

echo "Running flutter pub get..."
flutter pub get

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✔ Dependencies resolved successfully.${NC}"
else
    echo -e "${RED}✘ 'flutter pub get' failed! Please resolve the errors above.${NC}"
    exit 1
fi

echo -e "\n${GREEN}=== 🚀 Environment Ready! Launching Letting Experts ===${NC}"
echo "Waiting for Flutter Daemon. Select a target device if prompted..."

flutter run
