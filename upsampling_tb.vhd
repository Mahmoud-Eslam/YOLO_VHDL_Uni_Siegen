library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.math_real.ALL;

library work;
use work.conv_package.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Upsample_TB is
end Upsample_TB;

architecture Behavioral of Upsample_TB is
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal upsampled_matrix : output;

    constant CLK_PERIOD : time := 10 ns; -- Adjust the clock period as needed

begin

    -- Instantiate the Upsample module
    uut: entity work.Upsample
        port map (
            clk => clk,
            reset => reset,
            upsampled_matrix => upsampled_matrix
        );

    -- Clock process
    process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus process
    process
    begin
        -- Initialize inputs
        reset <= '1';
        wait for 10 ns;
        reset <= '0';

        -- Wait for some time to observe the result
        wait for 100 ns;


        wait;

    end process;

end Behavioral;
