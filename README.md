# Block SR200 MKII Advanced Remote

Eine schlanke Web-Fernbedienung für das Internetradio **Block Audio SR200 MKII**.
Sie spricht direkt die FSAPI-Schnittstelle (Frontier Silicon) des Radios an und
lässt sich per Userscript als zusätzlicher Menüpunkt **„🎛️ Remote“** in die
Weboberfläche des Radios einblenden.

## Funktionen

- **Power an/aus** mit Statusanzeige
- **Standby-Schutz:** verhindert das automatische Abschalten des Radios im
  Pause-Zustand (alle 10 Minuten kurz stumm „angespielt“, abschaltbar per
  Checkbox)
- **Lautstärke** mit Live-Anzeige und +/−
- **Wiedergabesteuerung:** Zurück, Play, Pause, Weiter
- **DLNA-Medien-Browser** mit Home/Zurück-Navigation, vollständigem Laden
  langer Listen und Echtzeit-Filter nach Titeln
- **Aktuelle Information:** Titel, Interpret, Album, Cover und Tracknummer;
  der gerade laufende Titel wird in der Liste markiert (Aktualisierung alle 4 s)
- **Radioname:** Die Überschrift zeigt den im Radio eingestellten Namen
  (`friendlyName`)

## Dateien

| Datei                 | Zweck                                                                 |
|-----------------------|-----------------------------------------------------------------------|
| `blockradio.html`     | Die eigentliche Fernbedienung (HTML/CSS/JS, eigenständig lauffähig)   |
| `injector.js`         | Userscript-Vorlage mit Platzhalter für die Base64-kodierte HTML-Datei |
| `build-injector.sh`   | Baut aus beiden Dateien das fertige Userscript                        |
| `blockradio.user.js`  | Generiertes Userscript (nicht von Hand bearbeiten)                    |

## Nutzung

### Variante A: Direkt als HTML-Datei

1. In `blockradio.html` IP-Adresse und PIN des Radios anpassen:
   ```js
   const radioIP = "192.168.192.82";
   const pin = "1234";
   ```
2. Datei im Browser öffnen.

### Variante B: Als Userscript in der Radio-Weboberfläche

1. Userscript bauen:
   ```sh
   ./build-injector.sh
   ```
   Das Skript kodiert `blockradio.html` als Base64 und setzt sie in
   `injector.js` ein. Ergebnis ist `blockradio.user.js`.
   Benötigt werden `openssl` (oder `base64`) und `python3`.
2. `blockradio.user.js` in einem Userscript-Manager (z. B. Tampermonkey oder
   Violentmonkey) installieren.
3. Die Weboberfläche des Radios aufrufen (`http://<radio-ip>/web/index.html`).
   In der Navigation erscheint **„🎛️ Remote“** – ein Klick öffnet die
   Fernbedienung in einem Pop-up-Fenster (Pop-up-Blocker ggf. deaktivieren).

Die im HTML hinterlegte IP `192.168.192.82` wird dabei automatisch durch die
IP des aufgerufenen Radios ersetzt – eine Anpassung ist in dieser Variante
nicht nötig. Die PIN muss jedoch weiterhin in `blockradio.html` stimmen.

## Entwicklung

Änderungen immer in `blockradio.html` bzw. `injector.js` vornehmen und
anschließend `./build-injector.sh` erneut ausführen.

## Hinweise

- Die FSAPI wird unverschlüsselt per HTTP angesprochen; die PIN steht im
  Klartext im Code. Nur im heimischen Netz verwenden.
- Getestet mit dem Block Audio SR200 MKII. Andere Geräte mit
  Frontier-Silicon-Chipsatz funktionieren vermutlich ähnlich, sind aber nicht
  getestet.
