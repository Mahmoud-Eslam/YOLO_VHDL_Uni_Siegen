

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package arr is
    type my_arr is array (0 to 2,0 to 2) of integer; 
end package;

library work;
use work.arr.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Test_update is
  Port (
        clk : in std_logic;
        reset : in std_logic;
        img : in my_arr := (others => (others => 0));
        filter : in my_arr := (others => (others => 0));
        result : out integer := 0
       );
end Test_update;

architecture Behavioral of Test_update is

signal shift_reg_A : my_arr := (others => (others => 0));
signal shift_reg_B : my_arr := (others => (others => 0));

constant x_size : integer := 3;
constant y_size : integer := 3; 

signal computation_done : boolean := false;

begin

proc_1: process(clk,reset)
            variable sum : integer := 0;
            variable checker :  boolean := false;
            begin
                if reset = '1' then
                    shift_reg_A <= (others => (others => 0));
                    shift_reg_B <= (others => (others => 0));
                    computation_done <= false;
                elsif rising_edge(clk) and computation_done = false then
                    if checker = true then
                        computation_done <= true;
                    end if;    
                    shift_reg_A <= img;
                    shift_reg_B <= filter;
                    for i in 0 to x_size -1  loop
                        for j in 0 to y_size - 1 loop
                            sum := sum + shift_reg_A(i,j) + shift_reg_B(i,j); 
                        end loop;
                    end loop; 
                    result <= sum;
                    checker := true;       
                end if;
        end process;       

end Behavioral;
