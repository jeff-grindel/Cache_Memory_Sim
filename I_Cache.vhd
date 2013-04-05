--I-Cache: 256 Bytes (Word Aaddressable)
--Access time: 1 cycle

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity I_Cache is
   port (IAddr : in std_logic_vector; --Instruction address
		 IHC : in std_logic_vector(0 downto 0); --I-Cahche hit flag 1: Hit 0: Miss
		 Blk_In: in std_logic_vector(255 downto 0);	--Block size of 8 words
		 I_Cache_Data: out std_logic_vector(31 downto 0));	--data output of 32-bit memory
end entity I_Cache;

architecture behave of I_Cache is 
	--initialaztion of a memory array of 256 byte (word addressable 32bit data 
	type i_array_type is array (0 to 63) of std_logic_vector(31 downto 0);
	signal I_Cache : i_array_type := ((others => (others=>'0')));	--Initialize everything to 0
	
	--signal mem_blk : natural;
	shared variable mem_blk : natural;
	
	--Address in cache for the instructions 
	constant lw_addr : integer := 0;
	constant sw_addr : integer := 8;
	constant add_addr : integer := 16;
	constant beq_addr : integer := 24;
	constant bne_addr : integer := 32;
	constant lui_addr : integer := 40;
	
begin 

	ICache_Proc :process  (IAddr, IHC)
	begin	
	mem_blk := to_integer(unsigned(IAddr)) mod 64;
		if(IHC = "1") then 
			I_Cache(lw_addr) <= x"857100C8";
			I_Cache(sw_addr) <= x"AD930064";
			I_Cache(add_addr) <= x"016A9020";
			I_Cache(beq_addr) <= x"11111111";
			I_Cache(bne_addr) <= x"11111111";
			I_Cache(lui_addr) <= x"3C160028";	
		elsif(IHC = "0") then
			I_Cache(mem_blk) <= Blk_In(255 downto 224);		
			I_Cache(mem_blk + 1) <= Blk_In(223 downto 192);
			I_Cache(mem_blk + 2) <= Blk_In(191 downto 160);
			I_Cache(mem_blk + 3) <= Blk_In(159 downto 128);
			I_Cache(mem_blk + 4) <= Blk_In(127 downto 96);
			I_Cache(mem_blk + 5) <= Blk_In(95 downto 64);
			I_Cache(mem_blk + 6) <= Blk_In(63 downto 32);
			I_Cache(mem_blk + 7) <= Blk_In(31 downto 0);
		end if;
	end process ICache_Proc;
	
	I_Cache_Data <= I_Cache(to_integer(unsigned(IAddr)));
	
end architecture behave;
