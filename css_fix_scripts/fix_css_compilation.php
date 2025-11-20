#!/usr/local/bin/php
<?php
/**
 * Comprehensive CSS Compilation Fix Script
 * Run this directly on the server: php fix_css_compilation.php
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

define('MAGENTO_ROOT', '/home/deptrujillob2c/public_html');
define('THEME_PATH', MAGENTO_ROOT . '/app/design/frontend/Olegnax/athlete2/web/css');

echo "=================================================================\n";
echo "  CSS Compilation Diagnosis and Fix Script\n";
echo "=================================================================\n\n";

// Step 1: Check LESS files
echo "STEP 1: Examining LESS files\n";
echo "-----------------------------------------------------------------\n";

$stylesM = THEME_PATH . '/styles-m.less';
$stylesL = THEME_PATH . '/styles-l.less';
$resetLess = THEME_PATH . '/source/_reset.less';

echo "Checking styles-m.less...\n";
if (file_exists($stylesM)) {
    echo "✓ File exists\n";
    echo "Content:\n";
    echo file_get_contents($stylesM);
    echo "\n";
} else {
    echo "✗ File NOT found!\n";
}

echo "\nChecking source/_reset.less (first 40 lines)...\n";
if (file_exists($resetLess)) {
    echo "✓ File exists\n";
    $lines = file($resetLess);
    echo implode('', array_slice($lines, 0, 40));
    echo "\n";
} else {
    echo "✗ File NOT found!\n";
}

// Step 2: Test LESS compilation
echo "\n=================================================================\n";
echo "STEP 2: Testing LESS Compilation\n";
echo "=================================================================\n\n";

require MAGENTO_ROOT . '/vendor/autoload.php';

// Test 1: Compile styles-m.less WITH @media-common defined
echo "Test 1: Compiling styles-m.less with @media-common = true\n";
echo "-----------------------------------------------------------------\n";
try {
    $parser = new \Less_Parser([
        'compress' => false,
        'sourceMap' => false,
    ]);

    // Define variables before parsing
    $parser->ModifyVars([
        'media-common' => true,
        'media-target' => 'mobile'
    ]);

    $parser->parseFile($stylesM);
    $css = $parser->getCss();

    echo "✓ SUCCESS! Compiled " . number_format(strlen($css)) . " bytes\n";

    if (strlen($css) > 0) {
        echo "First 500 characters:\n";
        echo substr($css, 0, 500) . "\n...\n";
    } else {
        echo "⚠ WARNING: CSS output is EMPTY despite no errors!\n";
    }
} catch (Exception $e) {
    echo "✗ ERROR: " . $e->getMessage() . "\n";
    echo "Exception: " . get_class($e) . "\n";
}

// Test 2: Compile styles-l.less for comparison
echo "\nTest 2: Compiling styles-l.less (comparison)\n";
echo "-----------------------------------------------------------------\n";
try {
    $parser2 = new \Less_Parser([
        'compress' => false,
    ]);

    $parser2->ModifyVars([
        'media-common' => false,
        'media-target' => 'desktop'
    ]);

    $parser2->parseFile($stylesL);
    $css2 = $parser2->getCss();

    echo "✓ SUCCESS! Compiled " . number_format(strlen($css2)) . " bytes\n";
} catch (Exception $e) {
    echo "✗ ERROR: " . $e->getMessage() . "\n";
}

// Step 3: Check Magento mode
echo "\n=================================================================\n";
echo "STEP 3: Checking Magento Configuration\n";
echo "=================================================================\n\n";

chdir(MAGENTO_ROOT);
$mode = shell_exec('/usr/local/bin/php bin/magento deploy:mode:show 2>&1');
echo "Current mode:\n$mode\n";

// Step 4: Check existing CSS files
echo "\n=================================================================\n";
echo "STEP 4: Checking Deployed CSS Files\n";
echo "=================================================================\n\n";

$cssPattern = MAGENTO_ROOT . '/pub/static/frontend/Olegnax/athlete2/*/en_US/css/styles-*.css';
$cssFiles = glob($cssPattern);

echo "Found " . count($cssFiles) . " CSS files:\n";
foreach ($cssFiles as $file) {
    $size = filesize($file);
    $relPath = str_replace(MAGENTO_ROOT . '/pub/static/', '', $file);
    echo "  - $relPath: " . number_format($size) . " bytes\n";
}

// Step 5: Propose fix
echo "\n=================================================================\n";
echo "STEP 5: Proposed Fix\n";
echo "=================================================================\n\n";

echo "Based on the diagnosis above, here's the recommended fix:\n\n";

echo "Option 1: Full Static Content Deployment (RECOMMENDED)\n";
echo "-----------------------------------------------------------------\n";
echo "Run these commands:\n\n";
echo "cd " . MAGENTO_ROOT . "\n";
echo "php bin/magento cache:clean\n";
echo "rm -rf pub/static/frontend/Olegnax/*\n";
echo "rm -rf var/view_preprocessed/*\n";
echo "php bin/magento setup:static-content:deploy en_US -f --theme Olegnax/athlete2 -j 4\n";
echo "php bin/magento cache:flush\n\n";

echo "Option 2: Developer Mode Auto-Generation\n";
echo "-----------------------------------------------------------------\n";
echo "If in developer mode, access the site with different user agents:\n";
echo "- Mobile: https://www.depositotrujillo.co (with mobile user agent)\n";
echo "- Desktop: https://www.depositotrujillo.co (with desktop user agent)\n\n";

echo "Option 3: Manual CSS File Creation (QUICK FIX)\n";
echo "-----------------------------------------------------------------\n";
echo "Create the CSS file manually from the compiled output above\n\n";

echo "\n=================================================================\n";
echo "DIAGNOSIS COMPLETE\n";
echo "=================================================================\n";
