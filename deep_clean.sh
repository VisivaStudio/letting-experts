#!/bin/bash

# ☢️ Letting Experts Deep System Purge
# This script deletes EVERYTHING except the Letting Experts project and its operators.
# WARNING: This is IRREVERSIBLE.

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${RED}=== 🚨 WARNING: DEEP SYSTEM PURGE STARTING 🚨 ===${NC}"
echo -e "${YELLOW}This will delete all other projects and system caches.${NC}"

# 1. Delete other project clones
echo -e "\n${BLUE}[1/4] Deleting non-essential projects...${NC}"
rm -rf ~/flutter-codelabs
rm -rf ~/mysample
rm -rf ~/wa_quickstart
rm -rf ~/visiva-web
rm -f "~/Animal Conduct Rules.pdf"
echo -e "${GREEN}✔ Other projects removed.${NC}"

# 2. Clear Downloads & Trash
echo -e "\n${BLUE}[2/4] Clearing Downloads and Trash...${NC}"
rm -rf ~/Downloads/*
rm -rf ~/.Trash/*
echo -e "${GREEN}✔ Downloads and Trash cleared.${NC}"

# 3. Nuke Heavy Dev Caches
echo -e "\n${BLUE}[3/4] Nuking heavy developer caches...${NC}"
rm -rf ~/.gradle
rm -rf ~/.android
rm -rf ~/.pub-cache
rm -rf ~/.dartServer
rm -rf ~/.cache
echo -e "${GREEN}✔ Dev caches nuked.${NC}"

# 4. Clear System/Xcode Caches
echo -e "\n${BLUE}[4/4] Clearing Library Caches...${NC}"
rm -rf ~/Library/Caches/*
rm -rf ~/Library/Developer/Xcode/DerivedData/*
rm -rf ~/Library/Logs/*
echo -e "${GREEN}✔ System caches cleared.${NC}"

echo -e "\n${GREEN}=== 🏁 DEEP PURGE COMPLETE ===${NC}"
df -h ~ | grep -v Filesystem
echo -e "${BLUE}Only 'letting_experts' and your core shell scripts remain.${NC}"
