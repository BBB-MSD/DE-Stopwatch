library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_driver is
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
end display_driver;

architecture Behavioral of display_driver is
    signal digit_sel : unsigned(2 downto 0) := "000"; -- Výber aktívnej číslice (0 až 7)
    signal current_val : unsigned(3 downto 0);        -- Hodnota, ktorá sa práve zobrazuje
begin

    process(digit_sel, c0, c1, s0, s1, m0, m1, h0, h1)
    begin
        case digit_sel is
            when "000" => current_val <= c0; an <= "11111110"; dp <= '0'; -- Stotiny jednotky (bodka svieti)
            when "001" => current_val <= c1; an <= "11111101"; dp <= '1'; -- Stotiny desiatky
            when "010" => current_val <= s0; an <= "11111011"; dp <= '0'; -- Sekundy jednotky (bodka svieti)
            when "011" => current_val <= s1; an <= "11110111"; dp <= '1'; -- Sekundy desiatky
            when "100" => current_val <= m0; an <= "11101111"; dp <= '0'; -- Minúty jednotky (bodka svieti)
            when "101" => current_val <= m1; an <= "11011111"; dp <= '1'; -- Minúty desiatky
            when "110" => current_val <= h0; an <= "10111111"; dp <= '0'; -- Hodiny jednotky (bodka svieti)
            when "111" => current_val <= h1; an <= "01111111"; dp <= '1'; -- Hodiny desiatky
            when others => current_val <= (others => '0'); an <= "11111111"; dp <= '1';
        end case;
    end process;

    process(current_val)
    begin
        case current_val is
            when "0000" => seg <= "1000000"; -- 0
            when "0001" => seg <= "1111001"; -- 1
            when "0010" => seg <= "0100100"; -- 2
            when "0011" => seg <= "0110000"; -- 3
            when "0100" => seg <= "0011001"; -- 4
            when "0101" => seg <= "0010010"; -- 5
            when "0110" => seg <= "0000010"; -- 6
            when "0111" => seg <= "1111000"; -- 7
            when "1000" => seg <= "0000000"; -- 8
            when "1001" => seg <= "0010000"; -- 9
            when others => seg <= "1111111"; -- Zhasnuté
        end case;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if en_1khz = '1' then
                digit_sel <= digit_sel + 1;
            end if;
        end if;
    end process;

end Behavioral;