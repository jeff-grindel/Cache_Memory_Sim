--Bus Model Test Bench

--TESTBENCH
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register_Data_Test is
end entity;

architecture behave of Register_Data_Test is

--declaration of the Behaviral Encoder
COMPONENT Register_Data is
   port (Reg_Num: in std_logic_vector(4 downto 0);		--5-bit Read Reg. 1
		 Data_In: in std_logic_vector(31 downto 0));
end COMPONENT;

--Declaration of test signal Inputs
signal TB_Reg_Num :  std_logic_vector(4 downto 0);
signal TB_Data_In :  std_logic_vector(31 downto 0);

begin
	uut: Register_Data 
		PORT MAP (Reg_Num => TB_Reg_Num,
		   		  Data_In => TB_Data_In);
	
  TB_Reg_Num_Gen : process
  begin 
	 TB_Reg_Num <= "10011" after 0 ns, --Load
				   "10110" after 20 ns,	--Store
				   "10001" after 40 ns; --Others
	wait;
  end process TB_Reg_Num_Gen;
  
  TB_Data_In_Gen : process
  begin 
	 TB_Data_In <= x"00110011" after 0 ns, --Load
				   x"00220022" after 20 ns,	--Store
				   x"00440044" after 40 ns; --Others
	wait;
  end process TB_Data_In_Gen;
  
  
  
end architecture behave;	


		



