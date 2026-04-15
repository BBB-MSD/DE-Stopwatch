
-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Thu, 09 Apr 2026 12:36:10 GMT
-- Request id : cfwk-fed377c2-69d79d3a38e20

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_stopwatch is
end tb_stopwatch;

architecture tb of tb_stopwatch is

    component stopwatch
        port (
              clk         : in std_logic;
              rst         : in std_logic;
              en_100hz    : in std_logic;
              start_pulse : in std_logic;
              stop_pulse  : in std_logic;
              lap_pulse   : in std_logic;
              sw          : in std_logic_vector (3 downto 0);
              disp_c_ones : out unsigned (3 downto 0);
              disp_c_tens : out unsigned (3 downto 0);
              disp_s_ones : out unsigned (3 downto 0);
              disp_s_tens : out unsigned (3 downto 0);
              disp_m_ones : out unsigned (3 downto 0);
              disp_m_tens : out unsigned (3 downto 0);
              disp_h_ones : out unsigned (3 downto 0);
              disp_h_tens : out unsigned (3 downto 0)
            );
    end component;

    signal clk         : std_logic;
    signal rst         : std_logic;
    signal en_100hz    : std_logic;
    signal start_pulse : std_logic;
    signal stop_pulse  : std_logic;
    signal lap_pulse   : std_logic;
    signal sw          : std_logic_vector (3 downto 0);
    signal disp_c_ones : unsigned (3 downto 0);
    signal disp_c_tens : unsigned (3 downto 0);
    signal disp_s_ones : unsigned (3 downto 0);
    signal disp_s_tens : unsigned (3 downto 0);
    signal disp_m_ones : unsigned (3 downto 0);
    signal disp_m_tens : unsigned (3 downto 0);
    signal disp_h_ones : unsigned (3 downto 0);
    signal disp_h_tens : unsigned (3 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    constant EnPeriod : time := 10 ms;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : stopwatch
    port map (clk         => clk,
              rst         => rst,
              en_100hz    => en_100hz,
              start_pulse => start_pulse,
              stop_pulse  => stop_pulse,
              lap_pulse   => lap_pulse,
              sw          => sw,
              disp_c_ones => disp_c_ones,
              disp_c_tens => disp_c_tens,
              disp_s_ones => disp_s_ones,
              disp_s_tens => disp_s_tens,
              disp_m_ones => disp_m_ones,
              disp_m_tens => disp_m_tens,
              disp_h_ones => disp_h_ones,
              disp_h_tens => disp_h_tens);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    en_process : process
        begin
            while TbSimEnded = '0' loop
                en_100hz <= '0';
                wait for EnPeriod - TbPeriod; -- Čaká takmer 10 ms
                en_100hz <= '1';              -- Vystrelí pulz
                wait for TbPeriod;            -- Pulz trvá presne 10 ns (1 takt)
            end loop;
            wait;
        end process;

    stimuli : process
    begin
        -- Inicializácia signálov
        start_pulse <= '0';
        stop_pulse <= '0';
        lap_pulse <= '0';
        sw <= (others => '0');

        -- Reset
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- 1. ŠTART STOPIEK (pulz trvá len 10 ns)
        start_pulse <= '1';
        wait for TbPeriod;
        start_pulse <= '0';

        -- Čakáme 25 ms v reálnom čase (mali by nabehnúť 2 stotiny)
        wait for 1020 ms;

        -- 4. ZASTAVENIE STOPIEK
        stop_pulse <= '1';
        wait for TbPeriod;
        stop_pulse <= '0';
        
        -- Chvíľu počkáme na overenie
        wait for 20 ms;

        -- Ukončenie simulácie (zastaví hodiny a cykly)
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_stopwatch of tb_stopwatch is
    for tb
    end for;
end cfg_tb_stopwatch;