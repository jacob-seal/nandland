-- This module is designed for 640x480 with a 25 MHz input clock.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.Pong_Pkg.all;

entity Pong_Score_Ctrl is
  generic (
    g_X_offset : integer  -- Changes for P1 vs P2
    );
  port (
    i_Clk : in std_logic;
    i_score : in integer;
    i_Col_Count : in std_logic_vector(9 downto 0);
    i_Row_Count : in std_logic_vector(9 downto 0);
    
    o_Draw_Score : out std_logic
    );
end entity Pong_Score_Ctrl;

architecture rtl of Pong_Score_Ctrl is

  -- Integer representation of the above 6 downto 0 counters.
  -- Integers are easier to work with conceptually
  signal w_Col_Index : integer range 0 to 2**i_Col_Count'length := 0;
  signal w_Row_Index : integer range 0 to 2**i_Row_Count'length := 0;



  --capture the score 
  signal w_Score : integer;

  signal r_Draw_Score : std_logic;

  signal bitmap : bitmap_type;

  
begin

  w_Col_Index <= to_integer(unsigned(i_Col_Count));
  w_Row_Index <= to_integer(unsigned(i_Row_Count));  



  w_Score <= i_score;

  p_assign_bmp : process (i_Clk)
  begin
    if rising_edge(i_Clk) then

        --conditional assignment of the score to a bitmap
        case w_Score is
            when 0 =>
                bitmap <= c_zero_bmp;
            when 1 =>
                bitmap <= c_one_bmp;
            when 2 =>
                bitmap <= c_two_bmp;
            when 3 =>
                bitmap <= c_three_bmp;
            when 4 =>
                bitmap <= c_four_bmp;
            when 5 =>
                bitmap <= c_five_bmp;    
            when others =>
                bitmap <= c_zero_bmp;
        end case;

    end if;
      
  end process;
  
  


  
  -- draws the current score
  --p_Draw_Score : process (i_Clk)
  --begin
    --if rising_edge(i_Clk) then
      -- Draws in a single column and in a range of rows.
      -- Range of rows is determined by c_Paddle_Height
      
      
      
      
      r_Draw_Score <= '1' when  (
                                            (w_Col_Index - g_X_offset > -1 and
                                            w_Row_Index - c_y_offset_p1_p2 > -1 and
                                            w_Col_Index - g_X_offset < bitmap(0)'high + 1 and
                                            w_Row_Index - c_y_offset_p1_p2 < bitmap'high + 1) and
                                            (bitmap(w_Row_Index - c_y_offset_p1_p2)(w_Col_Index - g_X_offset) = '1')
                                            )
                                     else
                                           '0';
    --end if;                                       
  --end process p_Draw_Score;

  -- Assign output for next higher module to use
  o_Draw_Score <= r_Draw_Score;
  
  
end architecture rtl;
