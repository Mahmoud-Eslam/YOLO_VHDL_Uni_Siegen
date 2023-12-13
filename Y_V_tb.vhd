-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 13.12.2023 12:07:53 UTC

library ieee;
use ieee.std_logic_1164.all;
use work.my_conv_package.all;

entity tb_YOLO_VHDL_Source is
end tb_YOLO_VHDL_Source;

architecture tb of tb_YOLO_VHDL_Source is
    constant pooled_height :integer := 15;
    constant pooled_width  :integer := 15;
    constant i_filters     :integer := 16;
    
    component YOLO_VHDL_Source
        port (CLK     : in std_logic;
              reset   : in std_logic;
              new_img : out float_3d_vector (0 to (pooled_height - 1), 0 to (pooled_width - 1), 0 to (i_filters - 1)) := (others => (others => (others => 0.0))));
    end component;

    signal CLK     : std_logic;
    signal reset   : std_logic;
    signal new_img : float_3d_vector (0 to (pooled_height - 1), 0 to (pooled_width - 1), 0 to (i_filters - 1)) := (others => (others => (others => 0.0)));

    constant TbPeriod : time := 100 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : YOLO_VHDL_Source
    port map (CLK     => CLK,
              reset   => reset,
              new_img => new_img);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2;

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 3000 ms;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
  
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_YOLO_VHDL_Source of tb_YOLO_VHDL_Source is
    for tb
    end for;
end cfg_tb_YOLO_VHDL_Source;