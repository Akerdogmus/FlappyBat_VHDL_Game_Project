----------------------------------------------------------------------------------
-- Creators :        Alim Kerem ERDOÐMUÞ & Burak Can Fazla
-- Module Name :     pointer_move - Behavioral
-- Project Name :    FlappyBat
-- Target Devices :  Spartan3E
-- Description :     Bat Controller Module
-- Date :            2019-12-25
-- Version :         1.2.1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity pointer_move is
    Port ( clk50 : in  STD_LOGIC;
			  upButon,downButon : in STD_LOGIC;
           pos_x : out  STD_LOGIC_VECTOR (10 downto 0);
           pos_y : out  STD_LOGIC_VECTOR (10 downto 0)
			);

end pointer_move;

architecture Behavioral of pointer_move is

	signal pointer_x : signed(10 downto 0) := "00001100100";		-- 100
	signal pointer_y : signed(10 downto 0) := "00100101100"; 	-- 300
	constant y_min : signed(10 downto 0) := 	"00000010100";   --20
	constant y_max : signed(10 downto 0) := 	"01001000100";   --580
	
	
	begin
	
		bat_move : process(clk50, upButon, downButon)
		begin
			if rising_edge(clk50) then	
			--move of pointer
				if((upButon='1') and (downButon='0')) then
					pointer_y <= pointer_y +"00000001110";	--vertical move
				elsif((upButon='0') and (downButon='1')) then
					pointer_y <= pointer_y -"00000001110";	--vertical move
				else 
					pointer_y <= pointer_y;
				end if;	
				
				if pointer_y < y_min then
                pointer_y <= y_min;
            elsif pointer_y > y_max then
                pointer_y <= y_max;
				end if;					
		
		end if;
		
		end process bat_move;
		pos_x <= std_logic_vector(pointer_x);
		pos_y <= std_logic_vector(pointer_y);
end Behavioral;

