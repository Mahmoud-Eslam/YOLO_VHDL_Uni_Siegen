----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/29/2023 02:00:42 AM
-- Design Name: 
-- Module Name: DSP_IP - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;
package conv_package is 
    type integer_2d_vector is array(0 to 2, 0 to 2) of integer;
    type float_2d_vector is array(Natural range <>, Natural range <>) of real;
    type std_2d_vector is array(Natural range <>, Natural range <>) of STD_LOGIC;
end;    
library work;
use work.conv_package.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity DSP_IP is
    port (
        clk   : in std_logic;
        reset : in std_logic;     
        i     : in  Integer range 0 to 15 := 0;
        C     : out Integer range 0 to 35 := 0 
    );
end DSP_IP;

architecture Behavioral of DSP_IP is
    attribute use_dsp : string;
    attribute use_dsp of Behavioral : architecture is "yes";      
    
    --signal C_internal : integer range 0 to 35 := 0;  
    signal X, Y : integer_2d_vector := ((1, 2, 3), (4, 5, 6), (7, 8, 9));

begin
    process(i)
    variable j : integer:=0;
    variable C_internal : integer:=0;
    begin 
            for j in 0 to 2 loop
            C_internal := C_internal + X(i,j) * Y(i,j);
            report "C: " & integer'image(C_internal); 
            end loop;
      C <= C_internal;
    end process;

    

end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package conv_package is 
    type integer_2d_vector is array(0 to 2, 0 to 2) of integer;
    type float_2d_vector is array(Natural range <>, Natural range <>) of real;
    type std_2d_vector is array(Natural range <>, Natural range <>) of STD_LOGIC;
end;    

library work;
use work.conv_package.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity DSP_CONV is 
    port(
        clk   : in std_logic;
        reset : in std_logic; 
        X : in integer_2d_vector := (others => (others => 0));
        Y : in integer_2d_vector := (others => (others => 0));
        Z : out Integer
        );
end DSP_CONV;

architecture Behavioral of DSP_CONV is 
    constant x_size : integer := 3;
    constant y_size : integer := 3;
    
-- Component for using the Ip----------------------Start---------------------    
    component DSP_IP
        port (
            clk   : in std_logic;
            reset : in std_logic;     
            i     : in  Integer range 0 to 15 := 0;
            C     : out Integer range 0 to 35 := 0 
        );
    end component;
    
    signal A_internal : integer range 0 to 15 := 0;
    signal C_inter : integer range 0 to 35 := 0; 
-- Component for using the Ip----------------------End---------------------   
   
    begin
        DSP_IP_instance: DSP_IP port map(
                                    clk => clk,
                                    reset => reset,
                                    i => A_internal,
                                    C => C_inter
                                    );
        process(reset,C_inter)
        variable i : integer:=-1;
        variable sum : integer:=0;
            begin
            i := i+1;
                if reset = '1' then
                    Z <= 0;    
                 end if;
                 
                  if i <= 2 then
                  A_internal <= i;
                  --report "i: " & integer'image(i)& ", signal A: " & integer'image(A_internal);  
                  end if;  
                Z <= C_inter;    
        end process;    
        
end Behavioral;