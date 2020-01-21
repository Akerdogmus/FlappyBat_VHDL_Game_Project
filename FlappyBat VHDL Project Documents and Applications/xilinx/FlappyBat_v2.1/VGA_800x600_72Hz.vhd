----------------------------------------------------------------------------------
-- Creators :        Alim Kerem ERDOÐMUÞ & Burak Can Fazla
-- Module Name :     Display - Behavioral
-- Project Name :    FlappyBat
-- Target Devices :  Spartan3E
-- Description :     Display Config 
-- Date :            2019-12-25
-- Version :         1.2.1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;


entity VGA_800x600_72Hz is
    Port ( clk50 : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           pos_x : in  STD_LOGIC_VECTOR (10 downto 0);
           pos_y : in  STD_LOGIC_VECTOR (10 downto 0);
           h_sync : out  STD_LOGIC;
           v_sync : out  STD_LOGIC;
           red : out  STD_LOGIC;
           green : out  STD_LOGIC;
           blue : out  STD_LOGIC;
           blank : out STD_LOGIC_VECTOR  (15 downto 0);
			  LED : out std_logic_vector(7 downto 0)
			  );
end VGA_800x600_72Hz;

architecture Behavioral of VGA_800x600_72Hz is

		signal hcs : unsigned(10 downto 0) := "00000000000";  --horizontal counter
		signal vcs : unsigned(10 downto 0) := "00000000000";  --vertical counter
		
		constant h_size : unsigned(10 downto 0) := "10000010000"; -- 1040 (64 + 120 + 800 + 56)   
		constant h_sync_start : unsigned(10 downto 0) := "01101011000"; -- 856 (800 + 56)
		constant h_sync_end : unsigned(10 downto 0) := "01111010000"; --(800 + 56 + 120)
    
		constant v_size : unsigned(10 downto 0) := "01010011010"; -- 666 (23 + 6 + 600 + 37)
		constant v_sync_start : unsigned(10 downto 0) := "01001111101"; --(600 + 37)
		constant v_sync_end : unsigned(10 downto 0) := "01010000011"; --(600 + 37 + 6)
		
		signal endline : std_logic := '0'; -- enable vertical counter
		signal visible : std_logic := '1'; -- 1 if hcs and vcs are in display area
		
		constant pointer_size : unsigned(10 downto 0) := "00000010100";
		constant bug_size : unsigned(10 downto 0) :=     "00000010111";
      
      signal x_bug : unsigned(10 downto 0) := "00011001000"; 
      signal y_bug : unsigned(10 downto 0) := "00000000000";  
      signal bug_counter : unsigned(16 downto 0) := "10100010110000101"; 
      signal x_counter : unsigned(10 downto 0) := "00000000000";
      --signal lifes : unsigned(2 downto 0) := "111";
      --signal life_signal : std_logic := '0';
      
      constant box_size_x1 : unsigned(10 downto 0) :=     "00010010110";--150
		constant box_size_y1 : unsigned(10 downto 0) :=     "00011111010";--250
		constant box_size_x2 : unsigned(10 downto 0) :=     "00010010110";--150
		constant box_size_y2 : unsigned(10 downto 0) :=     "00001100100";--100
		signal x1_box : unsigned(10 downto 0) := "00011100000";
		signal y1_box : unsigned(10 downto 0) := "00000000000";
		signal x2_box : unsigned(10 downto 0) := "00011100000";
		signal y2_box : unsigned(10 downto 0) := "00000000000"; 		
      signal box_counter : unsigned(16 downto 0) := "10101110110000101";
		signal y_box_counter : unsigned(10 downto 0) := "00000000000";
		
		signal score : std_logic_vector (7 downto 0);
      signal score1 : std_logic_vector (7 downto 0);
		--signal score2 : std_logic_vector (7 downto 0);
		--signal score3 : std_logic_vector (7 downto 0);

begin
      
      timer : process(clk50)
      begin
         if rising_edge(clk50) then
            if (hcs = 1039) then
               hcs <= "00000000000";
               if (vcs = 665) then
                  vcs <= "00000000000";
               else 
                  vcs <= vcs + 1;
               end if;
            else
               hcs <= hcs + 1;
            end if;
         end if;
      end process timer;
		
		h_sync <= '1' when (hcs >= h_sync_start and hcs < h_sync_end) else '0';
		v_sync <= '1' when (vcs >= v_sync_start and vcs < v_sync_end) else '0';
		visible <= '1' when (((hcs >= 0 ) and (hcs < 800)) and ((vcs >=0) and (vcs < 600))) else '0';
      
      blank <= "1111111111111110";	
    
      draw_pointer : process(clk50, pos_x, pos_y)
      begin
			if rising_edge(clk50) and visible = '1' then
				green <= '0';
            
				if (hcs > unsigned(pos_x) - 2 and 
            signed(hcs) < signed(pos_x) + 2 and 
            signed(vcs) > signed(pos_y) - signed(pointer_size) and 
            signed(vcs) < signed(pos_y) + signed(pointer_size)) or
            (vcs > unsigned(pos_y) - 2 and 
            signed(vcs) < signed(pos_y) + 2 and 
            signed(hcs) > signed(pos_x) - signed(pointer_size) and 
            signed(hcs) < signed(pos_x) + signed(pointer_size)) or
				(hcs > unsigned(pos_x) - 2 and 
            signed(hcs) < signed(pos_x+10) + 15 and 
            signed(vcs) > signed(pos_y) - signed(pointer_size-18) and 
            signed(vcs) < signed(pos_y) + signed(pointer_size-10)) or
				(vcs > unsigned(pos_y) - 2 and 
            signed(vcs) < signed(pos_y) + 15 and 
            signed(hcs) > signed(pos_x) - signed(pointer_size-18) and 
            signed(hcs) < signed(pos_x) + signed(pointer_size-10)) or
			   (hcs > unsigned(pos_x) - 2 and 
            signed(hcs) < signed(pos_x+10) + 15 and 
            signed(vcs) > signed(pos_y) - signed(pointer_size-10) and 
            signed(vcs) < signed(pos_y) + signed(pointer_size-18)) or
				(vcs > unsigned(pos_y) - 2 and 
            signed(vcs) < signed(pos_y) + 15 and 
            signed(hcs) > signed(pos_x) - signed(pointer_size-10) and 
            signed(hcs) < signed(pos_x) + signed(pointer_size-18)) then
					green <= '1';	
				end if;
			end if;
		end process draw_pointer;
      
      bug_move : process(clk50, pos_x, pos_y)
      begin
          if rising_edge(clk50) and visible = '1' then
            if (x_counter < 750) then
               x_counter <= x_counter + 1;
            else
               x_counter <= "00000000000";
            end if;
            if (bug_counter > 0) then
               bug_counter <= bug_counter -1;
            else
               bug_counter <="10100010110000101";
               y_bug <= y_bug +1;
					x_bug <= x_bug -1;
            end if;
            if(hcs > x_bug and hcs < x_bug + bug_size and vcs > y_bug and vcs < y_bug + bug_size) then
               blue <= '1';
            else 
               blue <= '0';
            end if;

            if (y_bug > 570) then
               y_bug <= "00000000000";
               x_bug <= x_counter;
					
            end if;
            --event
            if (signed(pos_x) >= signed(x_bug) and signed(pos_x) <= signed(x_bug) + signed(bug_size) and
            signed(pos_y) >= signed(y_bug) and signed(pos_y) <= signed(y_bug) + signed(bug_size)) then
               y_bug <= "00000000000";
					--score2 <= score2 + "00000010";
               if (signed(x_bug)>680) then
                  x_bug <= "00000000000";
               else 
                  x_bug <= x_counter;
               end if;
            end if;
         end if;          
      end process bug_move;
      
    
      box_move : process(clk50, pos_x, pos_y)
      begin
          if rising_edge(clk50) and visible = '1' then
				
            if (y_box_counter < 420) then               
               y_box_counter <= y_box_counter + 4;
            else
               y_box_counter <= "00000000000";
            end if;
			
            if (box_counter > 0) then                   
               box_counter <= box_counter - 1;
            else
               box_counter <="11110100001001000"; -- 65000
               x1_box <= x1_box - 1;
					x2_box <= x2_box - 2;
            end if;
            
            if(hcs > x1_box and hcs < x1_box + box_size_x1 and    
					vcs > y1_box and vcs < y1_box + box_size_y1) then
					red <= '1';
				--else
				--	red <= '0';
				--end if;
				
				elsif(hcs > x2_box and hcs < x2_box + box_size_x2 and    
					vcs > y2_box and vcs < y2_box + box_size_y2) then
					red <= '1';				
				else
					red <= '0';
				end if;

            if (x1_box < 2) then            
               x1_box <= "01011101110";
               y1_box <= y_box_counter;
					score1 <= score1 + 1;
            end if;
            if (x2_box < 2) then            
               x2_box <= "01100100000";
               y2_box <= y_box_counter - 6;
					score <= score + 1;
            end if;				
            --event
            if (signed(pos_x) >= signed(x1_box) and signed(pos_x) <= signed(x1_box) + signed(box_size_x1) and
            signed(pos_y) >= signed(y1_box) and signed(pos_y) <= signed(y1_box) + signed(box_size_y1) ) then
               x1_box <= "01011101110";
					score1 <= "00000000";
					score <= "00000000";


               if (signed(y1_box) > 420) then
                  y1_box <= "00000000000";
               else 
                  y1_box <= y_box_counter;
               end if;
            elsif (signed(pos_x) >= signed(x2_box) and signed(pos_x) <= signed(x2_box) + signed(box_size_x2) and
            signed(pos_y) >= signed(y2_box) and signed(pos_y) <= signed(y2_box) + signed(box_size_y2) ) then
               x2_box <= "01100100000";
					score <= "00000000";
					score1 <= "00000000";
               if (signed(y2_box) > 420) then
                  y2_box <= "00000000000";
               else 
                  y2_box <= y_box_counter - 6;
               end if;				
            else
               
            end if;
         end if; 
      end process box_move;
		
		LED <= score + score1; --+score2;
      --Line(2 downto 0) <= std_logic_vector(lifes);
      

end Behavioral;
