--CPU: 
--Access time: 1 cycle

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.numeric_std.all; 
use ieee.std_logic_arith.all; 

entity CPU is
   port (OPC : in std_logic_vector(31 downto 0);--OP code for instruction
   ALU_DONE: out std_logic_vector (0 downto 0); --2 bit Instruction type flag (0==Load) (1==Store) (2==Alu)
   R_W: out std_logic_vector (0 downto 0); --2 bit Instruction type flag (0==Load) (1==Store) (2==Alu)
   DAddr: out std_logic_vector (31 downto 0); --2 bit Instruction type flag (0==Load) (1==Store) (2==Alu)
   Data: out std_logic_vector (0 downto 0); --2 bit Instruction type flag (0==Load) (1==Store) (2==Alu)
   Data_reg: out std_logic_vector (31 downto 0) --2 bit Instruction type flag (0==Load) (1==Store) (2==Alu)
 );
end entity CPU;

architecture behave of CPU is 
begin 	
OPC_Proc : process (OPC)
	begin 
	-- Check type of instruction
		if (OPC = x"857100C8") then   --Load instruction
		  report "In load";
		  ALU_DONE<="0";
		  DAddr<=x"11111111"; 
			R_W<="1";
			Data<="1";
			Data_reg<=x"00000000";
		
		elsif (OPC = x"AD930064") then -- Store instruction 
		  report "In Store";
		  ALU_DONE<="0";
			DAddr<=x"33333333";
			R_W<="0";
			Data<="1";
			Data_reg<=x"33333333";
			
		
	  else  --ALU instruction
	    report "In ALU";
	    ALU_DONE<="1";
	    DAddr<=x"00000000";
			Data<="0";
			Data_reg<=x"00000000";

			
		end if;
		
end process OPC_Proc;
end architecture behave;




