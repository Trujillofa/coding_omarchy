# CSS Compilation Fix for www.depositotrujillo.co

## Problem Summary
The website is missing `styles-m.css` (mobile/base CSS), causing the site to not display correctly. The `styles-l.css` (desktop CSS) works fine, but the mobile version fails to compile.

## Root Cause
The `styles-m.less` file imports `source/_reset.less` which contains LESS guards (`& when (@media-common = true)`) that require proper variable definition during compilation. Magento's static content deployment needs to be run to properly compile all LESS files with correct variables.

## Solution
Deploy static content properly to compile all CSS files including `styles-m.css`.

---

## Quick Fix (RECOMMENDED)

### Step 1: Pull these scripts from the repository
```bash
cd /home/deptrujillob2c/public_html
git pull origin claude/continue-session-analysis-012Zwf8nxov3eLZeeQ45qLvM
```

### Step 2: Run the fix script
```bash
cd /home/deptrujillob2c/public_html
bash css_fix_scripts/deploy_css_fix.sh
```

This will:
1. ✓ Clean all static files and cache
2. ✓ Deploy static content with proper LESS compilation
3. ✓ Verify CSS files were created
4. ✓ Test CSS file accessibility

---

## Diagnostic Script (Optional)

If you want to diagnose the issue first before applying the fix:

```bash
cd /home/deptrujillob2c/public_html
php css_fix_scripts/fix_css_compilation.php
```

This will show you:
- Current LESS file contents
- Manual LESS compilation test results
- Existing CSS file status
- Detailed diagnostic information

---

## Manual Fix (If Scripts Don't Work)

If the automated scripts don't work for any reason, run these commands manually:

```bash
cd /home/deptrujillob2c/public_html

# 1. Clean cache and static files
php bin/magento cache:clean
php bin/magento cache:flush
rm -rf pub/static/frontend/Olegnax/*
rm -rf var/view_preprocessed/*
rm -rf var/cache/*

# 2. Deploy static content
php bin/magento setup:static-content:deploy en_US \
    --force \
    --theme Olegnax/athlete2 \
    --area frontend \
    --jobs 4

# 3. Verify files were created
find pub/static/frontend/Olegnax/athlete2 -name "styles-*.css" -ls

# 4. Set permissions
chmod -R 755 pub/static/frontend/Olegnax
```

---

## Verification

After running the fix, verify the CSS files:

### 1. Check if files exist
```bash
cd /home/deptrujillob2c/public_html
find pub/static/frontend/Olegnax/athlete2 -name "styles-*.css"
```

You should see both:
- `styles-m.css` (mobile/base CSS)
- `styles-l.css` (desktop CSS)

### 2. Check file sizes
```bash
ls -lh pub/static/frontend/Olegnax/athlete2/*/en_US/css/styles-*.css
```

Both files should be substantial in size (> 100KB each).

### 3. Test in browser
Visit https://www.depositotrujillo.co and check:
- ✓ Page loads without layout issues
- ✓ Fonts and colors display correctly
- ✓ Responsive design works on mobile
- ✓ No CSS 404 errors in browser console (F12)

---

## Troubleshooting

### Issue: "Permission denied" errors
```bash
chmod +x css_fix_scripts/deploy_css_fix.sh
```

### Issue: Static content deployment fails
Try switching to developer mode first:
```bash
php bin/magento deploy:mode:set developer
# Then run the fix script again
```

### Issue: CSS files not accessible via HTTP
Check .htaccess rules:
```bash
cat pub/static/.htaccess
# Should have rules for static.php fallback
```

### Issue: Old CSS is cached
Clear browser cache:
- Chrome/Firefox: Ctrl+Shift+R (Windows) or Cmd+Shift+R (Mac)
- Or use Incognito/Private browsing mode

---

## Files Included

1. **deploy_css_fix.sh** - Automated fix script (bash)
   - Cleans all caches and static files
   - Deploys static content
   - Verifies CSS files
   - Tests HTTP accessibility

2. **fix_css_compilation.php** - Diagnostic script (PHP)
   - Examines LESS files
   - Tests manual LESS compilation
   - Shows current Magento configuration
   - Provides detailed diagnosis

3. **README.md** - This file
   - Complete instructions
   - Troubleshooting guide
   - Verification steps

---

## Expected Results

After successful fix:

```
✓ styles-m.css: ~180-200KB (mobile/base CSS)
✓ styles-l.css: ~190-200KB (desktop CSS)
✓ HTTP 200 response for both CSS files
✓ Website displays correctly on all devices
✓ No CSS-related errors in browser console
```

---

## Questions or Issues?

If you encounter any problems:

1. Run the diagnostic script first:
   ```bash
   php css_fix_scripts/fix_css_compilation.php > diagnosis.txt
   ```

2. Check Magento logs:
   ```bash
   tail -50 var/log/system.log
   tail -50 var/log/exception.log
   ```

3. Verify Magento mode:
   ```bash
   php bin/magento deploy:mode:show
   ```

---

Last updated: 2025-11-20
