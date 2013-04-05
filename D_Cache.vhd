--D_Cache: 256 Bytes (Word Aaddressable)
--Access time: 1 cycle

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity D_Cache is
   port (DAddr : in std_logic_vector; 	--Data address
		 DHC : in std_logic_vector(0 downto 0); -- 1 bit DCache Flag Input (1 for hit, 0 for miss, given by testbecnh)
	     Data_In : in std_logic_vector(31 downto 0); --32-bit data in
		 Blk_In: in std_logic_vector(255 downto 0);	--Block size of 8 words
		 Inst : in std_logic_vector(0 downto 0); -- 1 for load, 0 for store
		 D_Cache_Data: out std_logic_vector(31 downto 0));	--data output of 32-bit memory
end entity D_Cache;

architecture behave of D_Cache is 
	--initialaztion of a memory array of 256 byte (word addressable 32bit data 
	type array_type is array (0 to 31) of std_logic_vector(31 downto 0);
	signal D_Cache : array_type := ((others => (others=>'0')));	--Initialize everything to 0
	
	shared variable mem_blk : natural;
	
begin 
	
	DCache_Proc : process (Daddr, DHC,Inst)
	begin
	mem_blk := to_integer(unsigned(DAddr)) mod 32;
		if(Inst = "1" and DHC = "1") then
			D_Cache(mem_blk) <= x"FF22FF22";
		elsif(Inst = "1" and DHC = "0") then 
			D_Cache(mem_blk) <= Blk_In(255 downto 224);		
			D_Cache(mem_blk + 1) <= Blk_In(223 downto 192);
			D_Cache(mem_blk + 2) <= Blk_In(191 downto 160);
			D_Cache(mem_blk + 3) <= Blk_In(159 downto 128);
			D_Cache(mem_blk + 4) <= Blk_In(127 downto 96);
			D_Cache(mem_blk + 5) <= Blk_In(95 downto 64);
			D_Cache(mem_blk + 6) <= Blk_In(63 downto 32);
			D_Cache(mem_blk + 7) <= Blk_In(31 downto 0);
		elsif(Inst = "0" and DHC = "1") then
			D_Cache(mem_blk) <= Data_In;
		elsif(Inst = "0" and DHC = "0") then
			D_Cache(mem_blk) <= Blk_In(255 downto 224);		
			D_Cache(mem_blk + 1) <= Blk_In(223 downto 192);
			D_Cache(mem_blk + 2) <= Blk_In(191 downto 160);
			D_Cache(mem_blk + 3) <= Blk_In(159 downto 128);
			D_Cache(mem_blk + 4) <= Blk_In(127 downto 96);
			D_Cache(mem_blk + 5) <= Blk_In(95 downto 64);
			D_Cache(mem_blk + 6) <= Blk_In(63 downto 32);
			D_Cache(mem_blk + 7) <= Blk_In(31 downto 0);
		end if;
	end process DCache_Proc;
	
	--Look into how the memory and cache should be mapped to each other in notes
	D_Cache_Data <= D_Cache(to_integer(unsigned(DAddr)));
	
		
end architecture behave;
