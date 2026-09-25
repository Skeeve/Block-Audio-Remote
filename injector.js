// ==UserScript==
// @name         Block Audio Remote Injector (Base64)
// @match        http://*/web/index.html
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    setInterval(function() {
        const navBar = document.getElementById('main_navigation');
        
        if (navBar && !document.getElementById('main_navigation_remote')) {
            const li = document.createElement('li');
            const a = document.createElement('a');
            a.href = '#';
            a.id = 'main_navigation_remote';
            a.innerHTML = '<span style="font-size: 80%">🎛️</span> Remote';
            
            li.appendChild(a);
            navBar.appendChild(li);

            a.onclick = function(e) {
                e.preventDefault();
                const radioIP = window.location.hostname;

                // DEINE BASE64-KETTE (Wird vom Bash-Skript unten automatisch befüllt)
                const base64Html = "HIER_DEINE_BASE64_KETTE_EINFUEGEN";

                // Dekodiert die Kette fehlerfrei zurück in echten HTML-Code (UTF-8 geschützt)
                let meinHTMLCode = decodeURIComponent(atob(base64Html).split('').map(function(c) {
                    return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
                }).join(''));

                // Tauscht die feste IP dynamisch gegen die aktuelle IP des Radios aus
                meinHTMLCode = meinHTMLCode.replaceAll('192.168.192.82', radioIP);

                // Erstellt ein sicheres HTML-Datenobjekt direkt unter der Domain des Radios
                const blob = new Blob([meinHTMLCode], { type: 'text/html' });
                const blobUrl = URL.createObjectURL(blob);

                // Öffnet das saubere, rahmenlose Fenster
                const popup = window.open(blobUrl, 'BlockRemotePopup', 'width=380,height=760,menubar=no,toolbar=no,location=no,status=no,resizable=yes,scrollbars=yes');
                if (!popup) return alert("Pop-up-Blocker aktiv! Bitte erlauben.");
            };
        }
    }, 300);
})();
