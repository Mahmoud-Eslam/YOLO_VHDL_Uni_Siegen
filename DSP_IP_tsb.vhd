library ieee;
use ieee.std_logic_1164.all;


package conv_package is 
    type integer_2d_vector is array(0 to 2, 0 to 2) of integer;
    type float_2d_vector is array(Natural range <>, Natural range <>) of real;
    type std_2d_vector is array(Natural range <>, Natural range <>) of STD_LOGIC;
end;    

library work;
use work.conv_package.all;
library ieee;
use ieee.std_logic_1164.all;
entity tb_DSP_CONV is
end tb_DSP_CONV;

architecture tb of tb_DSP_CONV is

    component DSP_CONV
        port (
            clk   : in std_logic;
            reset : in std_logic;
            X     : in integer_2d_vector;
            Y     : in integer_2d_vector;
            Z     : out integer
        );
    end component;

    signal clk, reset : std_logic := '0';
    signal X, Y : integer_2d_vector := ((1, 2, 3), (4, 5, 6), (7, 8, 9));
    signal Z : integer;

begin

    dut : DSP_CONV
    port map (
        clk   => clk,
        reset => reset,
        X     => X,
        Y     => Y,
        Z     => Z
    );

    -- Clock generation
    -- Clock generation
    process
    begin
        reset <= '1';  -- Assert reset initially
        wait for 10 ns;
           reset <= '0';  -- De-assert reset     
        -- Toggle clk multiple times
        for i in 1 to 100 loop
            clk <= not clk after 10 ns;
            wait for 10 ns;
        end loop;
        

        wait;
      end process;

end tb;
