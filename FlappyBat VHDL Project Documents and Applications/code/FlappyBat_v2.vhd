----------------------------------------------------------------------------------
-- Creators :        Alim Kerem ERDOÐMUÞ & Burak Can Fazla
-- Module Name :     FlappyBat - Behavioral
-- Project Name :    FlappyBat
-- Target Devices :  Spartan3E
-- Description :     FlappyBat Game - Introduction to VHDL-FPGA Project
-- Date :            2019-12-25
-- Version :         1.2.1
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity FlappyBat_v2 is
   port ( clk50    : in    std_logic; 
          reset    : in    std_logic; 
          upButon  : in    std_logic;
			 downButon: in    std_logic;			 
          VGA_R    : out   std_logic;
			 VGA_G    : out   std_logic;
			 VGA_B    : out   std_logic;           
          VGA_HS   : out   std_logic;            
          VGA_VS   : out   std_logic;
			 LED		 : out   std_logic_vector (7 downto 0)
);
end FlappyBat_v2;


architecture Behavioral of FlappyBat_v2 is

   --signal D_READY     : std_logic;
   signal POS_X_VAL     : std_logic_vector (10 downto 0);
   signal POS_Y_VAL     : std_logic_vector (10 downto 0);
   signal BLANK_VAL     : std_logic_vector (15 downto 0);
	signal up_buton_sync,down_buton_sync : std_logic;
   --signal LINE_VAL     	: std_logic_vector (63 downto 0);
   
   component VGA_800x600_72Hz
      port ( clk50   : in    std_logic; 
             reset   : in    std_logic; 
             --DataRdy : in    std_logic; 
             pos_x   : in    std_logic_vector (10 downto 0); 
             pos_y   : in    std_logic_vector (10 downto 0); 
             h_sync  : out   std_logic; 
             v_sync  : out   std_logic; 
             red     : out   std_logic; 
             green   : out   std_logic; 
             blue    : out   std_logic; 
             --Line    : out   std_logic_vector (63 downto 0); 
             blank   : out   std_logic_vector (15 downto 0);
				 LED   : out std_logic_vector (7 downto 0)
				 );
   end component;
   
   component pointer_move
      port ( clk50     : in    std_logic; 
             --DataRdy   : in    std_logic; 
				 upButon	  : in 	 std_logic;
				 downButon : in 	 std_logic;
             pos_x     : out   std_logic_vector (10 downto 0); 
             pos_y     : out   std_logic_vector (10 downto 0));
   end component;
	
   component Btn_sync
			Port(	 
  				  btn_up_unsync 	: in  STD_LOGIC;
				  btn_down_unsync : in  STD_LOGIC;
				  clk50 				: in  STD_LOGIC;
				  reset 				: in  STD_LOGIC;
				  up_buton_sync 	: out  STD_LOGIC;
				  down_buton_sync : out  STD_LOGIC
				  );

   end component;	
      
begin

   
   Display : VGA_800x600_72Hz
      port map (
                clk50=>clk50,
                --DataRdy=>D_READY,
                pos_x(10 downto 0)=>POS_X_VAL(10 downto 0),
                pos_y(10 downto 0)=>POS_Y_VAL(10 downto 0),
                reset=>reset,
                blank(15 downto 0)=>BLANK_VAL(15 downto 0),
                red=>VGA_R,
					 green=>VGA_G,
					 blue=>VGA_B,                
                h_sync=>VGA_HS,
                v_sync=>VGA_VS,
					 LED => LED
					 --Line(63 downto 0)=>LINE_VAL(63 downto 0)      
					 );
   
   BAT : pointer_move
      port map (
                clk50=>clk50,
                --DataRdy=>D_READY,
                pos_x(10 downto 0)=>POS_X_VAL(10 downto 0),
                pos_y(10 downto 0)=>POS_Y_VAL(10 downto 0),
					 upButon => up_buton_sync,
					 downButon => down_buton_sync
                );
   Buton_sync : Btn_sync
      port map (
					 clk50=>clk50,
					 reset=>reset,
					 btn_up_unsync => upButon,
					 btn_down_unsync => downButon,
					 up_buton_sync => up_buton_sync,
					 down_buton_sync => down_buton_sync
					 
                );   

   
end Behavioral;


