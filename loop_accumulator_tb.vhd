library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package arr is
    type my_arr is array (0 to 2,0 to 2) of integer; 
end package;

library work;
use work.arr.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.all;

entity Test_update_tb is
end entity;

architecture bench of Test_update_tb is

  component Test_update
    Port (
          clk : in std_logic;
          reset : in std_logic;
          img : in my_arr := (others => (others => 0));
          filter : in my_arr := (others => (others => 0));
          result : out integer := 0
         );
  end component;

  signal clk: std_logic := '0';
  signal reset: std_logic := '0';
  signal img: my_arr := ((1, 2, 3), (4, 5, 6), (7, 8, 9));
  signal filter: my_arr := ((1, 2, 3), (4, 5, 6), (7, 8, 9));
  signal result: integer := 0 ;

  constant clock_period: time := 100 ns;
  signal stop_the_clock: boolean;

begin

  uut: Test_update port map ( clk    => clk,
                              reset  => reset,
                              img    => img,
                              filter => filter,
                              result => result );

  stimulus: process
  begin
  
    -- Put initialisation code here

    reset <= '1';
    wait for 50 ns;
    reset <= '0';
    wait for 500 ns;

    -- Put test bench stimulus code here

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
