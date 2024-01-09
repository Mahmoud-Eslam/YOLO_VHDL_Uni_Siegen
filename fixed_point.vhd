----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/05/2024 05:12:47 AM
-- Design Name: 
-- Module Name: test_fixed - Behavioral
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
use IEEE.Numeric_Std.all;

--use ieee.fixed_pkg.all;
--use ieee.ENV.all;
--use ieee.fixed_float_types.all;
--use ieee.float_pkg.all;
--use ieee.math_utility_pkg.all;
--use ieee.numeric_std_additions.all;
--use ieee.NUMERIC_STD_UNSIGNED.all;
--use ieee.standard_additions.all;
--use ieee.standard_textio_additions.all;
--use ieee.std_logic_1164_additions.all;

package my_package is 
    
     function to_fixed
    (
        number : real
    )
    return integer;
    -- ------------------------------------------------------------
    function to_real
    (
        fixed_point_number : integer
    )
    return real;
    -- ------------------------------------------------------------
    function radix_multiply
    (
        left, right : signed;
        radix       : natural
    )
    return signed;
end package;

package body my_package is
     function to_fixed
    (
        number : real
    )
    return integer
    is
         constant fractional_bit_length : natural := 7;
    begin
        return integer(number*2.0**(fractional_bit_length));
    end to_fixed;
    -- ------------------------------------------------------------
    function to_real
    (
        fixed_point_number : integer
    )
    return real
    is
        constant fractional_bit_length : natural := 14;
    begin
        return real(fixed_point_number)/2.0**fractional_bit_length;
    end to_real;
        -- ------------------------------------------------------------
    function radix_multiply
    (
        left, right : signed;
        radix       : natural
    )
    return signed
    is
        constant word_length : natural := left'length + right'length;
        variable result : signed(word_length-1 downto 0) := (others => '0');
    begin
        result := left * right;
        return result;
    end radix_multiply;
end package body;


library work;
use work.all;
use work.my_package.all;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.all;

library ieee_proposed;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.fixed_float_types.all;
use ieee_proposed.math_utility_pkg.all;
use ieee_proposed.NUMERIC_STD_UNSIGNED.all;
use ieee_proposed.float_pkg.all;
use ieee_proposed.std_logic_1164_additions.all;
use ieee_proposed.numeric_std_additions.all;

--use ieee_proposed.ENV.all;
--use ieee_proposed.standard_textio_additions.all;
--use ieee_proposed.std_logic_1164_additions.all;
--use ieee_proposed.numeric_std_additions.all;
--use ieee_proposed.NUMERIC_STD_UNSIGNED.all;
--use ieee_proposed.fixed_pkg.all;
--use ieee_proposed.float_pkg.all;
--use ieee_proposed.fixed_float_types.all;
--use ieee_proposed.math_utility_pkg.all;



entity test_fixed is
    Port(
            clk : in std_logic;
            reset : in std_logic;
            result : out sfixed(31 downto 0) 
            );
end entity;

architecture Behavioral of test_fixed is
    constant word_length  : integer := 16;
    constant integer_bits : integer := 8;
    constant fractional_bits : integer := word_length-integer_bits;
    constant test : real := -1.3;
begin
        

    process(clk,reset)
        -- My implementation    
        variable a_temp : integer;
        variable b_temp : integer;
        variable a_temp_s : signed(integer_bits - 1 downto 0);
        variable b_temp_s : signed(integer_bits - 1 downto 0);
        variable sub_result : signed(word_length - 1 downto 0);
        variable scale : natural := 0;
        variable test_real : sfixed(15 downto 0) := (others => '0');
        
        -- Imported library fixde point package 
        variable A: sfixed(15 downto 0) := to_sfixed(-3.2 ,8,-7);
        variable B: sfixed(15 downto 0) := to_sfixed(-55.7 ,8,-7);
        variable C: sfixed(A'high + B'high + 1 downto A'low + B'low) := (others => '0');
        begin
            if reset = '1' then
                result <= (others => '0');
            elsif rising_edge(clk) then
                 -- My implementation
                 a_temp := to_fixed(44.77);
                 b_temp := to_fixed(-57.44);
                 report "A : " & integer'image(a_temp);
                 report "B : " & integer'image(b_temp);
                 a_temp_s := to_signed(a_temp, 8);
                 b_temp_s := to_signed(b_temp, 8);

                 sub_result := radix_multiply(a_temp_s, b_temp_s, scale);
                 report "integer result  " & integer'image(to_integer(sub_result));
--                 result <= to_integer(sub_result); 
                 report "real result : " & real'image(to_real(to_integer(sub_result)));
                 test_real := to_sfixed(test, 8, -7);
                 -- Imported library fixde point package
                 C := A * B; 
                 result <= C;
            end if;
    end process;    


end Behavioral;
