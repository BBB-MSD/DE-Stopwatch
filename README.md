DE-Stopwatch

### Športové stopky
**Funkcie:**
* 4 buttony – Start, Stop, Reset, Lap
* Ukladacia kapacita 8 lap časov, zobrazenie pomocou 4 switchov. Pri 9. a každom nasledujúcom lap čase začne prepisovať všetky predchádzajúce lap časy počínajúc prvým.
* 24 hodinový formát zobrazujúci hodiny, minúty, sekundy, stotiny

---

### Rozdelenie úloh
* **Breza** – Programovanie funkcií, video
* **Blumaier** – Top level design, prezentácia, plagát
* **Bednařík** – Vymyslenie funkcií programu, blokové schéma, debugging

---

### Blokové schéma


<img width="464" height="399" alt="image" src="https://github.com/user-attachments/assets/6ebb0052-39b5-413b-a837-6164ede068db" />

--- 

### Moduly: 

**Debouncer**

| Port name | Direction | Type | Description |
| :--- | :---: | :--- | :--- |
| `clk` | in | `std_logic` | Main clock |
| `rst` | in | `std_logic` | High-active synchronous reset |
| `data` | in | `std_logic_vector(7 downto 0)` | Vector of input bits, 4 per digit |
| `seg` | out | `std_logic_vector(6 downto 0)` | {a,b,c,d,e,f,g} active-low outputs |
| `anode` | out | `std_logic_vector(1 downto 0)` | Anodes AN1..AN0 (active-low) |
 
