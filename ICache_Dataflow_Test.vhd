library ieee;
use ieee.std_logic_1164.all;

entity ICache_Dataflow_Test is
end entity;

architecture behave of ICache_Dataflow_Test  is


 COMPONENT ICache_Dataflow is
  port (aIAddr : in std_logic_vector(31 downto 0);
		aIHC : in std_logic_vector(0 downto 0);
		aALU_DONE: out std_logic_vector (0 downto 0); 
		aR_W: out std_logic_vector (0 downto 0); 
		aDAddr: out std_logic_vector (31 downto 0);    
		aData: out std_logic_vector (0 downto 0); 
		aData_reg: out std_logic_vector (31 downto 0));
end COMPONENT; 

 --Declaration of test signal Inputs
signal TB_aIAddr :  std_logic_vector(31 downto 0);
signal TB_aIHC :  std_logic_vector(0 downto 0); --I-Cahche hit flag 1: Hit 0: Miss
 --Declaration of test signal Outputs
signal TB_ALU_DONE:  std_logic_vector (0 downto 0); 
signal TB_R_W:  std_logic_vector (0 downto 0); 
signal TB_DAddr:  std_logic_vector (31 downto 0);   
signal TB_Data_reg:  std_logic_vector (31 downto 0);
 
begin
	uut: ICache_Dataflow PORT MAP (
			aIAddr=>TB_aIAddr,
			aIHC => TB_aIHC,
			aALU_DONE=> TB_ALU_DONE,
			aR_W=> TB_R_W,
			aDAddr=> TB_DAddr,
			aData_reg=>TB_Data_reg);
			
	aAddr_Gen : process 
	begin
		TB_aIAddr <=-- x"00000200" after 0 ns;
					 x"00000288" after 0 ns;
					-- x"00000010" after 0 ns;
					-- x"00000018" after 0 ns;
					-- x"00000020" after 0 ns;
					-- x"00000028" after 0 ns;
					 
	wait;
	end process aAddr_Gen;
	
	aIHC_Gen : process 
	begin
		TB_aIHC <= "0" after 0 ns;
	wait;
	end process aIHC_Gen;
	
	

end architecture behave;	

