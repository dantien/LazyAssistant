# Feilsøking av makroer i LazyAssistant (WotLK 3.3.5a)

Dette dokumentet forklarer de vanligste årsakene til at en automatisk skyte- eller angrepsrotasjon stopper opp, og hvordan du fikser dem.

---

## 1. 🧠 Hovedregelen i WoW-makroer: Én "GCD" per klikk!
Den aller vanligste årsaken til at en makro feiler, er konflikt med den globale nedkjølingstiden (Global Cooldown - GCD).

### Hva er GCD?
Når du kaster de fleste evner (f.eks. `Serpent Sting`, `Steady Shot`, `Arcane Shot`, `Kill Shot`), utløses en global nedkjølingstid på 1.5 sekunder. I løpet av denne tiden kan du ikke kaste andre GCD-baserte formler.

### Hvorfor stopper makroen opp?
WoW utfører makroer linje for linje ovenfra og ned. Hvis du har to evner som begge krever GCD etter hverandre uten betingelser:
```
/cast Misdirection   <-- Krever GCD (på enkelte servere/patcher)
/cast Steady Shot    <-- Krever GCD
```
* **Klikk 1:** Spillet prøver å kaste `Misdirection`. Dette lykkes og starter GCD. Spillet nekter å gå videre til `Steady Shot` på dette klikket.
* **Klikk 2 (Spam):** Spillet ser `/cast Misdirection` igjen. Siden `Misdirection` har 30 sekunder cooldown, feiler forsøket. **Men fordi linjen ble evaluert, stopper spillet å lese makroen videre!** Dermed blir `/cast Steady Shot` aldri nådd, og makroen blir permanent blokkert så lenge Misdirection er på cooldown.

### Løsningen:
* **Off-GCD evner** (som `Bestial Wrath`, `Rapid Fire`, `Kill Command` og trinketer) kan stå fritt fordi de ikke utløser GCD eller blokkerer.
* **GCD-evner** som ikke er en del av den faste rotasjonen (som `Misdirection` eller `Kill Shot`) **må ligge bak en modifikator** (f.eks. `[mod:shift]`), eller legges inn i en `/castsequence`.
  * Eksempel: `/cast [mod:shift] Misdirection` vil kun evalueres hvis du fysisk holder inne Shift-tasten. Hvis du ikke holder Shift, hopper makroen over linjen umiddelbart og går videre til skytingen!

---

## 2. 🚫 De 6 vanligste feilene og hvordan løse dem

### 1. 255-tegnsgrensen i spillet (unfinished string near '<eof>')
* **Symptom:** Du får en Lua-feilmelding i chatten som inneholder `unfinished string near '<eof>'`.
* **Årsak:** WoW sitt chatfelt kutter all tekst etter 255 tegn. Hvis du prøver å skrive en lang `/run LazyButton1:SetAttribute(...)` direkte i chatten, blir den kuttet i to og krasjer.
* **Løsning:** 
  1. Rediger makroer på PC-en din i filen `Templates.lua` og skriv `/reload` i spillet.
  2. Eller åpne addonen med `/la` i spillet. Redigeringsfeltet der har **ingen** tegnbegrensning. Klikk "Save" for å lagre trygt.

### 2. Blindsonen (Dead Zone) for Hunters
* **Symptom:** Karakteren starter Auto Shot eller kaster trinketer, men skyter ingen piler. Ingen feilmeldinger i chatten, men kanskje rød feilskrift på skjermen.
* **Årsak:** I WotLK har Hunters en blindsone mellom 0 og 8 meter. Står du for nær treningsdukken eller fienden, kan du ikke skyte.
* **Løsning:** Rygg godt unna (minst 10-15 meter) før du begynner å teste eller skyte.

### 3. Mangler ammunisjon (No ammo)
* **Symptom:** Rotasjonen stopper opp etter første klikk, og du får feilmeldingen "No ammo" eller "Mangler ammunisjon".
* **Årsak:** Du har gått tom for piler (hvis du bruker bue) eller kuler (hvis du bruker gevær), eller du har utstyrt feil type ammo for våpenet ditt.
* **Løsning:** Sjekk pilhylsteret ditt (quiver) eller ammunisjonsposen din. Kjøp riktig ammunisjon hos en Vendor.

### 4. Mangler fokus (Mana)
* **Symptom:** Karakteren din skyter en giftpil (Serpent Sting), men stopper å skyte Steady Shot etterpå.
* **Årsak:** Steady Shot og Serpent Sting koster mye mana i WotLK. Går du tom for mana, stopper rotasjonen.
* **Løsning:** Bytt til `Aspect of the Viper` for å fylle opp manaen din igjen raskt.

### 5. Pet er død eller ikke kalt ut
* **Symptom:** Makroen prøver å kaste `Kill Command` eller `Call of the Wild`, men ingenting skjer, eller du får feilmeldinger om at du mangler et pet.
* **Årsak:** Evner som `/cast [target=pettarget,exists] Kill Command` krever at peten din lever, er ute, og angriper målet.
* **Løsning:** Bruk `Call Pet` for å hente den frem, eller `Revive Pet` hvis den er død.

### 6. Siktelinje (Line of Sight - LoS)
* **Symptom:** Du får feilmeldingen "Target not in front of you" eller "Out of sight".
* **Årsak:** Karakteren din er snudd feil vei, eller målet står bak en søyle, vegg eller annen hindring.
* **Løsning:** Snu karakteren direkte mot treningsdukken/fienden og sørg for fri siktelinje.

---

## 3. 🔍 Hvordan bruke feilloggen (LazyErrors)
For å hjelpe deg med å finne ut nøyaktig hvorfor en makro stopper opp, har vi laget et eget feilmeldingssystem:

1. **Egen chat-fane:** Addonen oppretter automatisk en chat-fane kalt **`LazyErrors`** i spillet.
2. **Hva logges her?** Her ser du alle klikk-registreringer (grønn skrift) samt alle røde feilmeldinger fra spillet (som "Ability not ready", "Out of range", "Mangler ammunisjon").
3. **Tekstfil på disken:** Hver gang du reloader spillet eller logger ut, lagres alle disse feilmeldingene i filen:
   `WTF/Account/<DITT_NAVN>/SavedVariables/LazyAssistant.lua`
   Denne filen tømmes automatisk hver gang du starter spillet på nytt, slik at den kun viser feil fra den aktive økten din.
