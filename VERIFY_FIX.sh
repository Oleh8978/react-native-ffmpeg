#!/bin/bash

echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║           Android Autolinking Fix Verification Script              ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0

echo "Checking configuration files..."
echo ""

# Check 1: Java files location
echo -n "1. Java files in correct location... "
if find android/src/main/java/com/arthenica/reactnative/ffmpeg -name "*.java" -type f | grep -q .; then
    echo -e "${GREEN}✓${NC}"
    find android/src/main/java/com/arthenica/reactnative/ffmpeg -name "*.java" | while read f; do echo "   - $(basename "$f")"; done
else
    echo -e "${RED}✗${NC}"
    ERRORS=$((ERRORS+1))
fi
echo ""

# Check 2: Package declarations
echo -n "2. Correct package declarations... "
if grep -r "package com.arthenica.reactnative.ffmpeg;" android/src/main/java/com/arthenica/reactnative/ffmpeg/*.java > /dev/null; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    ERRORS=$((ERRORS+1))
fi
echo ""

# Check 3: react-native.config.js
echo -n "3. react-native.config.js exists... "
if [ -f "react-native.config.js" ]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    ERRORS=$((ERRORS+1))
fi
echo ""

# Check 4: android.json
echo -n "4. android.json exists... "
if [ -f "android.json" ]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    ERRORS=$((ERRORS+1))
fi
echo ""

# Check 5: package.json has rnpm
echo -n "5. package.json has rnpm configuration... "
if grep -q '"rnpm"' package.json; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    ERRORS=$((ERRORS+1))
fi
echo ""

# Check 6: proguard-rules.pro
echo -n "6. android/proguard-rules.pro exists... "
if [ -f "android/proguard-rules.pro" ]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    ERRORS=$((ERRORS+1))
fi
echo ""

# Check 7: build.gradle namespace
echo -n "7. build.gradle has correct namespace... "
if grep -q 'namespace "com.arthenica.reactnative.ffmpeg"' android/build.gradle; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    ERRORS=$((ERRORS+1))
fi
echo ""

# Check 8: RNFFmpegPackage class exists
echo -n "8. RNFFmpegPackage.java is correct... "
if grep -q "public class RNFFmpegPackage implements ReactPackage" android/src/main/java/com/arthenica/reactnative/ffmpeg/RNFFmpegPackage.java; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    ERRORS=$((ERRORS+1))
fi
echo ""

echo "╔════════════════════════════════════════════════════════════════════╗"
if [ $ERRORS -eq 0 ]; then
    echo -e "║  ${GREEN}All checks passed! Ready to test in LVSE project.${NC}       ║"
else
    echo -e "║  ${RED}$ERRORS check(s) failed. Review the fixes above.${NC}              ║"
fi
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

echo "Next steps:"
echo "1. cd LVSE"
echo "2. rm -rf node_modules/@oleh8978/react-native-ffmpeg android/app/build"
echo "3. npm install"
echo "4. cd android && ./gradlew clean && cd .."
echo "5. npx react-native run-android"
echo ""

exit $ERRORS
