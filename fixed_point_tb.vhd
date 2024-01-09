----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/05/2024 05:47:28 AM
-- Design Name: 
-- Module Name: fixed_point_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.fixed_float_types.all;
use ieee_proposed.math_utility_pkg.all;
use ieee_proposed.NUMERIC_STD_UNSIGNED.all;
use ieee_proposed.float_pkg.all;
use ieee_proposed.std_logic_1164_additions.all;
use ieee_proposed.numeric_std_additions.all;

entity test_fixed_tb is
end;

architecture bench of test_fixed_tb is

  component test_fixed
      Port(
              clk : in std_logic;
              reset : in std_logic;
              result : out sfixed(31 downto 0)  
              );
  end component;

  signal clk: std_logic := '0';
  signal reset: std_logic := '0';
  signal result: sfixed(31 downto 0)  := (others => '0');
  
  
  constant clock_period: time := 5 ns;
  signal stop_the_clock: boolean;

begin

  uut: test_fixed port map ( clk    => clk,
                             reset  => reset,
                             result => result );

  stimulus: process
  begin
  
    -- Put initialisation code here

    reset <= '1';
    wait for 5 ns;
    reset <= '0';
    wait for 5 ns;

    -- Put test bench stimulus code here
    wait for 10 ns;
    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;