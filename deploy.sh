#!/bin/bash

# 🚀 Letting Experts Deployment & Fix Script
# This script automates the steps required to fix environment issues and deploy the application.

# Colors for better visibility
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Starting Letting Experts Deployment Flow ===${NC}"

# 1. Fix Flutter Quarantine (MacOS Specific)
echo -e "\n${BLUE}[1/5] Checking Flutter Permissions...${NC}"
if [ -d "/opt/homebrew/share/flutter" ]; then
    echo -e "Attempting to remove quarantine flag (may ask for password)..."
    sudo xattr -rd com.apple.quarantine /opt/homebrew/share/flutter
else
    echo -e "Flutter directory not found at standard Homebrew path. Skipping quarantine fix."
fi

# 2. Regenerate Package Config
echo -e "\n${BLUE}[2/5] Regenerating Package Configuration...${NC}"
flutter pub get
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✔ Package configuration regenerated successfully.${NC}"
else
    echo -e "${RED}✘ flutter pub get failed. Please check the errors above.${NC}"
    exit 1
fi

# 3. Backend Deployment (Supabase)
echo -e "\n${BLUE}[3/5] Deploying Supabase Backend...${NC}"
if command -v supabase &> /dev/null; then
    echo "Pushing database migrations..."
    supabase db push
    
    echo "Deploying Edge Functions (lead_notify)..."
    supabase functions deploy lead_notify
    
    echo -e "${GREEN}✔ Supabase tasks completed.${NC}"
else
    echo -e "${RED}✘ Supabase CLI not found. Please install it to deploy the backend.${NC}"
fi

# 4. Building Flutter Web
echo -e "\n${BLUE}[4/5] Building Flutter Web Release...${NC}"
flutter build web --release
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✔ Web build completed successfully.${NC}"
else
    echo -e "${RED}✘ Web build failed.${NC}"
    exit 1
fi

# 5. Production Push (Trigger CI/CD)
echo -e "\n${BLUE}[5/5] Pushing to Production...${NC}"
git add .
git commit -m "chore: production deployment $(date +'%Y-%m-%d %H:%M:%S')"
git push origin main

echo -e "\n${GREEN}=== 🚀 Deployment Completed Successfully ===${NC}"
