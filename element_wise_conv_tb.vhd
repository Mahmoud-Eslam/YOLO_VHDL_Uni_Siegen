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

entity main_entity_tb is
end;

architecture bench of main_entity_tb is

  component main_entity 
      Port(
          clk : in std_logic;
          reset : in std_logic;
          img : in my_arr := (others => (others => 0));
          filter : in my_arr := (others => (others => 0));
          result : out integer
          );
  end component;

  signal clk: std_logic := '0';
  signal reset: std_logic := '0';
  signal img: my_arr := ((1,2,3),(4,5,6),(7,8,9));
  signal filter: my_arr := ((1,2,3),(4,5,6),(7,8,9));
  signal result: integer := 0;

  constant clock_period: time := 5 ns;
  signal stop_the_clock: boolean;

begin

  uut: main_entity port map ( clk    => clk,
                              reset  => reset,
                              img => img,
                              filter => filter,
                              result => result );

  stimulus: process
  begin
  
    -- Put initialisation code here
    reset <= '1';
    wait for 15 ns;
    reset <= '0';

    -- Put test bench stimulus code here
    wait for 45 ns;
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
