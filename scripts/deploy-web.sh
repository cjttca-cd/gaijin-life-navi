#!/bin/bash
# Flutter Web Build + Deploy Script
# Patches firebase_core_web Safari bug + adds cache-busting filenames
set -e

PROJECT_DIR="/root/.openclaw/projects/gaijin-life-navi"
APP_DIR="$PROJECT_DIR/app"
DEPLOY_DIR="/var/www/japan-life-navi"
FLUTTER="/root/flutter/bin/flutter"

echo "=== 1. Building Flutter Web ==="
cd "$APP_DIR"
FLUTTER_ALLOW_ROOT=true $FLUTTER build web \
  --dart-define=API_BASE_URL=https://japan-life-navi.nebulainfinity.com \
  --dart-define=TESTFLIGHT_MODE=true \
  --release

echo "=== 2. Patching firebase_core_web Safari bug ==="
# firebase_core_web apps getter crashes on Safari because it only catches
# Chrome's "of undefined" but not Safari's "undefined is not an object"
# Fix: add null check before getApps() call
sed -i 's|try{o=v\.G\.firebase_core\.getApps()|try{if(!v.G.firebase_core)return A.b([],t.Nb);o=v.G.firebase_core.getApps()|' \
  "$APP_DIR/build/web/main.dart.js"

echo "=== 3. Deploying with cache-busting filenames ==="
# Clean deploy dir
rm -rf "$DEPLOY_DIR"/*

# Copy build output
cp -r "$APP_DIR/build/web/"* "$DEPLOY_DIR/"

# Copy static pages (terms, privacy, etc.)
if [ -d "$PROJECT_DIR/static" ]; then
  cp "$PROJECT_DIR/static/"*.html "$DEPLOY_DIR/" 2>/dev/null || true
fi

# Add useLocalCanvasKit to buildConfig
sed -i 's/"engineRevision"/"useLocalCanvasKit":true,"engineRevision"/' \
  "$DEPLOY_DIR/flutter_bootstrap.js"

# Generate hashed filenames
JS_HASH=$(md5sum "$DEPLOY_DIR/main.dart.js" | cut -c1-8)
cp "$DEPLOY_DIR/main.dart.js" "$DEPLOY_DIR/main.dart.${JS_HASH}.js"
sed -i "s|main.dart.js|main.dart.${JS_HASH}.js|g" "$DEPLOY_DIR/flutter_bootstrap.js"

BS_HASH=$(md5sum "$DEPLOY_DIR/flutter_bootstrap.js" | cut -c1-8)
cp "$DEPLOY_DIR/flutter_bootstrap.js" "$DEPLOY_DIR/flutter_bootstrap.${BS_HASH}.js"

# Deploy production index.html
cat > "$DEPLOY_DIR/index.html" << 'INDEXHTML'
<!DOCTYPE html>
<html>
<head>
  <base href="/">
  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <meta name="description" content="Japan Life Navigator - 在日外国人生活指南">
  <meta name="mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="Japan Life Navi">
  <link rel="apple-touch-icon" href="icons/Icon-192.png">
  <link rel="icon" type="image/png" href="favicon.png"/>
  <title>Japan Life Navigator</title>
  <link rel="manifest" href="manifest.json">
  <style>
    body{margin:0;background:#1a1a2e}
    #loading{position:fixed;top:0;left:0;right:0;bottom:0;display:flex;flex-direction:column;justify-content:center;align-items:center;font-family:-apple-system,BlinkMacSystemFont,sans-serif;color:#e0e0e0}
    .spinner{width:40px;height:40px;border:3px solid #333;border-top-color:#6c63ff;border-radius:50%;animation:spin .8s linear infinite}
    #loading p{margin-top:16px;font-size:14px;opacity:.7}
    @keyframes spin{to{transform:rotate(360deg)}}
  </style>
</head>
<body>
  <div id="loading"><div class="spinner"></div><p>Loading...</p></div>
INDEXHTML

echo "  <script src=\"flutter_bootstrap.${BS_HASH}.js\" async></script>" >> "$DEPLOY_DIR/index.html"
echo '</body></html>' >> "$DEPLOY_DIR/index.html"

echo "=== 4. Reloading Nginx ==="
/usr/sbin/nginx -t && systemctl reload nginx

echo ""
echo "✅ Deployed successfully!"
echo "   JS:        main.dart.${JS_HASH}.js"
echo "   Bootstrap: flutter_bootstrap.${BS_HASH}.js"
echo "   URL:       https://japan-life-navi.nebulainfinity.com/"
