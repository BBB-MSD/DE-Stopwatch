library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity stopwatch_top is
    Port ( 
        clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        
        -- Tlačidlá
        btn_start : in  STD_LOGIC; 
        btn_stop  : in  STD_LOGIC;
        btn_lap   : in  STD_LOGIC;
        
        -- Prepínače
        sw        : in  STD_LOGIC_VECTOR(3 downto 0);
        
        -- Displej
        seg       : out STD_LOGIC_VECTOR(6 downto 0);
        dp        : out STD_LOGIC;
        an        : out STD_LOGIC_VECTOR(7 downto 0)
    );
end stopwatch_top;

architecture Behavioral of stopwatch_top is

    -- Vnútorné signály
    signal sig_en_100hz : std_logic;
    signal sig_en_1khz  : std_logic;

    signal sig_start_p  : std_logic;
    signal sig_stop_p   : std_logic;
    signal sig_lap_p    : std_logic;

    signal d_c_ones : unsigned(3 downto 0);
    signal d_c_tens : unsigned(3 downto 0);
    signal d_s_ones : unsigned(3 downto 0);
    signal d_s_tens : unsigned(3 downto 0);
    signal d_m_ones : unsigned(3 downto 0);
    signal d_m_tens : unsigned(3 downto 0);
    signal d_h_ones : unsigned(3 downto 0);
    signal d_h_tens : unsigned(3 downto 0);

    -- Čítač
    component clock_divider
        Port (
            clk      : in  STD_LOGIC;
            rst      : in  STD_LOGIC;
            en_100hz : out STD_LOGIC;
            en_1khz  : out STD_LOGIC
        );
    end component;

    -- Debouncer
    component debounce
        port (
            clk         : in  std_logic;
            en_100hz    : in  std_logic;
            rst         : in  std_logic;
            btn_in      : in  std_logic;
            btn_pulse   : out std_logic  
        );
    end component;

    -- Core
    component stopwatch
        Port ( 
            clk         : in STD_LOGIC;
            rst         : in STD_LOGIC;
            en_100hz    : in STD_LOGIC;
            start_pulse : in STD_LOGIC;
            stop_pulse  : in STD_LOGIC;
            lap_pulse   : in STD_LOGIC;
            sw          : in STD_LOGIC_VECTOR(3 downto 0); 
            disp_c_ones : out unsigned(3 downto 0);
            disp_c_tens : out unsigned(3 downto 0);
            disp_s_ones : out unsigned(3 downto 0);
            disp_s_tens : out unsigned(3 downto 0);
            disp_m_ones : out unsigned(3 downto 0);
            disp_m_tens : out unsigned(3 downto 0);
            disp_h_ones : out unsigned(3 downto 0);
            disp_h_tens : out unsigned(3 downto 0)
        );
    end component;

    -- Displej
    component display_driver
        Port (
            clk      : in  STD_LOGIC;
            en_1khz  : in  STD_LOGIC;
            c0       : in unsigned(3 downto 0);
            c1       : in unsigned(3 downto 0);
            s0       : in unsigned(3 downto 0);
            s1       : in unsigned(3 downto 0);
            m0       : in unsigned(3 downto 0);
            m1       : in unsigned(3 downto 0);
            h0       : in unsigned(3 downto 0);
            h1       : in unsigned(3 downto 0);
            seg      : out STD_LOGIC_VECTOR(6 downto 0);
            dp       : out STD_LOGIC;
            an       : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

begin

    Divider: clock_divider port map (
        clk      => clk,
        rst      => reset,
        en_100hz => sig_en_100hz,
        en_1khz  => sig_en_1khz
    );

    Debouncer_Start: debounce port map (
        clk         => clk,
        en_100hz    => sig_en_100hz,
        rst         => reset,
        btn_in      => btn_start,
        btn_pulse   => sig_start_p
    );

    Debouncer_Stop: debounce port map (
        clk         => clk,
        en_100hz    => sig_en_100hz,
        rst         => reset,
        btn_in      => btn_stop,
        btn_pulse   => sig_stop_p
    );

    Debouncer_Lap: debounce port map (
        clk         => clk,
        en_100hz    => sig_en_100hz,
        rst         => reset,
        btn_in      => btn_lap,
        btn_pulse   => sig_lap_p
    );

    Core: stopwatch port map (
        clk         => clk,
        rst         => reset,
        en_100hz    => sig_en_100hz,
        start_pulse => sig_start_p,
        stop_pulse  => sig_stop_p,
        lap_pulse   => sig_lap_p,
        sw          => sw,
        disp_c_ones => d_c_ones,
        disp_c_tens => d_c_tens,
        disp_s_ones => d_s_ones,
        disp_s_tens => d_s_tens,
        disp_m_ones => d_m_ones,
        disp_m_tens => d_m_tens,
        disp_h_ones => d_h_ones,
        disp_h_tens => d_h_tens
    );

    Displej: display_driver port map (
        clk      => clk,
        en_1khz  => sig_en_1khz,
        c0       => d_c_ones, 
        c1       => d_c_tens,
        s0       => d_s_ones, 
        s1       => d_s_tens,
        m0       => d_m_ones, 
        m1       => d_m_tens,
        h0       => d_h_ones, 
        h1       => d_h_tens,
        seg      => seg,
        dp       => dp,
        an       => an
    );

end Behavioral;