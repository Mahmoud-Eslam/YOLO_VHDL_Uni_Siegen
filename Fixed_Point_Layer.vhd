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

-- ---------------------------------------------------------------------- Packages and Functions

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.all;

library ieee_proposed;
use ieee_proposed.fixed_pkg.all;

package my_package is 
    type input_3d_vector is array(0 to 2, 0 to 2, 0 to 2) of sfixed(8 downto -7);
    type output is array(Natural range <>, Natural range <>, Natural range <>) of sfixed(17 downto -14); 
    
    type sfixed_1d_vector is array(Natural range <>, Natural range <>, Natural range <>) of sfixed(8 downto -7); 
    type sfixed_2d_vector is array(Natural range <>, Natural range <>, Natural range <>) of sfixed(8 downto -7); 
    type sfixed_3d_vector is array(Natural range <>, Natural range <>, Natural range <>) of sfixed(17 downto -14); 
    
    type integer_1d_vector is array(0 to 7) of integer;
    type integer_2d_vector is array(0 to 7, 0 to 7) of integer;
    type integer_3d_vector is array(0 to 7, 0 to 7, 0 to 2) of integer;
    type integer_4d_vector is array(0 to 2, 0 to 2, 0 to 2, 0 to 15) of integer;
    
    type float_1d_vector is array(Natural range <>) of real;
    type float_2d_vector is array(Natural range <>, Natural range <>) of real;
    type float_3d_vector is array(Natural range <>, Natural range <>, Natural range <>) of real;
    type float_4d_vector is array(Natural range <>, Natural range <>, Natural range <>, Natural range <>) of real;

     function to_fixed
    (
        number : real
    )
    return integer;
    -- ------------------------------------------------------------
    function my_to_real
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
    -- ------------------------------------------------------------
    function  divide  
    (
        a : UNSIGNED;
        b : UNSIGNED
    ) 
    return UNSIGNED;
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
    function my_to_real
    (
        fixed_point_number : integer
    )
    return real
    is
        constant fractional_bit_length : natural := 14;
    begin
        return real(fixed_point_number)/2.0**fractional_bit_length;
    end my_to_real;
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
     -- ------------------------------------------------------------
    function  divide  (a : UNSIGNED; b : UNSIGNED) return UNSIGNED is
        variable a1 : unsigned(a'length-1 downto 0):=a;
        variable b1 : unsigned(b'length-1 downto 0):=b;
        variable p1 : unsigned(b'length downto 0):= (others => '0');
        variable i : integer:=0;
        
        begin
            for i in 0 to b'length-1 loop
                p1(b'length-1 downto 1) := p1(b'length-2 downto 0);
                p1(0) := a1(a'length-1);
                a1(a'length-1 downto 1) := a1(a'length-2 downto 0);
                p1 := p1-b1;
                if(p1(b'length-1) ='1') then
                    a1(0) :='0';
                    p1 := p1+b1;
                else
                    a1(0) :='1';
                end if;
            end loop;
            return a1;
    end divide;
end package body;

-- ----------------------------------------------------------------------First Entity 

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.math_real.ALL;

library ieee_proposed;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.fixed_float_types.all;
use ieee_proposed.math_utility_pkg.all;
use ieee_proposed.NUMERIC_STD_UNSIGNED.all;
use ieee_proposed.float_pkg.all;
use ieee_proposed.std_logic_1164_additions.all;
use ieee_proposed.numeric_std_additions.all;

library work;
use work.my_package.all;

entity mult_var is 
    Port(
        clk : in std_logic;
        reset : in std_logic;
        A : in input_3d_vector := (others => (others => (others => (others => '0'))));
        B : in input_3d_vector := (others => (others => (others => (others => '0'))));
        C : out sfixed(17 downto -14)
        );
end entity;

architecture Behavioral of mult_var is
    attribute use_dsp : string;
    attribute use_dsp of Behavioral : architecture is "yes"; 
    begin
    process(clk,reset,A,B)
                variable sum : sfixed(17 downto -14) := (others => '0');
                variable conv_sum : sfixed(17 downto -14) := (others => '0');
                
 ---------------- filter variables
                constant k_height  : integer := 3;
                constant k_width   : integer := 3;
                constant k_depth   : integer := 3;
                begin
                    if reset = '1' then
                        C <= (others => '0');
                    elsif falling_edge(clk) then  
                       for k_d in 0 to (k_depth - 1) loop
                           for k_h in 0 to (k_height - 1) loop
                              for k_w in 0 to (k_width - 1) loop
                                    conv_sum := resize(conv_sum + A(k_h, k_w, k_d) * B(k_h, k_w, k_d), 17, -14);
--                                    report "DSP Sum: " & real'image(to_real(conv_sum));
                               end loop;
                            end loop;
                            sum := conv_sum;   
                        end loop;  
                        C <= sum; 
                        conv_sum := (others => '0');     
                    end if;    
            end process;     
    
end Behavioral; 
-- ----------------------------------------------------------------------Second Entity 

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.math_real.ALL;

library ieee_proposed;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.fixed_float_types.all;
use ieee_proposed.math_utility_pkg.all;
use ieee_proposed.NUMERIC_STD_UNSIGNED.all;
use ieee_proposed.float_pkg.all;
use ieee_proposed.std_logic_1164_additions.all;
use ieee_proposed.numeric_std_additions.all;

library work;
use work.my_package.all;

entity YOLO_VHDL_Source is 
    generic(            
            pooled_height :integer := 15;
            pooled_width  :integer := 15;
            i_filters     :integer := 16;
            n_i_height    :integer := 8;
            n_i_width     :integer := 8;
            stride        :integer := 2
            );
    port(
        CLK : in std_logic;
        reset : in std_logic;
        new_img : out output (0 to (((n_i_height - 2) / stride) - 1),
                              0 to (((n_i_width - 2) / stride) - 1),
                              0 to (i_filters - 1)) :=  (others => (others => (others => (others => '0'))))
        );       
end YOLO_VHDL_Source;

architecture Behavioral of YOLO_VHDL_Source is  

    constant img : float_3d_vector :=
   (
   ((0.0, 7.0, 8.0),(0.0, 7.0, 8.0), (5.0, 8.0, 8.0),(9.0, 3.0, 1.0),(8.0, 5.0, 8.0),(2.0, 9.0, 3.0), (3.0, 7.0, 8.0),(8.0, 5.0, 1.0)),
   ((0.0, 7.0, 8.0),(0.0, 7.0, 8.0), (5.0, 8.0, 8.0),(9.0, 3.0, 1.0),(8.0, 5.0, 8.0),(2.0, 9.0, 3.0), (3.0, 7.0, 8.0),(8.0, 5.0, 1.0)),
   ((0.0, 7.0, 8.0),(0.0, 7.0, 8.0), (5.0, 8.0, 8.0),(9.0, 3.0, 1.0),(8.0, 5.0, 8.0),(2.0, 9.0, 3.0), (3.0, 7.0, 8.0),(8.0, 5.0, 1.0)),
   ((0.0, 7.0, 8.0),(0.0, 7.0, 8.0), (5.0, 8.0, 8.0),(9.0, 3.0, 1.0),(8.0, 5.0, 8.0),(2.0, 9.0, 3.0), (3.0, 7.0, 8.0),(8.0, 5.0, 1.0)),
   ((0.0, 7.0, 8.0),(0.0, 7.0, 8.0), (5.0, 8.0, 8.0),(9.0, 3.0, 1.0),(8.0, 5.0, 8.0),(2.0, 9.0, 3.0), (3.0, 7.0, 8.0),(8.0, 5.0, 1.0)),
   ((0.0, 7.0, 8.0),(0.0, 7.0, 8.0), (5.0, 8.0, 8.0),(9.0, 3.0, 1.0),(8.0, 5.0, 8.0),(2.0, 9.0, 3.0), (3.0, 7.0, 8.0),(8.0, 5.0, 1.0)),
   ((0.0, 7.0, 8.0),(0.0, 7.0, 8.0), (5.0, 8.0, 8.0),(9.0, 3.0, 1.0),(8.0, 5.0, 8.0),(2.0, 9.0, 3.0), (3.0, 7.0, 8.0),(8.0, 5.0, 1.0)),
   ((0.0, 7.0, 8.0),(0.0, 7.0, 8.0), (5.0, 8.0, 8.0),(9.0, 3.0, 1.0),(8.0, 5.0, 8.0),(2.0, 9.0, 3.0), (3.0, 7.0, 8.0),(8.0, 5.0, 1.0))
   );  

    constant kernel : float_4d_vector :=
 (
 (
 ((7.0, 8.0, 9.0, 0.0, 9.0, 4.0, 8.0, 8.0, 5.0, 8.0, 8.0, 7.0, 10.0, 4.0, 9.0, 6.0), (0.0, 5.0, 8.0, 8.0, 4.0, 1.0, 1.0, 7.0, 9.0, 10.0, 7.0, 10.0, 1.0, 9.0, 9.0, 10.0), (0.0, 1.0, 0.0, 4.0, 4.0, 2.0, 9.0, 6.0, 9.0, 6.0, 6.0, 2.0, 6.0, 8.0, 3.0, 6.0)),
 ((7.0, 8.0, 9.0, 0.0, 9.0, 4.0, 8.0, 8.0, 5.0, 8.0, 8.0, 7.0, 10.0, 4.0, 9.0, 6.0), (0.0, 5.0, 8.0, 8.0, 4.0, 1.0, 1.0, 7.0, 9.0, 10.0, 7.0, 10.0, 1.0, 9.0, 9.0, 10.0), (0.0, 1.0, 0.0, 4.0, 4.0, 2.0, 9.0, 6.0, 9.0, 6.0, 6.0, 2.0, 6.0, 8.0, 3.0, 6.0)),
 ((7.0, 8.0, 9.0, 0.0, 9.0, 4.0, 8.0, 8.0, 5.0, 8.0, 8.0, 7.0, 10.0, 4.0, 9.0, 6.0), (0.0, 5.0, 8.0, 8.0, 4.0, 1.0, 1.0, 7.0, 9.0, 10.0, 7.0, 10.0, 1.0, 9.0, 9.0, 10.0), (0.0, 1.0, 0.0, 4.0, 4.0, 2.0, 9.0, 6.0, 9.0, 6.0, 6.0, 2.0, 6.0, 8.0, 3.0, 6.0))
 ),
 (
 ((7.0, 8.0, 9.0, 0.0, 9.0, 4.0, 8.0, 8.0, 5.0, 8.0, 8.0, 7.0, 10.0, 4.0, 9.0, 6.0), (0.0, 5.0, 8.0, 8.0, 4.0, 1.0, 1.0, 7.0, 9.0, 10.0, 7.0, 10.0, 1.0, 9.0, 9.0, 10.0), (0.0, 1.0, 0.0, 4.0, 4.0, 2.0, 9.0, 6.0, 9.0, 6.0, 6.0, 2.0, 6.0, 8.0, 3.0, 6.0)),
 ((7.0, 8.0, 9.0, 0.0, 9.0, 4.0, 8.0, 8.0, 5.0, 8.0, 8.0, 7.0, 10.0, 4.0, 9.0, 6.0), (0.0, 5.0, 8.0, 8.0, 4.0, 1.0, 1.0, 7.0, 9.0, 10.0, 7.0, 10.0, 1.0, 9.0, 9.0, 10.0), (0.0, 1.0, 0.0, 4.0, 4.0, 2.0, 9.0, 6.0, 9.0, 6.0, 6.0, 2.0, 6.0, 8.0, 3.0, 6.0)),
 ((7.0, 8.0, 9.0, 0.0, 9.0, 4.0, 8.0, 8.0, 5.0, 8.0, 8.0, 7.0, 10.0, 4.0, 9.0, 6.0), (0.0, 5.0, 8.0, 8.0, 4.0, 1.0, 1.0, 7.0, 9.0, 10.0, 7.0, 10.0, 1.0, 9.0, 9.0, 10.0), (0.0, 1.0, 0.0, 4.0, 4.0, 2.0, 9.0, 6.0, 9.0, 6.0, 6.0, 2.0, 6.0, 8.0, 3.0, 6.0))
 ),
 (
 ((7.0, 8.0, 9.0, 0.0, 9.0, 4.0, 8.0, 8.0, 5.0, 8.0, 8.0, 7.0, 10.0, 4.0, 9.0, 6.0), (0.0, 5.0, 8.0, 8.0, 4.0, 1.0, 1.0, 7.0, 9.0, 10.0, 7.0, 10.0, 1.0, 9.0, 9.0, 10.0), (0.0, 1.0, 0.0, 4.0, 4.0, 2.0, 9.0, 6.0, 9.0, 6.0, 6.0, 2.0, 6.0, 8.0, 3.0, 6.0)),
 ((7.0, 8.0, 9.0, 0.0, 9.0, 4.0, 8.0, 8.0, 5.0, 8.0, 8.0, 7.0, 10.0, 4.0, 9.0, 6.0), (0.0, 5.0, 8.0, 8.0, 4.0, 1.0, 1.0, 7.0, 9.0, 10.0, 7.0, 10.0, 1.0, 9.0, 9.0, 10.0), (0.0, 1.0, 0.0, 4.0, 4.0, 2.0, 9.0, 6.0, 9.0, 6.0, 6.0, 2.0, 6.0, 8.0, 3.0, 6.0)),
 ((7.0, 8.0, 9.0, 0.0, 9.0, 4.0, 8.0, 8.0, 5.0, 8.0, 8.0, 7.0, 10.0, 4.0, 9.0, 6.0), (0.0, 5.0, 8.0, 8.0, 4.0, 1.0, 1.0, 7.0, 9.0, 10.0, 7.0, 10.0, 1.0, 9.0, 9.0, 10.0), (0.0, 1.0, 0.0, 4.0, 4.0, 2.0, 9.0, 6.0, 9.0, 6.0, 6.0, 2.0, 6.0, 8.0, 3.0, 6.0)))
 );
    
    constant gamma : float_1d_vector := 
    (
    3.2638158798217773,
    4.460397720336914,
    1.18198561668396,
    1.6533160209655762,
    4.321843147277832,
    1.6785709857940674,
    4.001209259033203,
    6.566650390625,
    2.339569568634033,
    3.654820442199707,
    3.554124116897583,
    3.6159822940826416,
    2.8188273906707764,
    2.1044859886169434,
    3.7799949645996094,
    1.9643325805664062
    );
constant beta : float_1d_vector := 
    (
    -2.890369415283203,
    -6.697666645050049,
    0.5552693009376526,
    0.7817191481590271,
    -4.420159339904785,
    0.9831221699714661,
    -4.607707500457764,
    -9.767300605773926,
    -0.3404657244682312,
    1.0352110862731934,
    0.7899404764175415,
    0.9098617434501648,
    0.32240909337997437,
    -0.10215473920106888,
    1.3165702819824219,
    1.1973998546600342
    ); 
constant moving_mean : float_1d_vector := 
    (
    -0.7467830181121826,
    0.406264990568161,
    0.058190274983644485,
    0.06197834387421608,
    -0.036936476826667786,
    -0.0039504277519881725,
    -0.03281150385737419,
    -1.057032823562622,
    -0.03209839388728142,
    0.043669186532497406,
    -0.0017793704755604267,
    0.05360546335577965,
    -0.23466050624847412,
    -0.00626344932243228,
    0.017854779958724976,
    -0.1660752296447754
    );    
constant moving_variance : float_1d_vector := 
    (
    0.1594277024269104,
    0.04255719110369682,
    0.19109822809696198,
    0.4208472967147827,
    0.14984990656375885,
    0.013252475298941135,
    0.12210448086261749,
    0.2738870084285736,
    0.059880033135414124,
    0.7717112898826599,
    0.6764482855796814,
    0.8243041038513184,
    0.3935566246509552,
    0.1252153068780899,
    0.7929491400718689,
    0.37377357482910156
    ); 
    
constant epsilon : real := 0.001;
 
constant i_height  :integer := 8; 
constant i_width   :integer := 8;
constant i_depth   :integer := 3; 
constant k_height  : integer := 3;
constant k_width   : integer := 3;
constant k_depth   : integer := 3;
constant k_filters : integer := 16; 

--------------------- DSP I/O ----------------------
signal sub_result : sfixed(17 downto -14) := (others => '0');
signal im_elment :  input_3d_vector := (others => (others => (others => (others => '0')))) ;
signal filter_elment :  input_3d_vector := (others => (others => (others => (others => '0'))));

    component mult_var
        Port(
        clk : in std_logic;
        reset : in std_logic;
        A : in input_3d_vector := (others => (others => (others => (others => '0'))));
        B : in input_3d_vector := (others => (others => (others => (others => '0'))));
        C : out sfixed(17 downto -14)
             );
    end component;
    
BEGIN  
    mult_instance_1: mult_var port map(
        clk => clk,
        reset => reset,
        A => im_elment,
        B => filter_elment,
        C => sub_result
    );     
    process (CLK, reset)
    variable temp_img : sfixed_3d_vector(0 to 5, 0 to 5, 0 to 15) := (others => (others => (others => (others => '0'))));  
    
    ---------------- kernels variables
    variable n_i_height : integer  := (i_height - k_height) + 1; 
    variable n_i_width  : integer  := (i_width - k_width) + 1; 
    variable n_i_depth  : integer  := (i_depth - k_depth) + 1; 
    
    ---------------- loop variables
    variable conv_sum   : integer := 0;
    variable d : integer := 0;
    variable sub : integer := 0;
    variable h : integer := 0;
    variable w : integer := 0;
    variable k_f : integer := 0;
    variable conv_done : boolean := false; 
    variable batch_norm_done : boolean := false;
    variable activation_done : boolean := false;
    variable maxpool_done : boolean := false;
    
    ---------------- mapped to dsp
    variable img_3d : input_3d_vector :=(others => (others => (others => (others => '0'))));
    variable flt_3d : input_3d_vector :=(others => (others => (others => (others => '0'))));
    
    ---------------- batch norm variables
    variable x : sfixed(17 downto -14) := (others => '0');
    variable x_norm : sfixed(17 downto -14) := (others => '0');
    variable y : sfixed(17 downto -14) := (others => '0');
    
    ---------------- activation variables
    variable act_x : sfixed(17 downto -14) := (others => '0');
    
    ---------------- max pool variables
    variable max_val : sfixed(17 downto -14) := (others => '0');
    variable mh : integer := 0;
    variable mw : integer := 0;

    
    begin
        if reset ='1' then                          
        elsif rising_edge(clk) then
        
          if conv_done = false then
                if k_f < (k_filters) then
                     for k_d in 0 to (k_depth - 1) loop
                         for k_h in 0 to (k_height - 1) loop
                             for k_w in 0 to (k_width - 1) loop
                                 img_3d(k_h, k_w, k_d) :=  to_sfixed(img((h+ k_h), (w + k_w), (d + k_d)), 8, -7);
                                 flt_3d(k_h, k_w, k_d) :=  to_sfixed(kernel(k_h, k_w, k_d, k_f), 8, -7);
                             end loop;
                          end loop; 
                     end loop;  
                 end if; 
   
                im_elment <= img_3d;
                filter_elment <= flt_3d; 
                 
                if k_f > 0 then          ------ delay assignment
--                   report "Main Sum: " & real'image(to_real(sub_result));
                   temp_img(h,w,k_f-1) := sub_result;
                end if;
                k_f := k_f + 1;
             
     
           end if;
     
            
            if k_f = (k_filters) + 1 then
--                   report "Filters increased: "; 
                   w:= w + 1;
                   k_f := 0;
            end if;
                   
            if w = (n_i_width) then
--                   report "Width increased: ";
                   h := h + 1;
                   w := 0;
            end if;
     
            if h = (n_i_height) then
--                   report "Hight increased: "; 
                   d := d + 1;
                   h := 0;
            end if;

             if d = (n_i_depth) then
--                     report "Conv Done: ";
                     conv_done := true;  
                     d := 0;
                     h := 0;
                     w := 0;
                     k_f := 0;
                     report "The first value is XXXX:" & integer'image(to_integer(temp_img(0,0,0)));
                     report "The first value is XXXX:" & integer'image(to_integer(temp_img(0,0,1)));
                     report "The first value is XXXX:" & integer'image(to_integer(temp_img(0,0,2)));
             end if;       
             
       if conv_done = true and batch_norm_done = false then
--       report "calculating:" ;
       
             -- perform batchNorm 
            for h in 0 to (n_i_height - 1) loop
                for w in 0 to (n_i_width -1) loop
                   for d in 0 to (k_filters - 1) loop
                      x := temp_img(h,w,d);
                       x_norm := resize((x - to_sfixed(moving_mean(d),17,-14)) / to_sfixed(((moving_variance(d) - epsilon) ** 0.5),17,-14), 17, -14);
                       y := resize((to_sfixed(gamma(d),17,-14) * x_norm) + to_sfixed(beta(d),17,-14), 17, -14);
                        temp_img(h, w, d) := y;
                    end loop;  
                end loop;
           end loop; 
          batch_norm_done := true; 
        end if; 
        
       if batch_norm_done = true and activation_done = false then  
         -- perform LeakyReLU
        for h in 0 to (n_i_height - 1) loop
            for w in 0 to (n_i_width -1) loop
                for d in 0 to (k_filters - 1) loop
                   act_x := temp_img(h, w, d);
                      if (act_x > 0.0) then
                          temp_img(h, w, d) := act_x;
                      else
                          temp_img(h, w, d) := resize(to_sfixed(-0.01, 17,-14) * act_x, 17, -14);    
                      end if;     
                end loop;  
             end loop;
         end loop;
         activation_done := true;
       end if;  
       
       if activation_done = true and maxpool_done = false then
                     -- perform MaxPool
         for d in 0 to (k_filters - 1) loop
             mh := 0;
             for mh_outer in 0 to ((n_i_height - 2) / stride) loop
                 mw := 0;
                 for mw_outer in 0 to ((n_i_width - 2) / stride) loop
                     max_val := temp_img(mh, mw, d);
                       if (temp_img(mh, mw + 1, d) > max_val) then
                            max_val := temp_img(mh, mw + 1, d);
                        end if;
                        if (temp_img(mh + 1, mw, d) > max_val) then
                            max_val := temp_img(mh + 1, mw, d);
                        end if;
                        if (temp_img(mh + 1, mw + 1, d) > max_val) then
                            max_val := temp_img(mh + 1, mw + 1, d);
                        end if;
            
                        new_img(mh_outer, mw_outer, d) <= max_val;
            
                        mw := mw + stride;
                    end loop;
                    mh := mh + stride;
                end loop;
            end loop;
            maxpool_done := true; 
            report "Done:" ;
        end if; 

        end if;
    end process;

end Behavioral; 
