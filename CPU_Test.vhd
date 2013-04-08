--Bus Model Test Bench

--TESTBENCH
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU_Model_Test is
end entity;

architecture behave of CPU_Model_Test is

--declaration of the Behaviral Encoder
COMPONENT CPU is
   port (OPC : in std_logic_vector(31 downto 0);--OP code for instruction
   ALU_DONE: out std_logic_vector (0 downto 0); --2 bit Instruction type flag (0==Load) (1==Store) (2==Alu)
   R_W: out std_logic_vector (0 downto 0); --2 bit Instruction type flag (0==Load) (1==Store) (2==Alu)
   DAddr: out std_logic_vector (31 downto 0); --2 bit Instruction type flag (0==Load) (1==Store) (2==Alu)
   Data: out std_logic_vector (0 downto 0); --2 bit Instruction type flag (0==Load) (1==Store) (2==Alu)
   Data_reg: out std_logic_vector (31 downto 0) --2 bit Instruction type flag (0==Load) (1==Store) (2==Alu)
 );
end COMPONENT;

--Declaration of test signal Inputs
signal TB_OPC :  std_logic_vector(31 downto 0);

--Declaration of test signal Outputs	
signal TB_ALU_DONE:  std_logic_vector (0 downto 0); 
signal TB_R_W:  std_logic_vector (0 downto 0); 
signal TB_DAddr:  std_logic_vector (31 downto 0); 
signal TB_Data:  std_logic_vector (0 downto 0); 
signal TB_Data_reg: std_logic_vector (31 downto 0);


begin
	uut: CPU PORT MAP (
			OPC => TB_OPC,
			ALU_DONE => TB_ALU_DONE,
			R_W => TB_R_W,
			DAddr => TB_DAddr,
			Data => TB_Data,
			Data_reg => TB_Data_reg);
			

  
  TB_OPC_Load : process
  begin 
	 TB_OPC <= x"857100C8" after 20 ns; --AlU
	 wait;
  	TB_OPC <= x"00000000" after 20 ns; --load
  	wait;
  	TB_OPC <= x"AD930064" after 20 ns;  --store
  	wait;
  end process TB_OPC_Load;
end architecture behave;	


		



