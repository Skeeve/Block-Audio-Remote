#!/bin/bash

# Definition der Dateinamen
HTML_FILE="blockradio.html"
BOILERPLATE_FILE="injector.js"
OUTPUT_FILE="blockradio.user.js"

# Prüfen, ob beide Quelldateien existieren
if [ ! -f "$HTML_FILE" ]; then
    echo "🚨 Fehler: $HTML_FILE wurde in diesem Ordner nicht gefunden!"
    exit 1
fi

if [ ! -f "$BOILERPLATE_FILE" ]; then
    echo "🚨 Fehler: Boilerplate-Datei $BOILERPLATE_FILE wurde nicht gefunden!"
    exit 1
fi

echo "📦 Lese $HTML_FILE ein und konvertiere in Base64..."

# Kompatibler Base64-Abruf ohne Zeilenumbrüche für macOS
if command -v openssl >/dev/null 2>&1; then
    BASE64_CONTENT=$(openssl base64 -A -in "$HTML_FILE")
else
    BASE64_CONTENT=$(base64 -i "$HTML_FILE" | tr -d '\r\n')
fi

# Version aus dem Zeitstempel des letzten Commits (UTC), damit derselbe Stand
# immer dieselbe Version ergibt. Ohne Git: aktuelle Uhrzeit.
VERSION=$(TZ=UTC git log -1 --format=%cd --date=format-local:%Y.%m.%d.%H%M 2>/dev/null)
if [ -z "$VERSION" ]; then
    VERSION=$(date -u +%Y.%m.%d.%H%M)
fi
echo "🏷️  Version: $VERSION"

echo "🔧 Verschmelze $BOILERPLATE_FILE mit dem Base64-Code zu $OUTPUT_FILE..."

# Wir nutzen Python3, um die Boilerplate einzulesen, den Platzhalter zu ersetzen und das fertige Skript zu schreiben
export B64_INJECT="$BASE64_CONTENT"
export VERSION_INJECT="$VERSION"
python3 -c "
import os
with open('$BOILERPLATE_FILE', 'r', encoding='utf-8') as f:
    text = f.read()
# Ersetzt den Platzhalter in deiner injector.js durch die Base64-Kette
text = text.replace('HIER_DEINE_BASE64_KETTE_EINFUEGEN', os.environ['B64_INJECT'])
text = text.replace('HIER_DIE_VERSION_EINFUEGEN', os.environ['VERSION_INJECT'])
with open('$OUTPUT_FILE', 'w', encoding='utf-8') as f:
    f.write(text)
"

echo "✅ Fertig! Die Datei '$OUTPUT_FILE' wurde erfolgreich erstellt."
echo "👉 Kopiere einfach den Inhalt von '$OUTPUT_FILE' komplett in dein Tampermonkey-Dashboard!"
