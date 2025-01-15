Hier ist die überarbeitete Version deines Programms, in dem die maximale Kapazität auf 45 Personen erhöht wurde. Außerdem enthält die Datei für Personen bereits 10 vorgefertigte Namen, die zufällig ausgewählt werden können.

---

### **1. Personen mit vorgefertigten Namen (`Person.java`)**
#### `Person.java`
```java
import java.util.Arrays;
import java.util.List;
import java.util.Random;

public class Person {
    private String name;

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
}
```

#### `VIP.java`
```java
import java.util.List;

public class VIP extends Person {
    public VIP(String name) {
        super(name);
    }

    public static VIP createRandomVIP() {
        return new VIP(Person.createRandomPerson().getName() + " (VIP)");
    }

    public void makeSpace(List<Person> guests, List<Table> tables, BarArea barArea, Stage stage) {
        // Priorität 1: Tische
        for (Table table : tables) {
            if (!table.isAvailable()) {
                table.removePerson();
                System.out.println(getName() + " hat jemanden von einem Tisch verscheucht.");
                return;
            }
        }
        // Priorität 2: Bar-Bereich
        if (!barArea.isAvailable()) {
            barArea.removePerson();
            System.out.println(getName() + " hat jemanden aus dem Barbereich verscheucht.");
            return;
        }
        // Priorität 3: Bühne
        if (!stage.isAvailable()) {
            stage.removePerson();
            System.out.println(getName() + " hat jemanden von der Bühne verscheucht.");
        }
    }
}
```

---

### **2. Bar mit maximal 45 Personen (`Bar.java`)**
#### `Bar.java`
```java
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class Bar {
    private static final int MAX_CAPACITY = 45; // Maximal 45 Personen
    private List<Person> guests = new ArrayList<>();
    private BarArea barArea = new BarArea();
    private Stage stage = new Stage();
    private Door door = new Door();
    private List<Table> tables = new ArrayList<>();
    private Waiter waiter;
    private Singer singer;

    public Bar() {
        // Initialisiere Tische
        for (int i = 0; i < 5; i++) {
            tables.add(new Table());
        }
        this.waiter = new Waiter();
        this.singer = new Singer();
    }

    public boolean enter(Person person) {
        if (guests.size() < MAX_CAPACITY) {
            if (person instanceof VIP) {
                ((VIP) person).makeSpace(guests, tables, barArea, stage);
            }
            guests.add(person);
            return true;
        }
        return false;
    }

    public void leaveRandomPerson() {
        if (!guests.isEmpty()) {
            Random random = new Random();
            Person leaving = guests.remove(random.nextInt(guests.size()));
            System.out.println(leaving.getName() + " verlässt die Bar.");
        }
    }

    public void simulateActivities() {
        waiter.takeOrders(guests, tables);
        singer.perform();
    }
}
```

---

### **3. Hauptprogramm mit zufälligen Personen und VIPs**
#### `BarSimulator.java`
```java
import java.util.Random;

public class BarSimulator {
    public static void main(String[] args) {
        Bar bar = new Bar();
        Random random = new Random();

        // Simulation: Personen betreten oder verlassen die Bar
        for (int i = 0; i < 50; i++) { // 50 Runden der Simulation
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
            bar.simulateActivities(); // Simulation: Kellner und Sänger führen Aktionen aus
        }
    }
}
```

---

### **4. Orte unverändert (BarArea, Stage, Door, Table)**

Die Orte bleiben unverändert. Die Klassen verwalten Kapazitäten und Personen wie zuvor. 

---

### **Zusammenfassung**
1. **Maximale Kapazität**: Die Bar erlaubt bis zu **45 Personen**.
2. **10 vorgefertigte Namen**: Diese werden in der Klasse `Person` gespeichert und zufällig ausgewählt.
3. **VIPs und normale Personen**: Es besteht eine 20% Wahrscheinlichkeit, dass eine zufällige Person ein VIP ist.
4. **Hauptprogramm**: Simuliert 50 Runden, in denen Personen die Bar betreten oder verlassen.

Möchtest du weitere Änderungen oder zusätzliche Funktionen, wie z. B. detailliertere Aktivitäten für den Kellner oder Sänger?