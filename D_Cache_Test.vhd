--I-Cache Test Bench

--TESTBENCH
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity D_Cache_Test is
end entity;

architecture behave of D_Cache_Test is

--declaration of the Behaviral Encoder
COMPONENT D_Cache is
   port (DAddr : in std_logic_vector; 	--Data address
		 DHC : in std_logic_vector(0 downto 0); -- 1 bit DCache Flag Input (1 for hit, 0 for miss, given by testbecnh)
	     Data_In : in std_logic_vector(31 downto 0); --32-bit data in
		 Blk_In: in std_logic_vector(255 downto 0);	--Block size of 8 words
		 R_W : in std_logic_vector(0 downto 0); -- 1 for load, 0 for store
		 ALU_Done : in std_logic_vector (0 downto 0); --1 for done, 0 for not done
		 LW_Done : out std_logic_vector (0 downto 0); --1 for done, 0 for not done
		 SW_Done : out std_logic_vector (0 downto 0); --1 for done, 0 for not done
		 D_Cache_Data: out std_logic_vector(31 downto 0));	--data output of 32-bit memory
end COMPONENT;

--Declaration of test signal Inputs
signal TB_DAddr : std_logic_vector (7 downto 0);
signal TB_DHC : std_logic_vector(0 downto 0);	
signal TB_Data_In : std_logic_vector(31 downto 0);
signal TB_Blk_In: std_logic_vector(255 downto 0);
signal TB_R_W : std_logic_vector(0 downto 0);
signal TB_ALU_Done : std_logic_vector(0 downto 0);


--Declaration of test signal Outputs	
signal TB_LW_Done : std_logic_vector(0 downto 0);
signal TB_SW_Done : std_logic_vector(0 downto 0);
signal TB_D_Cache_Data: std_logic_vector(31 downto 0);

begin
	uut: D_Cache PORT MAP (
			DAddr => TB_DAddr,
			DHC => TB_DHC,
			Data_In => TB_Data_In,
			Blk_In => TB_Blk_In,
			R_W => TB_R_W,
			ALU_Done => TB_ALU_Done,
			LW_Done => TB_LW_Done,
			SW_Done => TB_SW_Done,
			D_Cache_Data => TB_D_Cache_Data);
	
	TB_DAddr_Proc : process
	begin
		TB_DAddr <= x"00" after 0 ns;
		            -- x"01" after 10 ns,
					-- x"02" after 20 ns;
	wait;
	end process TB_DAddr_Proc;
	
	TB_DHC_Proc : process
	begin
		TB_DHC <= "0" after 0 ns;
	wait;
	end process TB_DHC_Proc;
	
	TB_Data_In_Proc : process
	begin
		TB_Data_In <= x"1F1F1F1F" after 0 ns;
	wait;
	end process TB_Data_In_Proc;
	
	TB_Blk_In_Proc : process
	begin
		TB_Blk_In <= x"1111000011110000111100001111000011110000111100001111000011110000" after 20 ns;
	wait;
	end process TB_Blk_In_Proc;
	
	TB_R_W_Proc : process
	begin
		TB_R_W <= "0" after 0 ns;
	wait;
	end process TB_R_W_Proc;	
	
	TB_ALU_Done_Proc : process
	begin
		TB_ALU_Done <= "1" after 0 ns,
				       "0" after 10 ns;
	wait;
	end process TB_ALU_Done_Proc;
	
end architecture behave;	


		
