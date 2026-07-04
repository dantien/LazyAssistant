# LazyAssistant v5.1 - The Ultimate WotLK Macro Engine & Execute HUD

LazyAssistant is a lightweight, high-performance, and modular macro pre-processor and execution engine designed specifically for **World of Warcraft: Wrath of the Lich King (3.3.5a)** (e.g., ChromieCraft). It bypasses standard game limitations, such as the 255-character macro length limit, and introduces modern combat features like a customizable execute warning HUD and a draggable minimap settings cogwheel.

> [!NOTE]
> For a detailed guide on troubleshooting macro execution, self-cast redirects, or modifier conflicts, see the [TROUBLESHOOTING.md](file:///home/terjep/Games/ChromieCraft_3.3.5a/Interface/AddOns/LazyAssistant/TROUBLESHOOTING.md) file.

---

## 🚀 Key Features

### 1. 📜 Infinite Length Macros (Bypass 255-Char Limit)
Standard WoW macros restrict you to 255 characters. LazyAssistant works as a secure pre-processor, allowing you to write sequences of unlimited length. Focus on your rotations, pet commands, and safety checks without running out of space.

### 2. 🎯 Customizable Tab Renaming
You get 5 macro slots per character class (bindable using `/click LazyButton1` to `/click LazyButton5`). You can now rename these tabs (which default to `MAIN`, `AOE`, `PANIC`, `CC`, `BURST`) to whatever fits your playstyle (e.g., `PET` or `PULL`). 
* Simply type the name in the **Tab Name** input field at the bottom of the editor and click **Save**. Names are stored separately per character class!

### 3. ⚙️ Draggable Minimap Button
A golden settings cogwheel on your minimap border gives you instant control without typing chat commands:
* **Left-Click:** Open or close the LazyAssistant macro editor.
* **Right-Click:** Toggle the Execute HUD alerts on or off.
* **Left-Click & Drag:** Drag the button smoothly along the border of the minimap to keep it aligned and prevent overlaps with other addons.

### 4. ⚡ Execute Warning HUD (0% Addon Conflict)
An eye-catching, highly readable HUD display that flashes when your target enters execution health range:
* **Hunter (< 20%):** `>>> USE KILL SHOT (ALT) <<<` (Neon Green)
* **Warrior (< 20%):** `>>> USE EXECUTE (SHIFT) <<<` (Crimson Red)
* **Paladin (< 35%):** `>>> USE HAMMER OF WRATH (CTRL) <<<` (Golden Yellow)

#### 🛡️ Modern Features of the HUD:
* **Pre-Warning (5% Buffer):** Flashes a yellow silent warning (e.g., `>>> KILL SHOT SOON (25%) <<<`) when your target is 5% away from execute range. This allows you to stop casting long filler spells (like *Steady Shot*) and prepare your thumb on the modifier key!
* **Ultra-Readable Styling:** Rendered at 26px with a dark `THICKOUTLINE` border for maximum contrast against spell effects and bright backgrounds.
* **Zero Addon Interference:** Operates on its own dedicated frame (`LazyAlertFrame`). Takers like DBM or BigWigs will never have their boss alerts cut off or blocked.
* **Forced Auto-Hide:** Disappears cleanly after exactly 1.2 seconds to prevent screen clutter in fast-paced combat.

---

## 🛠️ How to Setup

1. **Install:** Ensure the `LazyAssistant` folder is in your `Interface/AddOns/` directory.
2. **Create Macro:** Create a standard macro in WoW:
   ```lua
   #showtooltip
   /click LazyButton1
   ```
3. **Action Bar:** Drag this macro to your spam button on your Action Bar (e.g., Key `1`).
4. **Configure:** Click the Minimap Cogwheel or type `/la` to open the editor. Write your rotation and click **Save**.

---

## 🏷️ Smart Tags Reference

You can use these generic tags in your macros, which translate automatically to the correct ability based on your class:

| Tag | Hunter | Priest | Warrior |
| :--- | :--- | :--- | :--- |
| `@EXECUTE` | Kill Shot | SW: Death | Execute |
| `@BIG_CD` | Bestial Wrath | Power Infusion | Recklessness |
| `@INTERRUPT`| Silencing Shot | Silence | Pummel |
| `@MISDIRECT`| Misdirection (@pet)| - | - |

---

## ⌨️ Command Line Reference

* `/la` — Toggles the main macro editor GUI.
* `/la alerts` — Manually enables or disables the Execute HUD alerts and warnings.
* `/la minimap` — Shows or hides the minimap button.

*Enjoy your Lazy Life!*
