--Bus: Used to transfer words and blocks between cahce and memeory.
--Bandwidth of 32words/cycle
--Assume that the bw will never be exceeded and will always take 
--up the full cycle

library ieee;
use ieee.std_logic_1164.all;

entity Bus_Model is
   port (Addr : in std_logic_vector; 	
		 IHC : in std_logic_vector (0 downto 0);
	     DHC : in std_logic_vector (0 downto 0); 
		 R_W : in std_logic_vector (0 downto 0);
		 C_Type : in std_logic_vector (0 downto 0);
		 Data_In : in std_logic_vector (31 downto 0);
		 Blk_In : in std_logic_vector (255 downto 0);
		
		 Addr_Out: out std_logic_vector; 
		 IHC_Out: out std_logic_vector (0 downto 0); 
	     DHC_Out : out std_logic_vector (0 downto 0);
		 R_W_Out : out std_logic_vector (0 downto 0);
		 C_Type_Out : out std_logic_vector (0 downto 0);
		 Data_Out : out std_logic_vector (31 downto 0);
		 Blk_Out : out std_logic_vector(255 downto 0)); 
end entity Bus_Model;

architecture behave of Bus_Model is 
	constant cycle_time : time := 10 ns;

begin 
	Addr_Out <= Addr after cycle_time;
	IHC_Out <= IHC after cycle_time;
	DHC_Out <= DHC after cycle_time;
	R_W_Out <= R_W after cycle_time;
	C_Type_Out <= C_Type after cycle_time;
	Data_Out <= Data_In after cycle_time;
	Blk_Out <= Blk_In after cycle_time;
	
end architecture behave;


