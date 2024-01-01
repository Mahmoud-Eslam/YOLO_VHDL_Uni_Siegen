-- ----------------------------------------------------------------------First Entity 
library IEEE;
use IEEE.std_logic_1164.ALL; 

entity mult_var is 
    Port(
        clk : in std_logic;
        reset : in std_logic;
        A : in integer;
        C : out integer
        );
end entity;

architecture Behavioral of mult_var is
    signal c_internal : integer := 0;
    begin
    process(clk,reset)
                begin
                    if reset = '1' then
                        elsif falling_edge(clk) then
                           c_internal <= A * 1;
                            report "internal XXXXXXXXXXX: " & integer'image(c_internal);
                           C <= c_internal;       
                    end if;    
            end process;     
    
end Behavioral; 
-- ----------------------------------------------------------------------Second Entity 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_entity is 
    Port(
        clk : in std_logic;
        reset : in std_logic;
        A_main : in integer;
        result : out integer
        );
end entity;

architecture Behavioral of main_entity is
    
    signal sub_A : integer := 0;
    signal shift_register_A : integer := 0;
    signal shift_register_C : integer := 0;
    signal sub_C : integer := 0;
    
    component mult_var
        Port(
            clk : in std_logic;
            reset : in std_logic;
            A : in integer;
            C : out integer
             );
    end component;
    
begin
    mult_instance_1: mult_var port map(
        clk => clk,
        reset => reset,
        A => sub_A,
        C => sub_C
    );

    process(clk, reset)
        variable sum : integer := 0;   
    begin
        if reset = '1' then 
            result <= 0;
        elsif rising_edge(clk) then   
            shift_register_A <= A_main;
            sub_A <= shift_register_A;
            shift_register_C <= sub_C;
            sum := sum + shift_register_C; 
            result <= sum;     
            report "sub_C xxxxxxxxxxxxxxXXXXXXXXXXX: " & integer'image(shift_register_C);
        end if;    
    end process;     

end Behavioral;
