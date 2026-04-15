library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------

entity counter is
    port (
        clk : in  std_logic; -- Hlavny hodinový signál --                              
        rst : in  std_logic; -- Reset --                             
        en  : in  std_logic; -- Enable signál --                            
        run : in  std_logic; -- Signal z jadra --
        
        -- Výstupy pre jednotlivé cifry (4-bitové čísla) --
        c_ones : out unsigned(3 downto 0);
        c_tens : out unsigned(3 downto 0);
        s_ones : out unsigned(3 downto 0);
        s_tens : out unsigned(3 downto 0);
        m_ones : out unsigned(3 downto 0);
        m_tens : out unsigned(3 downto 0);
        h_ones : out unsigned(3 downto 0);
        h_tens : out unsigned(3 downto 0)  
    );
end entity counter;

-------------------------------------------------

architecture behavioral of counter is
    
    -- Vnútorné signály --
    signal rc_ones : unsigned(3 downto 0) := (others => '0');
    signal rc_tens : unsigned(3 downto 0) := (others => '0');
    signal rs_ones : unsigned(3 downto 0) := (others => '0');
    signal rs_tens : unsigned(3 downto 0) := (others => '0');
    signal rm_ones : unsigned(3 downto 0) := (others => '0');
    signal rm_tens : unsigned(3 downto 0) := (others => '0');
    signal rh_ones : unsigned(3 downto 0) := (others => '0');
    signal rh_tens : unsigned(3 downto 0) := (others => '0');

begin
    process(clk)
    begin 
        if rising_edge(clk) then
            -- Ak stlačíme reset všetky čísla na 0 --
            if rst = '1' then
                rc_ones <= "0000";
                rc_tens <= "0000";
                rs_ones <= "0000";
                rs_tens <= "0000";
                rm_ones <= "0000";
                rm_tens <= "0000";
                rh_ones <= "0000";
                rh_tens <= "0000";
            -- Ak nie je reset a sú zapnuté hodiny a ubehla presne jedna stotina --
            elsif en = '1' and run = '1' then
                -- Ak sú jednotky stotín 9, vynuluj a posuň sa --
                if rc_ones = 9 then
                    rc_ones <= "0000";
                    -- Ak sú desiatky stotín 9, vynuluj a posuň sa --
                    if rc_tens = 9 then
                        rc_tens <= "0000";
                        -- Ak sú jednotky sekúnd 9, vynuluj a posuň sa --
                        if rs_ones = 9 then
                            rs_ones <= "0000";
                            -- Ak sú jednotky sekúnd 5, vynuluj a posuň sa --
                            if rs_tens = 5 then
                                rs_tens <= "0000";
                                -- Ak sú jednotky minút 9, vynuluj a posuň sa --
                                if rm_ones = 9 then
                                    rm_ones <= "0000";
                                    -- Ak sú jednotky minút 5, vynuluj a posuň sa --
                                    if rm_tens = 5 then
                                        rm_tens <= "0000";
                                        -- Ak sú jednotky hodín 3 a desiatky 2, vynuluj všetko --
                                        if rh_ones = 3 and rh_ones = 2 then
                                            rh_ones <= "0000";
                                            rh_tens <= "0000";
                                        -- Ak sú jednotky hodín 9, vynuluj a posuň sa --    
                                        elsif rh_ones = 9 then
                                            rh_ones <= "0000";
                                            rh_tens <= rh_tens + 1;
                                        -- Bežné pridanie 1 hodiny --
                                        else
                                            rh_ones <= rh_ones + 1;
                                        end if;
                                    -- Bežné pridanie 1 desiatky minút --
                                    else rm_tens <= rm_tens + 1;
                                    end if;
                                -- Bežné pridanie 1 minúty --
                                else rm_ones <= rm_ones + 1;
                                end if;
                            -- Bežné pridanie 1 desiatky sekúnd --
                            else rs_tens <= rs_tens + 1;
                            end if;
                        -- Bežné pridanie 1 sekundy --
                        else rs_ones <= rs_ones + 1;
                        end if;
                    -- Bežné pridanie 1 desiatky stotín --
                    else rc_tens <= rc_tens + 1;
                    end if;
                -- Bežné pridanie 1 stotiny --
                else rc_ones <= rc_ones + 1;
                end if;
            end if;
        end if;
    end process;
    
    -- Signály prepíšeme na výstupy -- 
    c_ones <= rc_ones;
    c_tens <= rc_tens;
    s_ones <= rs_ones;
    s_tens <= rs_tens;
    m_ones <= rm_ones;
    m_tens <= rm_tens;
    h_ones <= rh_ones;
    h_tens <= rh_tens;
                          
end architecture behavioral;