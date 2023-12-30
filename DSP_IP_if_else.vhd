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
        A     : in  Integer range 0 to 15 := 0;
        B     : in  Integer range 0 to 15 := 0;
        C     : out Integer range 0 to 35 := 0 
    );
end DSP_IP;

architecture Behavioral of DSP_IP is
    attribute use_dsp : string;
    attribute use_dsp of Behavioral : architecture is "yes";      
    
    signal C_internal : integer range 0 to 35 := 0;  

begin
    process(reset, clk)
    begin
        if reset = '1' then
            C_internal <= 0;
        elsif rising_edge(clk) then  
            C_internal <= A * B;
        end if;
    end process;

    C <= C_internal;

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
    --signal Z_internal : integer := 0;
    signal mul : integer := 0;
    constant x_size : integer := 3;
    constant y_size : integer := 3;
    
-- Component for using the Ip----------------------Start---------------------    
    component DSP_IP
        port (
            clk   : in std_logic;
            reset : in std_logic;     
            A     : in  Integer range 0 to 15 := 0;
            B     : in  Integer range 0 to 15 := 0;
            C     : out Integer range 0 to 35 := 0 
        );
    end component;
    
    signal A_internal : integer range 0 to 15 := 0;
    signal B_internal : integer range 0 to 15 := 0;
    signal C_inter : integer range 0 to 35 := 0; 
-- Component for using the Ip----------------------End---------------------   
   
    begin
        DSP_IP_instance: DSP_IP port map(
                                    clk => clk,
                                    reset => reset,
                                    A => A_internal,
                                    B => B_internal,
                                    C => C_inter
                                    );

process(clk, reset)
    variable i_var : integer := 0;
    variable j_var : integer := 0;
    variable Z_internal : integer := 0;
begin
    if reset = '1' then
        Z_internal := 0;
        Z <= 0;
        i_var := 0;
        j_var := 0;
    elsif rising_edge(clk) then
        if i_var <= x_size - 1 then
            if j_var <= y_size - 1 then
                A_internal <= X(i_var, j_var);
                B_internal <= Y(i_var, j_var);
                Z_internal := Z_internal + C_inter;
    report "signal A: " & integer'image(A_internal) &
    ", signal B: " & integer'image(B_internal) &
     ", signal C: " & integer'image(C_inter)&
     ", signal Z: " & integer'image(Z_internal);
                j_var := j_var + 1; -- Inc inner loop
            else
                i_var := i_var + 1; -- Inc outer loop
                j_var := 0; -- Reset inner loop
            end if;
        else
            Z <= Z_internal;
        end if;
    end if;
end process;


          
        
end Behavioral;