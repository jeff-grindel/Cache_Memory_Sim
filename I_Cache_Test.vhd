--I-Cache Test Bench

--TESTBENCH
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity I_Cache_Test is
end entity;

architecture behave of I_Cache_Test is

--declaration of the Behaviral Encoder
COMPONENT I_Cache is
   port (IAddr : in std_logic_vector; -- 0x0 - 0x40
		 IHC : in std_logic_vector(0 downto 0); --I-Cahche hit flag 1: Hit 0: Miss
		 Blk_In: in std_logic_vector(255 downto 0);	--Block size of 8 words
		 I_Cache_Data: out std_logic_vector(31 downto 0));	--data output of 32-bit memory
end COMPONENT;

--Declaration of test signal Inputs
signal TB_IAddr : std_logic_vector (7 downto 0);
signal TB_IHC : std_logic_vector(0 downto 0); --I-Cahche hit flag	
signal TB_Blk_In: std_logic_vector(255 downto 0); --1 for read, 0 for write

--Declaration of test signal Outputs	
signal TB_I_Cache_Data: std_logic_vector(31 downto 0);

begin
	uut: I_Cache PORT MAP (
			IAddr => TB_IAddr,
			IHC => TB_IHC,
			Blk_In => TB_Blk_In,
			I_Cache_Data => TB_I_Cache_Data);
			
	TB_IAddr_Gen: process
	begin 
		TB_IAddr <=       x"00" after 0 ns;
						  -- x"08" after 10 ns,
						  -- x"10" after 20 ns,
						  -- x"18" after 30 ns,
						  -- x"20" after 40 ns,
						  -- x"28" after 50 ns,
						  -- x"00" after 60 ns,
						  -- x"08" after 70 ns,
						  -- x"10" after 80 ns,
						  -- x"18" after 90 ns,
						  -- x"20" after 100 ns,
						  -- x"28" after 110 ns;
	wait;
	end process TB_IAddr_Gen;
	
	IHC_GEN: process
	begin
		TB_IHC <= "1" after 0 ns,
				  "0" after 60 ns;
	wait;
	end process IHC_GEN;
	
	Blk_In_Gen: process
	begin
		TB_Blk_In <= x"0000111100001111000011110000111100001111000011110000111100001111" after 0 ns;
	wait;
	end process Blk_In_Gen;
	
end architecture behave;	


		
