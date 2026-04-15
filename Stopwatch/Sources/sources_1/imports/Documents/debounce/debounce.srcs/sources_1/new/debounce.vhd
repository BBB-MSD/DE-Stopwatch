library ieee;
use ieee.std_logic_1164.all;

entity debounce is
    port (
        clk         : in  std_logic;
        en_100hz    : in  std_logic;
        rst         : in  std_logic;
        btn_in      : in  std_logic;
        btn_pulse   : out std_logic  
    );
end entity debounce;

architecture Behavioral of debounce is
    -- Čas stlačenia --
    signal debounce_cnt : integer range 0 to 3 := 0;
    -- Pomocná paměť -- 
    signal btn_state    : std_logic := '0';   

begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- reset celého debouncera --
            if rst = '1' then
                debounce_cnt <= 0;
                btn_state    <= '0';
                btn_pulse    <= '0';
            
            -- riešime zvyšok logiky len vtedy, keď príde 100Hz tik --
            elsif  en_100hz = '1' then
                
                -- Tlačidlo je stlačené --
                if btn_in = '1' then 
                    
                    -- Ešte neubehol dostatočný čas na overenie --
                    if debounce_cnt  < 3 then
                        debounce_cnt <= debounce_cnt + 1;
                        btn_pulse    <= '0'; -- neposielame nič --
                    
                    -- Čas ubehol nič sme ešte neposlali --
                    elsif btn_state = '0' then 
                        btn_state <= '1'; -- Paměť že už sme poslali --
                        btn_pulse <= '1'; -- Posielame pulz --
                    
                    -- Tlačidlo držíme aj keď pulz už je odoslaný --
                    else 
                        btn_pulse <= '0'; -- Nič ďalšie sa neposiela --
                    end if;
                
                -- Nestlačené tlačidlo --
                else
                    debounce_cnt <= 0;   -- Vynulujeme počítadlo --
                    btn_state    <= '0'; -- Vynulujeme paměť --
                    btn_pulse    <= '0'; -- Von nejde žiadny signál -- 
                end if;
            
            -- Vo všetkých ďalších prípadoch neposielame nič --
            else 
                btn_pulse <= '0';
            end if;
        end if;
    end process;                              

end architecture Behavioral;