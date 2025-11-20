#!/bin/bash
##############################################################################
# CSS Compilation Fix Script for www.depositotrujillo.co
# This script will fix the missing styles-m.css issue
##############################################################################

set -e  # Exit on error

MAGENTO_ROOT="/home/deptrujillob2c/public_html"
PHP_BIN="/usr/local/bin/php"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================================================="
echo "  CSS Compilation Fix - www.depositotrujillo.co"
echo "========================================================================="
echo ""

# Change to Magento root
cd "$MAGENTO_ROOT" || exit 1

# Check current mode
echo -e "${YELLOW}Step 1: Checking current deployment mode...${NC}"
CURRENT_MODE=$($PHP_BIN bin/magento deploy:mode:show)
echo "Current mode: $CURRENT_MODE"
echo ""

# Ensure we're in developer mode for CSS generation
if [[ ! $CURRENT_MODE =~ "developer" ]]; then
    echo -e "${YELLOW}Switching to developer mode for CSS generation...${NC}"
    $PHP_BIN bin/magento deploy:mode:set developer
    echo -e "${GREEN}✓ Switched to developer mode${NC}"
    echo ""
fi

# Step 2: Deep clean
echo -e "${YELLOW}Step 2: Cleaning static files and cache...${NC}"
echo "This may take a moment..."

# Clean frontend static files
rm -rf pub/static/frontend/Olegnax/* 2>/dev/null || true
echo "  ✓ Removed pub/static/frontend/Olegnax/*"

# Clean preprocessed files
rm -rf var/view_preprocessed/css/* 2>/dev/null || true
rm -rf var/view_preprocessed/pub/* 2>/dev/null || true
echo "  ✓ Removed var/view_preprocessed/*"

# Clean cache
rm -rf var/cache/* 2>/dev/null || true
rm -rf var/page_cache/* 2>/dev/null || true
echo "  ✓ Removed var/cache/*"

# Clean Magento cache via CLI
$PHP_BIN bin/magento cache:clean
$PHP_BIN bin/magento cache:flush
echo -e "${GREEN}✓ Cache cleaned${NC}"
echo ""

# Step 3: Deploy static content
echo -e "${YELLOW}Step 3: Deploying static content...${NC}"
echo "This will compile all LESS files to CSS..."
echo ""

# Deploy static content for Olegnax/athlete2 theme
$PHP_BIN bin/magento setup:static-content:deploy en_US \
    --force \
    --theme Olegnax/athlete2 \
    --area frontend \
    --jobs 4 \
    --no-parent \
    2>&1 | grep -E "(Successful|styles-m|styles-l|ERROR|WARNING|Progress)" || true

echo ""
echo -e "${GREEN}✓ Static content deployment completed${NC}"
echo ""

# Step 4: Verify CSS files were created
echo -e "${YELLOW}Step 4: Verifying CSS files...${NC}"

LOCALE_PATH=$(find pub/static/frontend/Olegnax/athlete2 -type d -name "en_US" | head -1)

if [ -z "$LOCALE_PATH" ]; then
    echo -e "${RED}✗ ERROR: Could not find locale directory${NC}"
    exit 1
fi

echo "Checking in: $LOCALE_PATH/css/"

# Check for styles-m.css
if [ -f "$LOCALE_PATH/css/styles-m.css" ]; then
    SIZE_M=$(stat -f%z "$LOCALE_PATH/css/styles-m.css" 2>/dev/null || stat -c%s "$LOCALE_PATH/css/styles-m.css" 2>/dev/null)
    echo -e "  ${GREEN}✓ styles-m.css found: $(numfmt --to=iec-i --suffix=B $SIZE_M 2>/dev/null || echo "$SIZE_M bytes")${NC}"
else
    echo -e "  ${RED}✗ styles-m.css NOT found!${NC}"
fi

# Check for styles-l.css
if [ -f "$LOCALE_PATH/css/styles-l.css" ]; then
    SIZE_L=$(stat -f%z "$LOCALE_PATH/css/styles-l.css" 2>/dev/null || stat -c%s "$LOCALE_PATH/css/styles-l.css" 2>/dev/null)
    echo -e "  ${GREEN}✓ styles-l.css found: $(numfmt --to=iec-i --suffix=B $SIZE_L 2>/dev/null || echo "$SIZE_L bytes")${NC}"
else
    echo -e "  ${RED}✗ styles-l.css NOT found!${NC}"
fi

echo ""

# Step 5: Set proper permissions
echo -e "${YELLOW}Step 5: Setting proper permissions...${NC}"
chmod -R 755 pub/static/frontend/Olegnax 2>/dev/null || true
chmod -R 644 pub/static/frontend/Olegnax/athlete2/*/css/*.css 2>/dev/null || true
echo -e "${GREEN}✓ Permissions set${NC}"
echo ""

# Step 6: Test CSS accessibility
echo -e "${YELLOW}Step 6: Testing CSS file accessibility...${NC}"

# Get the theme version directory
THEME_VERSION=$(ls -1 pub/static/frontend/Olegnax/athlete2/ | grep -E '^[0-9]+$' | head -1)

if [ -n "$THEME_VERSION" ]; then
    CSS_URL_M="https://www.depositotrujillo.co/static/frontend/Olegnax/athlete2/${THEME_VERSION}/en_US/css/styles-m.css"
    CSS_URL_L="https://www.depositotrujillo.co/static/frontend/Olegnax/athlete2/${THEME_VERSION}/en_US/css/styles-l.css"

    echo "Testing URLs:"
    echo "  Mobile CSS: $CSS_URL_M"

    HTTP_CODE_M=$(curl -s -o /dev/null -w "%{http_code}" "$CSS_URL_M")
    if [ "$HTTP_CODE_M" = "200" ]; then
        echo -e "    ${GREEN}✓ HTTP $HTTP_CODE_M - OK${NC}"
    else
        echo -e "    ${RED}✗ HTTP $HTTP_CODE_M - FAILED${NC}"
    fi

    echo "  Desktop CSS: $CSS_URL_L"
    HTTP_CODE_L=$(curl -s -o /dev/null -w "%{http_code}" "$CSS_URL_L")
    if [ "$HTTP_CODE_L" = "200" ]; then
        echo -e "    ${GREEN}✓ HTTP $HTTP_CODE_L - OK${NC}"
    else
        echo -e "    ${RED}✗ HTTP $HTTP_CODE_L - FAILED${NC}"
    fi
fi

echo ""
echo "========================================================================="
echo -e "${GREEN}CSS FIX COMPLETE!${NC}"
echo "========================================================================="
echo ""
echo "Next steps:"
echo "1. Visit https://www.depositotrujillo.co in a browser"
echo "2. Hard refresh (Ctrl+Shift+R or Cmd+Shift+R)"
echo "3. Check if the website styling looks correct"
echo ""
echo "If styles still don't load:"
echo "  - Check browser console for CSS errors (F12)"
echo "  - Try clearing browser cache completely"
echo "  - Run: php bin/magento cache:flush"
echo ""
