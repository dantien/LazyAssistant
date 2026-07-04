# LazyAssistant Development Handover

**Version:** 5.1
**Target Client:** WotLK 3.3.5a (ChromieCraft)
**Website:** https://wow.autonomina.no

## 🏗️ Architecture Overview
LazyAssistant uses a **modular architecture** to separate UI, logic, and data.

### File Structure
*   **`LazyAssistant.toc`**: Manifest. Controls load order (Utils -> Templates -> DB -> Engine -> UI -> Core).
*   **`Core.lua`**: Bootloader. Handles `ADDON_LOADED` event and initializes modules.
*   **`Database.lua`**: Manages `SavedVariables` (LazyAssistantDB). Handles Dual-Spec logic.
*   **`Engine.lua`**: The "Secure Execution" core. Manages the 5 invisible `SecureActionButtonTemplate` buttons (`LazyButton1-5`). Contains the update logic.
*   **`UI.lua`**: The graphical editor. Handles text input, tab switching (1-5), and saving.
*   **`Templates.lua`**: Contains the hard-coded default rotations for all classes.
*   **`Utils.lua`**: Helper functions. Contains the **Tag Parser** (`@EXECUTE` -> `Kill Shot`) and **ErrorFilter** logic.

## ⚙️ Key Mechanisms

### The "/click" Engine
The addon does NOT cast spells directly (protected). instead, it updates the `macrotext` attribute of secure buttons. The user's macro simply clicks this button:
`/click LazyButton1`

### Smart Tags
We use custom tags in `Utils.lua` to make macros portable across classes:
*   `@EXECUTE` -> Translates to `Kill Shot`, `Execute`, `Shadow Word: Death`.
*   `@BIG_CD` -> `Bestial Wrath`, `Recklessness`.

### Auto-Wrapper
Every macro is automatically wrapped with code to:
1.  Suppress error sounds (`Sound_EnableSFX 0`).
2.  Use Trinkets (`/use 13`, `/use 14`).
3.  Clear error messages (`UIErrorsFrame:Clear()`).

## 🚀 Deployment Workflow (Website)
To release a new version:
1.  **Bump Version:** Update version in `LazyAssistant.toc` and `UI.lua`.
2.  **Zip:** Run the following command:
    ```bash
    sudo rm -f /srv/http/wow/downloads/LazyAssistant-latest.zip
    cd /home/terjep/Games/ChromieCraft_3.3.5a/Interface/AddOns/
    zip -r /srv/http/wow/downloads/LazyAssistant-vX.X.zip LazyAssistant
    ```
3.  **Update Web:** Edit `/srv/http/wow/index.html` to point to the new zip file and update changelogs.

## 🔮 Roadmap (v6.0 Ideas)
*   **WeakAuras Integration:** Export "Next Spell" data to WeakAuras to solve the `#showtooltip` limitation.
*   **Profile Export:** Generate import strings to share rotations.
*   **Conditionals:** A pseudo-code parser (`IF MANA < 20 THEN ...`) that compiles to macro conditionals (`[mana<20]`).

## ⚠️ Known Limitations
*   **#showtooltip:** Standard `/click` macros cannot dynamically update the icon to show the *next* spell in a sequence perfectly. It usually shows the first spell or requires a static icon.
*   **Combat Lockdown:** Macros CANNOT be edited or updated during combat. The UI has safeguards (`InCombatLockdown` check) to prevent Lua errors.

