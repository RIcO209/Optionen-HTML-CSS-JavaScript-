// Einstellungen-Modul

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
export function loadSettings() {
    const savedSettings = localStorage.getItem("settings");
    return savedSettings ? JSON.parse(savedSettings) : defaultSettings;
}

// Einstellungen anwenden
export function applySettings(settings) {
    // Lautstärke (Beispiel: Audio-Elemente)
    const audioElements = document.querySelectorAll("audio");
    audioElements.forEach((audio) => {
        audio.volume = settings.audio.volume / 100;
    });

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

    // Sprache (Beispiel: Texte ändern)
    const languageText = {
        de: "Hallo! Willkommen.",
        en: "Hello! Welcome.",
    };
    document.title = languageText[settings.language.language];
}

// Modul initialisieren
export function initializeSettings() {
    const settings = loadSettings();
    applySettings(settings);
}
