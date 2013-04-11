library ieee;
use ieee.std_logic_1164.all;

entity Cache_Memory_Dataflow_Test is
end entity;

architecture behave of Cache_Memory_Dataflow_Test  is


 COMPONENT Cache_Memory_Dataflow is
  port (t_IAddr : in std_logic_vector(31 downto 0);
		t_IHC : in std_logic_vector(0 downto 0); --I-Cahche hit flag 1: Hit 0: Miss
		t_DHC : in std_logic_vector(0 downto 0);
		t_ALU_DONE: out std_logic_vector (0 downto 0);
		t_LW_DONE: out std_logic_vector (0 downto 0);
		t_SW_DONE: out std_logic_vector (0 downto 0);
		t_Data_Out: out std_logic_vector (31 downto 0)); --5 bit register number
end COMPONENT; 

 --Declaration of test signal Inputs
signal TB_aIAddr :  std_logic_vector(31 downto 0);
signal TB_aIHC :  std_logic_vector(0 downto 0); --I-Cahche hit flag 1: Hit 0: Miss
signal TB_aDHC :  std_logic_vector(0 downto 0); --D-Cahche hit flag 1: Hit 0: Miss
 --Declaration of test signal Outputs
signal TB_ALU_DONE:  std_logic_vector (0 downto 0); 
signal TB_LW_DONE: std_logic_vector (0 downto 0);
signal TB_SW_DONE: std_logic_vector (0 downto 0);
signal TB_Data_Out:  std_logic_vector (31 downto 0);   

 
begin
	uut: Cache_Memory_Dataflow PORT MAP (
			t_IAddr=>TB_aIAddr,
			t_IHC => TB_aIHC,
			t_DHC => TB_aDHC,
			t_ALU_DONE=> TB_ALU_DONE,
			t_LW_DONE=> TB_LW_DONE,
			t_SW_DONE=> TB_SW_DONE,
			t_Data_Out=>TB_Data_Out);
			
	aAddr_Gen : process 
	begin
		TB_aIAddr <= --x"00000200" after 0 ns;		--Load Address
					  x"00000288" after 0 ns;		--Store Address
					 --  x"00000010" after 0 ns;		--Add Address
					-- x"00000018" after 0 ns;		--BEQ Address
					-- x"00000020" after 0 ns;		--BNE Address
					 -- x"00000028" after 0 ns;		--LUI Address
					 
	wait;
	end process aAddr_Gen;
	
	aIHC_Gen : process 
	begin
		TB_aIHC <= "1" after 0 ns;	--ICache Hit
				 --"0" after 0 ns;	--ICache Miss
	wait;
	end process aIHC_Gen;
	
	aDHC_Gen : process 
	begin
		TB_aDHC <= --"1" after 0 ns;	--DCache Hit
				 "0" after 0 ns;	--DCache Miss
	wait;
	end process aDHC_Gen;
	
	

end architecture behave;	

