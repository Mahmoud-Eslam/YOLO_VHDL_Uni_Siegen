library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

package conv_package is   
    type integer_3d_vector is array(0 to 3, 0 to 3, 0 to 2) of integer;
    type output is array(0 to 7, 0 to 7, 0 to 2) of integer;    
end;  

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.math_real.ALL;

library work;
use work.conv_package.all;

entity Upsample is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        upsampled_matrix : out output
    );
end Upsample;

architecture Behavioral of Upsample is
    constant HEIGHT : integer := 4;
    constant WIDTH : integer := 4;
    constant CHANNELS : integer := 3;
    constant scale_factor : integer := 2;
    
constant img : integer_3d_vector :=
   (((0, 7, 8),(6, 9, 8), (5, 8, 8),(9, 3, 1)),
    ((10, 6, 10),(8, 4, 8),(7, 7, 2),(7, 8, 5)),
((3, 8, 4),(7, 0, 4),(6, 6, 4),(1, 6, 0)),
((0, 1, 9), (3, 5, 1), (2, 9, 9), (3, 5, 5))); 

begin

    process(clk, reset)
    variable scaled_height : integer := HEIGHT * scale_factor;
    variable scaled_width : integer := WIDTH * scale_factor;
    variable unscaled_i : integer := 0;
    variable unscaled_j : integer := 0;
    begin
        if reset = '1' then
        
            upsampled_matrix <= (others => (others => (others => 0)));
            
        elsif rising_edge(clk) then
            -- Perform upsampling
            for i in 0 to scaled_height-1 loop
                for j in 0 to scaled_width-1 loop
                    for k in 0 to CHANNELS-1 loop
                        unscaled_i := i/scale_factor;
                        unscaled_j := j/scale_factor;
                        upsampled_matrix(i, j, k) <= img(unscaled_i, unscaled_j, k);
                    end loop;
                end loop;
            end loop;
        end if;
    end process;

end Behavioral;
