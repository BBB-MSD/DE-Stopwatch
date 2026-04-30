DE-Lap stopwatch

# Športové stopky
---
### Rozdelenie úloh
* [Breza](https://github.com/BBB-MSD) – Programovanie funkcií, video
* [Blumaier](https://github.com/267762) – Top level design, plagát
* [Bednařík](https://github.com/michalbednarik1)– Vymyslenie funkcií programu, blokové schéma, debugging

---

### **Specifikace**
* Vývojové úprostředí - AMD Vivado
* Vývojová deska - Nexys A7-50T (Artix-7)
* Programovací jazyk - VHDL
* Simulace - Behavioral simulator

---

### **Funkcie:**
* 4 buttony – Start, Stop, Reset, Lap
* Ukladacia kapacita 8 lap časov, zobrazenie pomocou 4 switchov. Pri 9. a každom nasledujúcom lap čase začne prepisovať všetky predchádzajúce lap časy počínajúc prvým.
* 24 hodinový formát zobrazujúci hodiny, minúty, sekundy, stotiny
<p align="center">
  <img width="445" height="592" alt="Funkce" src="https://github.com/user-attachments/assets/a687f7db-ad90-43f8-9a8d-162bc7e51dea" />
</p>




---

### Blokové schéma


<p align="center">
  <img width="850" height="550" alt="diagram_stopwatch" src="https://github.com/user-attachments/assets/c64caa09-d930-4827-a6cc-515300765316" />
</p>

--- 

### Video
--- 

<div align="center">
  

https://github.com/user-attachments/assets/09790f46-e5cb-45f9-bb6d-e3da172339c5


</div>

--- 
### Moduly

#### **Debouncer([code](https://github.com/BBB-MSD/DE-Stopwatch/blob/main/Stopwatch/Sources/sources_1/imports/Documents/debounce/debounce.srcs/sources_1/new/debounce.vhd)):**
> [!NOTE]
> Odstraňuje mechanické zákmity tlačítek, aby každé stisknutí vyvolalo právě jednu akci

| Port name | Direction | Type |
| :--- | :---: | :--- |
| `clk` | in | `std_logic` |
| `en_100hz` | in | `std_logic` |
| `rst` | in | `std_logic` |
| `btn_in` | in | `std_logic` |
| `btn_pulse` | out | `std_logic` |



#### **Clock Divider(['code'](https://github.com/BBB-MSD/DE-Stopwatch/blob/main/Stopwatch/Sources/sources_1/new/clock_divider.vhd)):**
> [!NOTE]
> Generuje přesné časové pulzy vysokorychlostních systémových hodin desky

| Port name | Direction | Type |
| :--- | :---: | :--- |
| `clk` | in | `std_logic` |
| `rst` | in | `std_logic` |
| `en_100hz` | out | `std_logic` |
| `en_1khz` | out | `std_logic` |





#### **Stopwatch(['code'](https://github.com/BBB-MSD/DE-Stopwatch/blob/main/Stopwatch/Sources/sources_1/new/stopwatch.vhd)):**
> [!NOTE]
> Obsahuje hlavní logiku čítání času (setiny, sekundy, minuty) a ukládání mezičasů do paměti


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



#### **Display driver(['code'](https://github.com/BBB-MSD/DE-Stopwatch/blob/main/Stopwatch/Sources/sources_1/new/display_driver.vhd)):**
> [!NOTE]
> Ovládá multiplexní přepínání mezi displeji pro zobrazení času a indexu mezičasu


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




#### **Stopwatch_top(['code'](https://github.com/BBB-MSD/DE-Stopwatch/blob/main/Stopwatch/Sources/sources_1/new/stopwatch_top.vhd)):**
> [!NOTE]
> Nejvyšší vrstva, která propojuje všechny vnitřní moduly s fyzickými piny a komponenty desky Nexys A7


| Port name | Direction | Type |
| :--- | :---: | :--- |
| `clk` | in | `std_logic` |
| `reset` | in | `std_logic` |
| `btn_start` | in | `std_logic` |
| `btn_stop` | in | `std_logic` |
| `btn_lap` | in | `std_logic` |
| `sw` | in | `std_logic_vector(3 downto 0)` |
| `seg` | out | `std_logic_vector(6 downto 0)` |
| `dp` | out | `std_logic` |
| `an` | out | `std_logic_vector(7 downto 0)` |

