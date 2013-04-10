--Register_Data

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register_Data is
   port (Reg_Num: in std_logic_vector(4 downto 0);		--5-bit Read Reg. 1
		 Data_In: in std_logic_vector(31 downto 0));
end entity Register_Data;

architecture behave of Register_Data is 

--Changing Vectors
signal REG_8: std_logic_vector(31 downto 0) := x"00000008";
signal REG_9: std_logic_vector(31 downto 0) := x"00000009";
signal REG_10: std_logic_vector(31 downto 0) := x"00000010";
signal REG_11: std_logic_vector(31 downto 0) := x"00000011";
signal REG_12: std_logic_vector(31 downto 0) := x"00000012";
signal REG_13: std_logic_vector(31 downto 0) := x"00000013";
signal REG_14: std_logic_vector(31 downto 0) := x"00000014";
signal REG_15: std_logic_vector(31 downto 0) := x"00000015";
signal REG_16: std_logic_vector(31 downto 0) := x"00000016";
signal REG_17: std_logic_vector(31 downto 0) := x"00000017";    
signal REG_18: std_logic_vector(31 downto 0) := x"00000018";
signal REG_19: std_logic_vector(31 downto 0) := x"00000019";
signal REG_20: std_logic_vector(31 downto 0) := x"00000020";
signal REG_21: std_logic_vector(31 downto 0) := x"00000021";
signal REG_22: std_logic_vector(31 downto 0) := x"00000022";
signal REG_23: std_logic_vector(31 downto 0) := x"00000023";
signal REG_24: std_logic_vector(31 downto 0) := x"00000024";
signal REG_25: std_logic_vector(31 downto 0) := x"00000025";

begin 
	Reg_19 <= x"00000021" when Reg_Num = "10011"; --simulated addition
	Reg_22 <= x"00280022" when Reg_Num = "10110"; --simulated lui
	Reg_17 <= Data_In when Reg_num = "10001"; --sumulates lw	
end architecture behave;
