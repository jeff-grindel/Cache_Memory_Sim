--Combination of DCache, Mem
--TESTBENCH
library ieee;
use ieee.std_logic_1164.all;

entity DCache_Dataflow_Test is
end entity;

architecture behave of DCache_Dataflow_Test  is

--declaration of the Behaviral Encoder
COMPONENT DCache_Dataflow is
	port (aDAddr : in std_logic_vector (31 downto 0);
		  aData : in std_logic_vector (31 downto 0);
		  aBlk : in std_logic_vector (255 downto 0);
		  aALU_Done : in std_logic_vector (0 downto 0);
	      aR_W : in std_logic_vector (0 downto 0);
		  aDHC : in std_logic_vector (0 downto 0);
		  aType : in std_logic_vector (0 downto 0);
		  
		  aOut : out std_logic_vector (31 downto 0);
		  aLW_Done : out std_logic_vector (0 downto 0);
		  aSW_Done : out std_logic_vector (0 downto 0));
end COMPONENT;

--Declaration of test signal Inputs
signal TB_aDAddr: std_logic_vector(31 downto 0);								
signal TB_aData: std_logic_vector(31 downto 0);								
signal TB_aBlk: std_logic_vector(255 downto 0);								
signal TB_aALU_Done: std_logic_vector(0 downto 0);								
signal TB_aR_W: std_logic_vector(0 downto 0);								
signal TB_aDHC: std_logic_vector(0 downto 0);								
signal TB_aType: std_logic_vector(0 downto 0);								
							

--Declaration of test signal Outputs
signal TB_aOut: std_logic_vector(31 downto 0);		
signal TB_aLW_Done: std_logic_vector(0 downto 0);	
signal TB_aSW_Done: std_logic_vector(0 downto 0);		



begin
	uut: DCache_Dataflow PORT MAP (
			aDAddr => TB_aDAddr,
			aData => TB_aData, 
			aBlk => TB_aBlk,
			aALU_Done => TB_aALU_Done,
			aR_W => TB_aR_W,
			aDHC => TB_aDHC,
			aType => TB_aType,
			aOut => TB_aOut,
			aLW_Done => TB_aLW_Done,
			aSW_Done => TB_aSW_Done);
			
	DAddr_Gen : process 
	begin
		TB_aDAddr <= x"00000000" after 0 ns;
	wait;
	end process DAddr_Gen;
	
	Data_Gen : process 
	begin
		TB_aData <= x"33334444" after 0 ns;
	wait;
	end process Data_Gen;
	
	Blk_Gen : process 
	begin
		--TB_aBlk <= x"1111222211112222111122221111222211112222111122221111222211112222" after 10000 ns;
	wait;
	end process Blk_Gen;
	
	ALU_Done_Gen : process 
	begin
		TB_aALU_Done <= "0" after 0 ns;
	wait;
	end process ALU_Done_Gen;
	
	R_W_Gen : process 
	begin	
		TB_aR_W <= "0" after 0 ns;	--load is 1
	wait;
	end process R_W_Gen;
	
	DHC_Gen : process 
	begin
		TB_aDHC <= "0" after 0 ns;	
	wait;
	end process DHC_Gen;
	
	Type_Gen : process 
	begin
		TB_aType <= "1" after 0 ns;
	wait;
	end process Type_Gen;
	
	

end architecture behave;	
