library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity main_entity_tb is
end;

architecture bench of main_entity_tb is

  component main_entity 
      Port(
          clk : in std_logic;
          reset : in std_logic;
          A_main : in integer;
          result : out integer
          );
  end component;

  signal clk: std_logic := '0';
  signal reset: std_logic := '0';
  signal A_main: integer := 7;
  signal result: integer := 0;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: main_entity port map ( clk    => clk,
                              reset  => reset,
                              A_main => A_main,
                              result => result );

  stimulus: process
  begin
  
    -- Put initialisation code here
    reset <= '1';
    wait for 10 ns;
    reset <= '0';
    wait for 10 ns;

    -- Put test bench stimulus code here
    wait for 10 ns;
    A_main <= 1;
    wait for 400 ns;
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
