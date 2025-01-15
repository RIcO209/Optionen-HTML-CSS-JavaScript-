Hier ist die überarbeitete Version von **BarSimulator.java**, die folgende Probleme behebt:

1. Fehler im Hauptprogramm wurden korrigiert.
2. Das Programm läuft jetzt in **Echtzeit**. Der Sänger tritt alle 2 bis 4 Minuten auf, während die Simulation für Personenbewegungen (Betreten/Verlassen) und Aktivitäten regelmäßig fortgesetzt wird.

---

### **1. Überarbeitetes Hauptprogramm (`BarSimulator.java`)**
```java
import java.util.Random;
import java.util.concurrent.TimeUnit;

public class BarSimulator {
    public static void main(String[] args) {
        Bar bar = new Bar();
        Random random = new Random();

        long lastPerformanceTime = System.currentTimeMillis();
        int performanceInterval = 2 + random.nextInt(3); // Intervall: 2 bis 4 Minuten (in Minuten)

        System.out.println("Der Bär-Simulator läuft. Maximal 45 Personen erlaubt.\n");

        while (true) { // Endlosschleife für Echtzeitbetrieb
            try {
                // Simuliere Personenbewegungen (Betreten/Verlassen)
                boolean willEnter = random.nextInt(100) < 80; // 80% Wahrscheinlichkeit, die Bar zu betreten
                if (willEnter) {
                    Person person = random.nextInt(100) < 20 
                        ? VIP.createRandomVIP() 
                        : Person.createRandomPerson();
                    if (bar.enter(person)) {
                        System.out.println(person.getName() + " betritt die Bar.");
                    } else {
                        System.out.println(person.getName() + " konnte nicht eintreten (Bar voll).");
                    }
                } else {
                    bar.leaveRandomPerson();
                }

                // Überprüfe, ob es Zeit für einen Auftritt des Sängers ist
                long currentTime = System.currentTimeMillis();
                if ((currentTime - lastPerformanceTime) >= performanceInterval * 60 * 1000) { // Minuten -> Millisekunden
                    bar.simulateActivities(); // Sänger tritt auf
                    lastPerformanceTime = currentTime;
                    performanceInterval = 2 + random.nextInt(3); // Neues Intervall festlegen
                }

                // Kurze Pause, um Echtzeitbetrieb zu simulieren
                TimeUnit.SECONDS.sleep(1);

            } catch (InterruptedException e) {
                System.out.println("Simulation unterbrochen: " + e.getMessage());
                break;
            }
        }
    }
}
```

---

### **2. Änderungen und Verbesserungen**
1. **Echtzeitbetrieb**:
   - Das Programm läuft in einer Endlosschleife.
   - Aktivitäten (z. B. Personen betreten/Verlassen) finden kontinuierlich statt.
   - Eine Pause von **1 Sekunde** zwischen den Iterationen simuliert den Echtzeitbetrieb.
2. **Zeitbasierter Sänger-Auftritt**:
   - Der Sänger tritt alle **2 bis 4 Minuten** auf.
   - Die Zeit wird durch den Vergleich der aktuellen Zeit mit dem letzten Auftritt berechnet.
3. **Fehlerkorrekturen**:
   - Der Code wurde überprüft, um sicherzustellen, dass Personen korrekt betreten/verlassen und Aktivitäten reibungslos ablaufen.

---

### **Simulationsergebnisse**
Beim Start des Programms wirst du Folgendes sehen:
- Personen versuchen, die Bar zu betreten (mit 80% Wahrscheinlichkeit) oder verlassen diese.
- Der Sänger tritt alle 2 bis 4 Minuten mit einem zufälligen Instrument auf.
- VIPs können Plätze beanspruchen, indem sie andere Personen verscheuchen.

---

### **Frage: Soll die Simulation beendet werden können?**
Wenn du möchtest, dass das Programm z. B. durch eine Benutzereingabe (wie "q" für Quit) beendet wird, kann ich dies hinzufügen. Lass es mich wissen!