# LazyAssistant v5.0 - The Ultimate WotLK Macro Engine

LazyAssistant is a modular, high-performance addon designed for **ChromieCraft (3.3.5a)**. It transforms the way you play by allowing you to create complex, "one-button" rotations that exceed the standard game limitations.

> [!NOTE]
> For a detailed guide on why macros get stuck and how to fix them, see the [TROUBLESHOOTING.md](file:///home/terjep/Games/ChromieCraft_3.3.5a/Interface/AddOns/LazyAssistant/TROUBLESHOOTING.md) file.

### 1. 🧠 Smarter Logic
Standard macros are static and dumb. LazyAssistant acts as a "pre-processor" for your commands.
*   **Auto-Translation:** Write `@EXECUTE` and the addon automatically converts it to `Kill Shot` (Hunter), `Execute` (Warrior), or `Shadow Word: Death` (Priest).
*   **Auto-Safety:** Every macro is automatically wrapped with code to suppress error sounds ("I can't do that yet") and use your Trinkets/Gloves instantly.

### 2. 📜 Infinite Length (No 255 Character Limit)
The built-in macro system limits you to 255 characters. A proper BM Hunter rotation with pet management is easily 400+ chars.
*   **LazyAssistant:** Has **NO LIMIT**. Write as complex a sequence as you need. The addon handles the execution securely.

### 3. ⚡ Instant Editing
*   **Standard:** Open menu -> Find icon -> Edit -> Save -> Drag to bar.
*   **LazyAssistant:** Type `/la`. Edit text. Click Save. Done. Your button on the action bar updates instantly.

## 🛠️ How to Setup

1.  **Install:** Ensure the `LazyAssistant` folder is in `Interface/AddOns/`.
2.  **In-Game:** Create a macro for your main button:
    ```lua
    #showtooltip
    /click LazyButton1
    ```
3.  **Action Bar:** Drag this macro to your spam key (e.g., `1`).
4.  **Edit:** Type `/la` to open the editor window.

## 🎮 Features

*   **5 Unique Buttons:** You have 5 separate macro slots per character (`/click LazyButton1` to `LazyButton5`).
*   **Class Detection:** Automatically loads the correct rotation for Hunter, Priest, Warrior, etc.
*   **Tag System:** Use special tags to make macros portable across characters.

## 🏷️ Smart Tags Reference

Instead of spell names, you can use these tags:

| Tag | Hunter | Priest | Warrior |
| :--- | :--- | :--- | :--- |
| `@EXECUTE` | Kill Shot | SW: Death | Execute |
| `@BIG_CD` | Bestial Wrath | Power Infusion | Recklessness |
| `@INTERRUPT`| Silencing Shot | Silence | Pummel |
| `@MISDIRECT`| Misdirection (@pet)| - | - |

## 🏹 Default Hunter Rotation (Button 1)
Your installation comes pre-loaded with the "Perfect BM Spam":
1.  Auto-Targets enemies.
2.  Auto-Misdirects threat to Pet.
3.  Pet uses Growl (Taunt).
4.  Smart Castsequence: Serpent Sting -> Shots -> Kill Shot (Priority).

*Enjoy your Lazy Life!*
