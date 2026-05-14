#!/bin/bash
# ImmoPixels auto-deploy script

DEPLOY_DIR="/Users/cdpic/Pictures/IP CRM/board-deploy"
DOWNLOADS="$HOME/Downloads"

# Legfrissebb immopixels-board*.html
LATEST=$(ls -t "$DOWNLOADS"/immopixels-board*.html 2>/dev/null | head -1)

if [ -z "$LATEST" ]; then
  echo "❌ Nem találok immopixels-board.html fájlt a Downloads mappában!"
  exit 1
fi

echo "📄 Fájl: $LATEST"

# Verziószám + timestamp beírása
VERSION="v$(date '+%Y-%m-%d %H:%M')"
sed -i '' "s|v[0-9]\+\.[0-9]\+ · [0-9-]* [0-9:]*|${VERSION}|g" "$LATEST"

cp "$LATEST" "$DEPLOY_DIR/index.html"
cd "$DEPLOY_DIR"
git add .
git diff --cached --quiet && echo "⚠️  Nincs változás." && exit 0
git commit -m "deploy ${VERSION}"
git push
echo "✅ Kész! → https://immopixels-board.vercel.app"
echo "🕐 Verzió: ${VERSION}"
