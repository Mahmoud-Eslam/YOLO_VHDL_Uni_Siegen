library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_DSP_convmax is
end tb_DSP_convmax;

library work;
use work.my_package.all;

architecture tb_architecture of tb_DSP_convmax is
   constant pooled_height :integer := 15;
    constant pooled_width  :integer := 15;
    constant i_filters     :integer := 16;
    constant n_i_height    :integer := 8;
    constant n_i_width     :integer := 8;
    constant stride        :integer := 2;
    signal CLK, reset : std_logic := '0';
    signal output_tb : output (0 to (((n_i_height - 2) / stride) - 1), 0 to (((n_i_width - 2) / stride) - 1), 0 to (i_filters - 1)) := (others => (others => (others => (others => '0'))));
begin
    -- Instantiate the DSP_convmax entity
    DUT : entity work.YOLO_VHDL_Source
        port map (
            CLK => CLK,
            reset => reset,
            new_img => output_tb
            
            
        );

    -- Clock process
    CLK_process: process
    begin
        while now < 13000 ns loop
            CLK <= not CLK;
            wait for 10 ns;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stimulus_process: process
    begin
        -- Initialize inputs here if needed

        -- Apply reset
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        reset <= '1';
        wait for 10 ns;
        reset <= '0';

        -- Wait for some time before applying inputs
        wait for 10 ns;

        -- Apply test input data here if needed

        -- Wait for some time to observe the output
        wait for 200 ns;

        -- Add assertions for expected output data here if needed

        wait;

    end process;

end tb_architecture;
