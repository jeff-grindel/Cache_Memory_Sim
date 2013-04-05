--Memory Test Bench

--TESTBENCH
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory_Test is
end entity;

architecture behave of Memory_Test is

--declaration of the Behaviral Encoder
COMPONENT Memory is
	port (Addr : 	in std_logic_vector(31 downto 0); 	--32-bit Address between 0x0-0x3FF
		  IC_Flag : in std_logic_vector(0 downto 0); -- 1 bit ICache Flag Input (1 for hit, 0 for miss, given by testbecnh)
	      DC_Flag : in std_logic_vector(0 downto 0); -- 1 bit DCache Flag Input (1 for hit, 0 for miss)
		  R_W : 	in std_logic_vector(0 downto 0); --1 for read, 0 for write
		  Data_In : in std_logic_vector(31 downto 0);-- Data input used in SW Instruction
		  Data_Out :	out std_logic_vector(31 downto 0);	--data output of 32-bit memory
		  Blk_Out : 	out std_logic_vector(255 downto 0));	--Block size of 8 words
		 
end COMPONENT;

--Declaration of test signal Inputs
signal TB_Addr : std_logic_vector(31 downto 0);								
signal TB_IC_Flag : std_logic_vector(0 downto 0);
signal TB_DC_Flag : std_logic_vector(0 downto 0);
signal TB_R_W : std_logic_vector(0 downto 0); --1 for read, 0 for write
signal TB_Data_In : std_logic_vector(31 downto 0);								

--Declaration of test signal Outputs	
signal  TB_Data_Out: std_logic_vector(31 downto 0);	--data output of 32-bit memory
signal  TB_Blk_Out: std_logic_vector(255 downto 0);	--Block size of 8 words


begin
	uut: Memory PORT MAP (
			Addr => TB_Addr,
			IC_Flag => TB_IC_Flag,
			DC_Flag => TB_DC_Flag,
			R_W => TB_R_W,
			Data_In => TB_Data_In,
			Data_Out => TB_Data_Out,
			Blk_Out => TB_Blk_Out);
			
	Addr_GEN: process
	begin 
		TB_Addr <= x"00000001" after 0 ns,	--lw
				   x"00000004" after 10 ns,  --sw
				   x"00000008" after 20 ns,  --sw
				   x"0000000C" after 30 ns,  --sw
				   x"00000010" after 40 ns,  --sw
				   x"00000014" after 50 ns,  --sw
				   x"00000000" after 60 ns,	--lw
				   x"00000004" after 70 ns,  --sw
				   x"00000008" after 80 ns,  --sw
				   x"0000000C" after 90 ns,  --sw
				   x"00000010" after 100 ns,  --sw
				   x"00000014" after 110 ns; 
				   
	wait;
	end process Addr_GEN;
	
	IC_Flag_Gen: process
	begin
		TB_IC_Flag <= "0" after 0 ns,
					  "1" after 60 ns;
		
	wait;
	end process IC_Flag_Gen;	
	
	DC_Flag_Gen: process
	begin
		TB_DC_Flag <= "1" after 0 ns,
					  "0" after 60 ns;
		
	wait;
	end process DC_Flag_Gen;
	
	R_W_Gen: process
	begin
		TB_R_W <= "1" after 0 ns,
			      "0" after 60 ns;
	wait;
	end process R_W_Gen;
	
	Data_In_Gen: process
	begin
		TB_Data_In <= x"FFFFFFFF" after 0 ns,
				      x"66666666" after 60 ns,
				      x"77777777" after 70 ns,
				      x"88888888" after 80 ns,
				      x"99999999" after 90 ns,
				      x"AAAAAAAA" after 100 ns,
				      x"BBBBBBBB" after 110 ns;
	wait;
	end process Data_In_Gen;
					  
	
end architecture behave;	


		
