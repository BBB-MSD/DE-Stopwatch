library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity stopwatch is
    Port ( 
        clk         : in STD_LOGIC;     -- Hlavný hodinový signál --
        rst         : in STD_LOGIC;     -- Tlačidlo reset --
        en_100hz    : in STD_LOGIC;     -- Povoľovací signál pre počítadlo --
        
        -- Pulzy debouncera --
        start_pulse : in STD_LOGIC;
        stop_pulse  : in STD_LOGIC;
        lap_pulse   : in STD_LOGIC;
        
        -- 4 swtiche --
        sw          : in STD_LOGIC_VECTOR(3 downto 0); 
        
        -- 8 číslic vo formáte BCD --
        disp_c_ones : out unsigned(3 downto 0);
        disp_c_tens : out unsigned(3 downto 0);
        disp_s_ones : out unsigned(3 downto 0);
        disp_s_tens : out unsigned(3 downto 0);
        disp_m_ones : out unsigned(3 downto 0);
        disp_m_tens : out unsigned(3 downto 0);
        disp_h_ones : out unsigned(3 downto 0);
        disp_h_tens : out unsigned(3 downto 0)
    );
end stopwatch;

architecture Behavioral of stopwatch is
    signal running : std_logic := '0';
    -- Vnútorné signály, do ktorých počítadlo neustále sype aktuálny živý čas
    signal c_ones : unsigned(3 downto 0);
    signal c_tens : unsigned(3 downto 0);
    signal s_ones : unsigned(3 downto 0);
    signal s_tens : unsigned(3 downto 0);
    signal m_ones : unsigned(3 downto 0);
    signal m_tens : unsigned(3 downto 0);
    signal h_ones : unsigned(3 downto 0);
    signal h_tens : unsigned(3 downto 0);
    
    -- Paměťový array s kapacitou 8 miest pre 4- bitové čísla --
    type mem_array is array (0 to 7) of unsigned(3 downto 0);
    
    -- Vytvárame 8 takýchto polí (pre každú cifru času jedno pole) a hneď ich aj nulujeme.
    signal m_c_ones : mem_array := (others => (others => '0'));
    signal m_c_tens : mem_array := (others => (others => '0'));
    signal m_s_ones : mem_array := (others => (others => '0'));
    signal m_s_tens : mem_array := (others => (others => '0'));
    signal m_m_ones : mem_array := (others => (others => '0'));
    signal m_m_tens : mem_array := (others => (others => '0'));
    signal m_h_ones : mem_array := (others => (others => '0'));
    signal m_h_tens : mem_array := (others => (others => '0'));
    
    -- Počítadlo lapov --
    signal lap_ptr : integer range 0 to 7 := 0;
    
    -- Preklad switchov do čísel --
    signal sw_val   : integer range 0 to 15;
    signal read_idx : integer range 0 to 7;

begin
    time_counter: entity work.counter
        port map (
            clk => clk, 
            rst => rst, 
            en => en_100hz, 
            run => running,
            c_ones => c_ones, 
            c_tens => c_tens,
            s_ones => s_ones, 
            s_tens => s_tens,
            m_ones => m_ones, 
            m_tens => m_tens,
            h_ones => h_ones, 
            h_tens => h_tens
        );
    
    -- Start/Stop/Reset --
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                running <= '0';         -- Reset stopky zastaví
            elsif start_pulse = '1' then
                running <= '1';         -- Pulz Start ich rozbehne
            elsif stop_pulse = '1' then
                running <= '0';         -- Pulz Stop ich pauzne
            end if;
        end if;
    end process;

    -- Lap --
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                -- Pri resete vynulujeme počítadlo a vymažeme všetky pamäte
                lap_ptr <= 0; 
                m_c_ones <= (others => "0000"); 
                m_c_tens <= (others => "0000");
                m_s_ones <= (others => "0000"); 
                m_s_tens <= (others => "0000");
                m_m_ones <= (others => "0000"); 
                m_m_tens <= (others => "0000");
                m_h_ones <= (others => "0000"); 
                m_h_tens <= (others => "0000");
                
            elsif lap_pulse = '1' then
                -- Stlačíme lap a uložíme momentálne hodnoty do paměti --
                m_c_ones(lap_ptr) <= c_ones; 
                m_c_tens(lap_ptr) <= c_tens;
                m_s_ones(lap_ptr) <= s_ones; 
                m_s_tens(lap_ptr) <= s_tens;
                m_m_ones(lap_ptr) <= m_ones; 
                m_m_tens(lap_ptr) <= m_tens;
                m_h_ones(lap_ptr) <= h_ones; 
                m_h_tens(lap_ptr) <= h_tens;
                        
                -- Posunieme miesto v lap paměti, ak sme na poslednom ideme znova od prvého --
                if lap_ptr = 7 then 
                    lap_ptr <= 0; 
                else 
                    lap_ptr <= lap_ptr + 1; 
                end if;
            end if;
        end if;
    end process;

    -- Multiplexer --
    -- Najskôr si preložíme 4-bitový signál z dosky na bežné číslo.
    sw_val <= to_integer(unsigned(sw));
 
    -- Paměť ide od 0 ale čísla od 1 takže musíme dať -1 --
    read_idx <= sw_val - 1 when (sw_val >= 1 and sw_val <= 8) else 0;

    -- V tomto procese sa rozhodujeme čo zobrazíme --
    process(sw_val, read_idx, c_ones, c_tens, s_ones, s_tens, m_ones, m_tens, h_ones, h_tens, 
            m_c_ones, m_c_tens, m_s_ones, m_s_tens, m_m_ones, m_m_tens, m_h_ones, m_h_tens)
    begin
        if sw_val = 0 then
            -- Ak sú všetky prepínače dole (sw = 0000), pošleme na výstup aktuálny čas --
            disp_c_ones <= c_ones; 
            disp_c_tens <= c_tens;
            disp_s_ones <= s_ones; 
            disp_s_tens <= s_tens;
            disp_m_ones <= m_ones; 
            disp_m_tens <= m_tens;
            disp_h_ones <= h_ones; 
            disp_h_tens <= h_tens;
            
        elsif sw_val >= 1 and sw_val <= 8 then
            -- Ak je na prepínačoch navolené číslo 1 až 8, vytiahneme čas z paměti lapov --
            disp_c_ones <= m_c_ones(read_idx); 
            disp_c_tens <= m_c_tens(read_idx);
            disp_s_ones <= m_s_ones(read_idx); 
            disp_s_tens <= m_s_tens(read_idx);
            disp_m_ones <= m_m_ones(read_idx); 
            disp_m_tens <= m_m_tens(read_idx);
            disp_h_ones <= m_h_ones(read_idx); 
            disp_h_tens <= m_h_tens(read_idx);
            
        else
            -- Ak na prepínačoch dáme 9 až 15 tak to dá všade nadefinované pomlčky --
            disp_c_ones <= "1111"; 
            disp_c_tens <= "1111";
            disp_s_ones <= "1111"; 
            disp_s_tens <= "1111";
            disp_m_ones <= "1111"; 
            disp_m_tens <= "1111";
            disp_h_ones <= "1111"; 
            disp_h_tens <= "1111";
        end if;
    end process;

end Behavioral;