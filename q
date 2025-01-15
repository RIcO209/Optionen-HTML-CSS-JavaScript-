Hier ist die erweiterte Version des Programms, in der die Kellner nun Bestellungen aufnehmen und anzeigen, wer welches Getränk bestellt hat.

---

### **1. Getränke hinzufügen (`Drink.java`)**
#### `Drink.java`
```java
public class Drink {
    private String name;

    public Drink(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public static Drink randomDrink() {
        String[] drinks = {"Bier", "Cocktail", "Wein", "Wasser", "Whisky"};
        int index = (int) (Math.random() * drinks.length);
        return new Drink(drinks[index]);
    }
}
```

---

### **2. Erweiterung von `Person`**
Jede Person kann jetzt ein Getränk bestellen.

#### `Person.java`
```java
public class Person {
    private String name;
    private Drink drink; // Getränk der Person

    // Liste vorgefertigter Namen
    private static final List<String> NAMES = Arrays.asList(
        "Anna", "Ben", "Clara", "David", "Elisa",
        "Felix", "Gina", "Hans", "Iris", "Jonas"
    );

    public Person(String name) {
        this.name = name;
    }

    public static Person createRandomPerson() {
        Random random = new Random();
        String name = NAMES.get(random.nextInt(NAMES.size()));
        return new Person(name);
    }

    public String getName() {
        return name;
    }

    public void orderDrink() {
        this.drink = Drink.randomDrink();
    }

    public String getDrink() {
        return drink != null ? drink.getName() : "nichts";
    }
}
```

#### `VIP.java` (unverändert)
VIPs erben weiterhin von `Person` und können ebenfalls Getränke bestellen.

---

### **3. Erweiterung von `Waiter`**
Der Kellner nimmt Bestellungen auf und gibt aus, wer welches Getränk bestellt hat.

#### `Waiter.java`
```java
import java.util.List;

public class Waiter {
    public void takeOrders(List<Person> guests, List<Table> tables) {
        for (Table table : tables) {
            for (Person person : table.getOccupants()) {
                if (person.getDrink().equals("nichts")) { // Nur, wenn die Person noch nichts bestellt hat
                    person.orderDrink();
                    System.out.println("Kellner hat " + person.getName() + " ein " + person.getDrink() + " gebracht.");
                }
            }
        }
    }
}
```

---

### **4. Tische mit Gästen**
Die Tische wurden erweitert, um die Besetzung zu verwalten.

#### `Table.java`
```java
import java.util.ArrayList;
import java.util.List;

public class Table {
    private static final int MAX_SEATS = 4;
    private List<Person> occupants = new ArrayList<>();

    public boolean addPerson(Person person) {
        if (occupants.size() < MAX_SEATS) {
            occupants.add(person);
            return true;
        }
        return false;
    }

    public void removePerson() {
        if (!occupants.isEmpty()) {
            occupants.remove(0); // Entferne die erste Person
        }
    }

    public List<Person> getOccupants() {
        return occupants;
    }

    public boolean isAvailable() {
        return occupants.size() < MAX_SEATS;
    }
}
```

---

### **5. Integration in `BarSimulator`**
Der Kellner übernimmt jetzt die Bestellungen, während die Simulation läuft.

#### `BarSimulator.java`
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

                // Kellner nimmt Bestellungen auf
                bar.simulateActivities();

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

### **Funktionsweise**
1. **Bestellungen**: Personen, die an einem Tisch sitzen, bestellen zufällig ein Getränk, wenn sie noch nichts bestellt haben.
2. **Getränkeauswahl**: Es gibt zufällig gewählte Getränke wie Bier, Cocktail, Wein, Wasser und Whisky.
3. **Kellner**: Der Kellner nimmt Bestellungen auf und gibt in der Konsole aus, wer welches Getränk erhalten hat.
4. **Echtzeitbetrieb**: Personen bewegen sich in die Bar hinein und heraus, und die Kellneraktivität läuft parallel zum Sänger.

---

### **Beispielausgabe**
```plaintext
Anna betritt die Bar.
Kellner hat Clara ein Bier gebracht.
Kellner hat David ein Wasser gebracht.
Der Sänger tritt auf mit dem Instrument: Gitarre.
Ben betritt die Bar.
Kellner hat Ben ein Cocktail gebracht.
Elisa konnte nicht eintreten (Bar voll).
Hans verlässt die Bar.
```

Lass mich wissen, ob weitere Funktionen ergänzt werden sollen!