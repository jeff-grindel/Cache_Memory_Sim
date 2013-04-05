--Bus: Used to transfer words and blocks between cahce and memeory.
--Bandwidth of 32words/cycle

------------------------------Not sure if this is needed since the delays in the system should
------------------------------be modeled in the memory and cahce entites
------------------------------since 32words/cycle, we are either transfering a word
------------------------------or a block which is only 8 words so should never exceed the 
------------------------------BW of the bus. 

library ieee;
use ieee.std_logic_1164.all;

entity Bus_Model is
   port (Addr : in std_logic_vector; 	--32-bit instruction
		 IHC : in std_logic_vector (0 downto 0); -- 1 bit ICache Flag Input (1 for hit, 0 for miss, given by testbecnh)
	     DHC : in std_logic_vector (0 downto 0); --1 for read, 0 for write
		 Data_In : in std_logic_vector (31 downto 0);
		 Blk_In : in std_logic_vector (255 downto 0);
		 
		 
		 Addr_Out: out std_logic_vector; 	--32-bit instruction
		 IHC_Out: out std_logic_vector (0 downto 0); -- 1 bit ICache Flag Input (1 for hit, 0 for miss, given by testbecnh)
	     DHC_Out : out std_logic_vector (0 downto 0);
		 Data_Out : out std_logic_vector (31 downto 0);
		 Blk_Out : out std_logic_vector(255 downto 0)); 
end entity Bus_Model;

architecture behave of Bus_Model is 
begin 
	Bus_Proc : process
	begin
		if(IHC = "1") then
			IHC_Out <= IHC;
			Data_Out <= Data_In after 10 ns;
		end if;
	wait;
	end process Bus_Proc;
end architecture behave;
