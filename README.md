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



<img width="555" height="473" alt="diagram_stopwatch" src="https://github.com/user-attachments/assets/c64caa09-d930-4827-a6cc-515300765316" />

--- 

### Moduly

**Debouncer(['code'](https://github.com/BBB-MSD/DE-Stopwatch/blob/main/Stopwatch/Sources/sources_1/imports/Documents/debounce/debounce.srcs/sources_1/new/debounce.vhd)):**
> [!NOTE]
> ...............................

| Port name | Direction | Type |
| :--- | :---: | :--- |
| `clk` | in | `std_logic` |
| `en_100hz` | in | `std_logic` |
| `rst` | in | `std_logic` |
| `btn_in` | in | `std_logic` |
| `btn_pulse` | out | `std_logic` |



**Clock Divider(['code'](https://github.com/BBB-MSD/DE-Stopwatch/blob/main/Stopwatch/Sources/sources_1/new/clock_divider.vhd)):**

| Port name | Direction | Type |
| :--- | :---: | :--- |
| `clk` | in | `std_logic` |
| `rst` | in | `std_logic` |
| `en_100hz` | out | `std_logic` |
| `en_1khz` | out | `std_logic` |





**Stopwatch:**

| Port name | Direction | Type |
| :--- | :---: | :--- |
| `clk` | in | `std_logic` |
| `rst` | in | `std_logic` |
| `en_100hz` | in | `std_logic` |
| `start_pulse` | in | `std_logic` |
| `stop_pulse` | in | `std_logic` |
| `lap_pulse` | in | `std_logic` |
| `sw` | in | `std_logic_vector(3 downto 0)` |
| `disp_c_ones` | out | `unsigned(3 downto 0)` |
| `disp_c_tens` | out | `unsigned(3 downto 0)` |
| `disp_s_ones` | out | `unsigned(3 downto 0)` |
| `disp_s_tens` | out | `unsigned(3 downto 0)` |
| `disp_m_ones` | out | `unsigned(3 downto 0)` |
| `disp_m_tens` | out | `unsigned(3 downto 0)` |
| `disp_h_ones` | out | `unsigned(3 downto 0)` |
| `disp_h_tens` | out | `unsigned(3 downto 0)` |



**Display driver:**

| Port name | Direction | Type |
| :--- | :---: | :--- |
| `clk` | in | `std_logic` |
| `en_1khz` | in | `std_logic` |
| `c0` | in | `unsigned(3 downto 0)` |
| `c1` | in | `unsigned(3 downto 0)` |
| `s0` | in | `unsigned(3 downto 0)` |
| `s1` | in | `unsigned(3 downto 0)` |
| `m0` | in | `unsigned(3 downto 0)` |
| `m1` | in | `unsigned(3 downto 0)` |
| `h0` | in | `unsigned(3 downto 0)` |
| `h1` | in | `unsigned(3 downto 0)` |
| `seg` | out | `std_logic_vector(6 downto 0)` |
| `dp` | out | `std_logic` |
| `an` | out | `std_logic_vector(7 downto 0)` |
