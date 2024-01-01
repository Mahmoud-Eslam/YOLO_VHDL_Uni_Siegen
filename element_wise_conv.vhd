-- ----------------------------------------------------------------------First Entity 
library IEEE;
use IEEE.std_logic_1164.ALL; 

entity mult_var is 
    Port(
        clk : in std_logic;
        reset : in std_logic;
        A : in integer;
        B : in integer;
        C : out integer
        );
end entity;

architecture Behavioral of mult_var is
    attribute use_dsp : string;
    attribute use_dsp of Behavioral : architecture is "yes"; 
    signal c_internal : integer := 0;
    begin
    process(clk,reset,A,B)
                variable sum : integer := 0;  
                begin
                    if reset = '1' then
                        C <= 0;
                        c_internal <= 0;
                    elsif falling_edge(clk) then  
                        c_internal <= A * B;
                        sum := sum + A * B;
                      report "internal C : " & integer'image(c_internal);
                        C <= sum;       
                    end if;    
            end process;     
    
end Behavioral; 
-- ----------------------------------------------------------------------Second Entity 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package arr is
    type my_arr is array (0 to 2,0 to 2) of integer; 
end package;

library work;
use work.all;
use work.arr.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_entity is 
    Port(
        clk : in std_logic;
        reset : in std_logic;
        img : in my_arr := (others => (others => 0));
        filter : in my_arr := (others => (others => 0));
        result : out integer
        );
end entity;

architecture Behavioral of main_entity is
    
    signal im_elment : integer := 0;
    signal filter_elment : integer := 0;
    signal shift_register_img : integer := 0;
    signal shift_register_filter : integer := 0;
    signal sub_result : integer := 0;
    
    constant x_size : integer := 3;
    constant y_size : integer := 3; 
  
    
    component mult_var
        Port(
            clk : in std_logic;
            reset : in std_logic;
            A : in integer;
            B : in integer;
            C : out integer
             );
    end component;
    
begin
    mult_instance_1: mult_var port map(
        clk => clk,
        reset => reset,
        A => im_elment,
        B => filter_elment,
        C => sub_result
    );

    process(clk, reset)
        variable i_var : integer := 0;
        variable j_var : integer := 0; 
        variable sub_c : integer := 0;
        variable sub_sum : integer := 0;
    begin
        if reset = '1' then 
            result <= 0;
            im_elment <= 0;
            filter_elment <= 0;
            i_var := 0;
            j_var := 0;
        elsif rising_edge(clk) then   
            im_elment <= img(i_var, j_var);
            filter_elment <= filter(i_var, j_var);
            sub_c := sub_result;
            sub_sum := sub_c;
            report "sub_C: " & integer'image(sub_c)&
                    ", sum: " & integer'image(sub_sum);
  
            j_var := j_var + 1;
            if j_var = y_size then
                i_var := i_var + 1;
                j_var := 0;
            end if;
            
            if i_var = x_size then          
                i_var := 0;
                j_var := 0;
            end if;         
        end if;   
        result <= sub_sum; 
    end process;     

end Behavioral;
