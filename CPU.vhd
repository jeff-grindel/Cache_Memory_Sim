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
   Data_reg: out std_logic_vector (31 downto 0); --2 bit Instruction type flag (0==Load) (1==Store) (2==Alu)
   Reg_Num: out std_logic_vector (5 downto 0)); --5 bit register number
end entity CPU;

architecture behave of CPU is 
begin 	
	OPC_Proc : process (OPC)
		begin 
		-- Check type of instruction
			if (OPC = x"857100C8") then   --Load instruction
				report "In load";
				ALU_DONE<="0";
				DAddr<=x"000000D9"; --200 + $11
				R_W<="1";
				Data<="1";
				Data_reg<=x"00000000";
				Reg_Num <= "10001"; --R17
			elsif (OPC = x"AD930064") then -- Store instruction 
				report "In Store";
				ALU_DONE<="0";
				DAddr<=x"00000076"; --100 + $12
				R_W<="0";
				Data<="1";
				Data_reg<=x"00000019";
			elsif (OPC = x"016A9020") then --Add
				ALU_DONE<="1";
				DAddr<=x"00000000";
				Data<="0";
				Data_reg<=x"00000000";
				Reg_Num <= "10011";
			elsif (OPC = x"3C160028") then --LUI
				ALU_DONE<="1";
				DAddr<=x"00000000";
				Data<="0";
				Data_reg<=x"00000000";
				Reg_Num <= "10110";
			else  --ALU instruction
				report "In ALU";
				ALU_DONE<="1";
				DAddr<=x"00000000";
				Data<="0";
				Data_reg<=x"00000000";
				Reg_Num <= "00000";
			end if;
			
	end process OPC_Proc;
end architecture behave;




