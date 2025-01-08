// Standard-Einstellungen
const defaultSettings = {
    audio: {
        volume: 50,
    },
    display: {
        theme: "light",
    },
    language: {
        language: "de",
    },
};

// Einstellungen laden
function loadSettings() {
    const savedSettings = localStorage.getItem("settings");
    return savedSettings ? JSON.parse(savedSettings) : defaultSettings;
}

// Einstellungen speichern
function saveSettings(settings) {
    localStorage.setItem("settings", JSON.stringify(settings));
}

// Einstellungen anwenden
function applySettings(settings) {
    // Lautstärke
    document.getElementById("volume").value = settings.audio.volume;
    document.getElementById("volume-value").textContent = settings.audio.volume;

    // Thema
    document.body.style.setProperty(
        "--bg-color",
        settings.display.theme === "dark" ? "#333" : "#f5f5f5"
    );
    document.body.style.setProperty(
        "--text-color",
        settings.display.theme === "dark" ? "#f5f5f5" : "#333"
    );
    document.body.style.setProperty(
        "--primary-color",
        settings.display.theme === "dark" ? "#ffcc00" : "#007bff"
    );
    document.getElementById("theme").value = settings.display.theme;

    // Sprache
    const languageText = {
        de: "Hallo! Willkommen.",
        en: "Hello! Welcome.",
    };
    document.title = languageText[settings.language.language];
    document.getElementById("language").value = settings.language.language;
}

// Einstellungen von der UI abrufen
function getSettingsFromUI() {
    return {
        audio: {
            volume: parseInt(document.getElementById("volume").value, 10),
        },
        display: {
            theme: document.getElementById("theme").value,
        },
        language: {
            language: document.getElementById("language").value,
        },
    };
}

// Event-Listener
document.getElementById("save").addEventListener("click", () => {
    const newSettings = getSettingsFromUI();
    saveSettings(newSettings);
    applySettings(newSettings);
    alert("Einstellungen gespeichert!");
});

document.getElementById("reset").addEventListener("click", () => {
    applySettings(defaultSettings);
    saveSettings(defaultSettings);
    alert("Einstellungen zurückgesetzt!");
});

// Lautstärke-Wert aktualisieren
document.getElementById("volume").addEventListener("input", (e) => {
    document.getElementById("volume-value").textContent = e.target.value;
});

// Anwendung starten
document.addEventListener("DOMContentLoaded", () => {
    const settings = loadSettings();
    applySettings(settings);
});
