library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        en_100hz : out STD_LOGIC;
        en_1khz  : out STD_LOGIC
    );
end clock_divider;

architecture Behavioral of clock_divider is
    signal cnt_1k  : integer range 0 to 99999 := 0;
    signal cnt_100 : integer range 0 to 999999 := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Ak je aktívny reset, všetko vrátime na nulu --
            if rst = '1' then
                cnt_1k   <= 0;
                cnt_100  <= 0;
                en_1khz  <= '0';
                en_100hz <= '0';
            else
                -- 100 000 000 / 100 000 = 1kHz --
                if cnt_1k = 99999 then
                    cnt_1k  <= 0;
                    en_1khz <= '1';
                else
                    cnt_1k  <= cnt_1k + 1;
                    en_1khz <= '0';
                end if;
                -- 100 000 000 / 1 000 000 = 100 Hz
                if cnt_100 = 999999 then
                    cnt_100  <= 0;
                    en_100hz <= '1';
                else
                    cnt_100  <= cnt_100 + 1;
                    en_100hz <= '0';
                end if;
            end if;
        end if;
    end process;
end Behavioral;