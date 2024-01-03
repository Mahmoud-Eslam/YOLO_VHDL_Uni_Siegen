-- ----------------------------------------------------------------------First Entity 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package conv_package is   
    type output is array(0 to 5, 0 to 5, 0 to 15) of integer range 0 to 35; 
    type integer_3d_vector is array(0 to 7, 0 to 7, 0 to 2) of integer;
    type integer_4d_vector is array(0 to 2, 0 to 2, 0 to 2, 0 to 15) of integer;
    type input_3d_vector is array(0 to 2, 0 to 2, 0 to 2) of integer range 0 to 15;
    
end;  

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.math_real.ALL;

library work;
use work.conv_package.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mult_var is 
    Port(
        clk : in std_logic;
        reset : in std_logic;
        A : in input_3d_vector := (others => (others => (others => 0)));
        B : in input_3d_vector := (others => (others => (others => 0)));
        C : out integer range 0 to 35
        );
end entity;

architecture Behavioral of mult_var is
    attribute use_dsp : string;
    attribute use_dsp of Behavioral : architecture is "yes"; 
    begin
    process(clk,reset,A,B)
                variable sum : integer := 0;
                variable conv_sum : integer := 0;
                
 ---------------- filter variables
                constant k_height  : integer := 3;
                constant k_width   : integer := 3;
                constant k_depth   : integer := 3;
                begin
                    if reset = '1' then
                        C <= 0;
                    elsif falling_edge(clk) then  
                       for k_d in 0 to (k_depth - 1) loop
                           for k_h in 0 to (k_height - 1) loop
                              for k_w in 0 to (k_width - 1) loop
                                  conv_sum := conv_sum + A((k_h), (k_w), (k_d)) * B(k_h, k_w, k_d);
                               end loop;
                            end loop;
                            sum := conv_sum;   
                        end loop;  
                        report "internal C : " & integer'image(sum);
                        C <= sum; 
                        conv_sum:=0;     
                    end if;    
            end process;     
    
end Behavioral; 
-- ----------------------------------------------------------------------Second Entity 

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.math_real.ALL;

library work;
use work.conv_package.all;

entity YOLO_VHDL_Source is 
    port(
        CLK : in std_logic;
        reset : in std_logic;
        kernel : in integer_4d_vector;
        img : in integer_3d_vector;
        new_img : out output
        );       
end YOLO_VHDL_Source;

architecture Behavioral of YOLO_VHDL_Source is  
 
constant i_height  :integer := 8; 
constant i_width   :integer := 8;
constant i_depth   :integer := 3; 
constant k_height  : integer := 3;
constant k_width   : integer := 3;
constant k_depth   : integer := 3;
constant k_filters : integer := 16; 

--------------------- DSP I/O ----------------------
signal sub_result : integer := 0;
signal im_elment :  input_3d_vector := (others => (others => (others => 0))) ;
signal filter_elment :  input_3d_vector := (others => (others => (others => 0)));

    component mult_var
        Port(
        clk : in std_logic;
        reset : in std_logic;
        A : in input_3d_vector := (others => (others => (others => 0)));
        B : in input_3d_vector := (others => (others => (others => 0)));
        C : out integer range 0 to 35
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
        
    -- kernels variables
    variable n_i_height : integer := (i_height - k_height) + 1; 
    variable n_i_width  : integer  := (i_width - k_width) + 1; 
    variable n_i_depth  : integer  := (i_depth - k_depth) + 1; 
    
    ------------------- loop variables
    variable conv_sum   : integer := 0;
    variable d : integer :=0;
    variable sub : integer :=0;
    variable h : integer :=0;
    variable w : integer :=0;
    variable k_f : integer :=0;
    variable till_d_computed : boolean := false; 
    
    ---------------- mapped to dsp
    variable img_3d : input_3d_vector :=(others => (others => (others => 0)));
    variable flt_3d : input_3d_vector :=(others => (others => (others => 0)));

    
    begin
        if reset ='1' then                          
        elsif rising_edge(clk) then
        
          if till_d_computed = false then
                if k_f < (k_filters) then
                     for k_d in 0 to (k_depth - 1) loop
                         for k_h in 0 to (k_height - 1) loop
                             for k_w in 0 to (k_width - 1) loop
                                 img_3d(k_h, k_w, k_d) :=  img((h+ k_h), (w + k_w), (d + k_d));
                                 flt_3d(k_h, k_w, k_d) :=  kernel(k_h, k_w, k_d, k_f);
                             end loop;
                          end loop; 
                     end loop;  
                 end if; 
   
                im_elment <= img_3d;
                filter_elment <= flt_3d; 
                 
                if k_f > 0 then          ------ delay assignment
                   new_img(h,w,k_f-1) <= sub_result;
                end if;
                k_f := k_f + 1;
             
                report "result: " & integer'image(sub_result);
     
           end if;
     
            
            if k_f = (k_filters)+1 then
                   w:= w + 1;
                   k_f := 0;
            end if;
                   
            if w = (n_i_width) then
                   h := h + 1;
                   w := 0;
            end if;
     
            if h = (n_i_height) then
                   d := d + 1;
                   h := 0;
            end if;

             if d = (n_i_depth) then
             till_d_computed := true;  
                     d := 0;
                     h := 0;
                     w := 0;
                     k_f := 0;
             end if;    
                            
        end if;
    end process;
end Behavioral; 