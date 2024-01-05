-- ----------------------------------------------------------------------First Entity 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package conv_package is   
    type output is array(Natural range <>, Natural range <>, Natural range <>) of real; 
    type integer_3d_vector is array(0 to 7, 0 to 7, 0 to 2) of integer;
    type integer_4d_vector is array(0 to 2, 0 to 2, 0 to 2, 0 to 15) of integer;
    type input_3d_vector is array(0 to 2, 0 to 2, 0 to 2) of integer range 0 to 15;
    type float_1d_vector is array(Natural range <>) of real;
    type float_3d_vector is array(0 to 5, 0 to 5, 0 to 15) of real;
    
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
                       -- report "internal C : " & integer'image(sum);
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
        new_img : out output (0 to (((n_i_height - 2) / stride) - 1), 0 to (((n_i_width - 2) / stride) - 1), 0 to (i_filters - 1)) := (others => (others => (others => 0.0)))
        );       
end YOLO_VHDL_Source;

architecture Behavioral of YOLO_VHDL_Source is  

--signal temp_img : float_3d_vector;
constant img : integer_3d_vector :=
   (((0, 7, 8),(0, 7, 8), (5, 8, 8),(9, 3, 1),(8, 5, 8),(2, 9, 3), (3, 7, 8),(8, 5, 1)),
    ((10, 6, 10),(8, 4, 8),(7, 7, 2),(7, 8, 5),(5, 7, 2),(4, 6, 2),(3, 4, 3),(3, 7, 2)),
((3, 8, 4),(7, 0, 4),(6, 6, 4),(1, 6, 0),(3, 9, 4),(9, 3, 4),(9, 1, 5),(3, 1, 4)),
((0, 1, 9), (3, 5, 1), (2, 9, 9), (3, 5, 5), (4, 4, 2), (6, 6, 2), (1, 1, 6), (4, 4, 1)),
    ((8, 10, 2), (3, 4, 4), (1, 1, 9), (5, 5, 6), (6, 0, 3), (8, 5, 10), (10, 6, 4), (9, 0, 1)),
    ((4, 1, 4), (7, 8, 8), (4, 5, 10), (8, 4, 9), (8, 4, 1), (1, 6, 9), (7, 2, 3), (2, 8, 6)),
((9, 9, 8), (3, 8, 3), (6, 4, 4), (9, 2, 10), (4, 7, 8), (6, 5, 4), (2, 4, 8), (5, 2, 8)),
((10, 5, 8), (6, 5, 4), (1, 4, 2), (2, 10, 5), (4, 3, 9), (6, 6, 0), (5, 6, 2), (1, 8, 4)));  

    constant kernel : integer_4d_vector :=
 (
(((7, 8, 9, 0, 9, 4, 8, 8, 5, 8, 8, 7, 10, 4, 9, 6), (0, 5, 8, 8, 4, 1, 1, 7, 9, 10, 7, 10, 1, 9, 9, 10), (0, 1, 0, 4, 4, 2, 9, 6, 9, 6, 6, 2, 6, 8, 3, 6)),
((1, 2, 5, 0, 0, 0, 7, 4, 5, 9, 2, 3, 4, 6, 3, 4), (8, 8, 10, 0, 1, 3, 2, 6, 1, 1, 8, 0, 8, 9, 9, 9), (2, 5, 10, 0, 5, 8, 0, 4, 1, 5, 10, 3, 3, 6, 7, 5)),
((6, 8, 5, 3, 7, 5, 8, 1, 2, 9, 3, 10, 5, 6, 9, 8), (2, 1, 4, 5, 2, 8, 4, 2, 1, 1, 4, 3, 1, 1, 7, 9), (1, 8, 8, 8, 1, 6, 8, 6, 1, 2, 8, 2, 3, 6, 10, 5))),
(((5, 2, 8, 4, 7, 3, 5, 7, 5, 1, 10, 7, 9, 8, 9, 9), (7, 9, 7, 2, 8, 8, 7, 4, 5, 9, 1, 1, 9, 7, 3, 7), (8, 10, 4, 5, 9, 5, 1, 4, 8, 8, 0, 3, 8, 5, 5, 4)),
((4, 8, 3, 6, 10, 1, 4, 8, 1, 7, 0, 9, 9, 8, 8, 7), (9, 9, 7, 2, 9, 5, 7, 9, 0, 3, 0, 6, 3, 1, 6, 2), (2, 8, 1, 8, 7, 2, 4, 4, 3, 7, 5, 4, 3, 8, 8, 5)),
((7, 10, 10, 8, 1, 6, 5, 6, 3, 9, 9, 4, 5, 2, 8, 5), (2, 9, 3, 1, 5, 5, 9, 3, 4, 5, 8, 7, 1, 2, 2, 2), (4, 4, 6, 7, 1, 10, 10, 2, 10, 1, 4, 6, 3, 9, 0, 2))),
       (((8, 9, 3, 2, 7, 8, 6, 5, 7, 7, 7, 2, 6, 9, 5, 6), (1, 10, 8, 9, 2, 8, 4, 4, 0, 4, 0, 2, 9, 1, 1, 1), (9, 9, 9, 2, 7, 1, 7, 6, 7, 5, 3, 7, 5, 6, 6, 3)),
((10, 0, 7, 6, 4, 4, 9, 8, 6, 5, 8, 6, 0, 6, 5, 4), (6, 4, 7, 3, 0, 3, 0, 8, 5, 5, 1, 6, 5, 10, 1, 3), (3, 2, 5, 1, 7, 4, 2, 3, 4, 8, 5, 1, 4, 4, 4, 5)),
((5, 9, 9, 8, 7, 1, 1, 5, 10, 7, 2, 4, 3, 9, 6, 10), (10, 1, 7, 1, 1, 2, 7, 0, 4, 6, 5, 2, 3, 9, 4, 8), (2, 3, 2, 6, 4, 10, 4, 2, 8, 9, 9, 1, 1, 1, 4, 4)))
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
    variable temp_img : float_3d_vector;   
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
    variable conv_done : boolean := false; 
    variable batch_norm_done : boolean := false;
    variable activation_done : boolean := false;
    variable maxpool_done : boolean := false;
    ---------------- mapped to dsp
    variable img_3d : input_3d_vector :=(others => (others => (others => 0)));
    variable flt_3d : input_3d_vector :=(others => (others => (others => 0)));
    
        -- batch norm variables
    variable x : real := 0.0;
    variable x_norm : real := 0.0;
    variable y : real := 0.0;
    
        -- activation variables
    variable act_x : real := 0.0;
    
        -- max pool variables
    variable max_val : real := 0.0;
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
                                 img_3d(k_h, k_w, k_d) :=  img((h+ k_h), (w + k_w), (d + k_d));
                                 flt_3d(k_h, k_w, k_d) :=  kernel(k_h, k_w, k_d, k_f);
                             end loop;
                          end loop; 
                     end loop;  
                 end if; 
   
                im_elment <= img_3d;
                filter_elment <= flt_3d; 
                 
                if k_f > 0 then          ------ delay assignment
                   --new_img(h,w,k_f-1) <= sub_result;
                   temp_img(h,w,k_f-1) := real(sub_result);
                  -- report "result: " & integer'image(integer(temp_img(h,w,k_f-1)));
                end if;
                k_f := k_f + 1;
             
     
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
             conv_done := true;  
                     d := 0;
                     h := 0;
                     w := 0;
                     k_f := 0;
             end if;       
             
       if conv_done = true and batch_norm_done = false then
       report "calculating:" ;
             -- perform batchNorm 
            for h in 0 to (n_i_height - 1) loop
                for w in 0 to (n_i_width -1) loop
                   for d in 0 to (k_filters - 1) loop
                      x := temp_img(h,w,d);
                       x_norm := (x - moving_mean(d)) / ((moving_variance(d) - epsilon) ** 0.5);
                       y := (gamma(d) * x_norm) + beta(d);
                        temp_img(h, w, d) := y;
                        report "result: " & integer'image(integer(temp_img(h,w,d)));
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
                          temp_img(h, w, d) := -0.01 * act_x;    
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
        end if; 

        end if;
    end process;

end Behavioral; 