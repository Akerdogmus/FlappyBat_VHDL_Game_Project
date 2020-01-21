----------------------------------------------------------------------------------
-- Creators :        Alim Kerem ERDOÐMUÞ & Burak Can Fazla
-- Module Name :     Btn_sync - Behavioral
-- Project Name :    FlappyBat
-- Target Devices :  Spartan3E
-- Description :     Butons Syncronization Module
-- Date :            2019-12-25
-- Version :         1.2.1
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Btn_sync is
	Port (  
				  btn_up_unsync 	: in  STD_LOGIC;
				  btn_down_unsync : in  STD_LOGIC;
				  clk50 				: in  STD_LOGIC;
				  reset 				: in  STD_LOGIC;
				  down_buton_sync : out  STD_LOGIC;
				  up_buton_sync   : out  STD_LOGIC
				  );
end Btn_sync;

architecture Behavioral of Btn_sync is

type state is (btns_no_imp,btn_up_imp, btn_up_imp_cont, btn_down_imp, btn_down_imp_cont);
	
	signal present_state, next_state : state;

begin

	-- 1 : calculating the next states
	calc_next_state : process(present_state, btn_up_unsync, btn_down_unsync)
	begin
	
		case present_state is
		
			when btns_no_imp =>
				if btn_up_unsync = '1' then
					next_state <= btn_up_imp;
				elsif btn_down_unsync = '1' then
					next_state <= btn_down_imp;
				else
					next_state <= btns_no_imp;
				end if;
			
			when btn_up_imp =>
				if btn_up_unsync = '1' then
					next_state <= btn_up_imp_cont;
				else
					next_state <= btns_no_imp;
				end if;
			
			when btn_up_imp_cont =>
				if btn_up_unsync = '1' then
					next_state <= btn_up_imp_cont;
				else
					next_state <= btns_no_imp;
				end if;
			
			when btn_down_imp =>
				if btn_up_unsync = '1' then
					next_state <= btn_up_imp;
				elsif btn_down_unsync = '1' then
					next_state <= btn_down_imp_cont;				
				else
					next_state <= btns_no_imp;
				end if;
			
			when btn_down_imp_cont =>
				if btn_up_unsync = '1' then
					next_state <= btn_up_imp;
				elsif btn_down_unsync = '1' then
					next_state <= btn_down_imp_cont;
				else
					next_state <= btns_no_imp;
				end if;
		
		end case;
		
	end process calc_next_state;
	
	
	-- 2 : state transfers
	register_states : process(clk50, reset)
	begin
		
		if reset = '1' then
			present_state <= btns_no_imp;
		elsif rising_edge(clk50) then
			present_state <= next_state;
		end if;
	
	end process register_states;
	
	
	-- 3 : calculation of outputs
	calc_output : process(present_state)
	begin
					
		case present_state is
			
			when btns_no_imp =>
				up_buton_sync <= '0';
				down_buton_sync <= '0';
			when btn_up_imp =>
				up_buton_sync <= '1';
				down_buton_sync <= '0';
			when btn_up_imp_cont =>
				up_buton_sync <= '0';
				down_buton_sync <= '0';
			when btn_down_imp =>
				up_buton_sync <= '0';
				down_buton_sync <= '1';
			when btn_down_imp_cont =>
				up_buton_sync <= '0';
				down_buton_sync <= '0';
			when others =>
				up_buton_sync <= '0';
				down_buton_sync <= '0';
			
		end case;
		
	end process calc_output;

end Behavioral;
