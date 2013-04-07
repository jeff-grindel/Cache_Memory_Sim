--Memory: 1024 Bytes (Byte Aaddressable)
--Port Access Time: READ  : 5 cycles/word
--                  WRITE : 3 cycles/word
--
--Addition Time:    READ  : 3 cycles/word
--                  WRITE : 4 cycles/word

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity Memory is
   port (Addr : in std_logic_vector; 					--32-bit Address between 0x0-0x3FF
		 IHC : in std_logic_vector(0 downto 0); 		--1 bit ICache Flag Input (1 for hit, 0 for miss, given by testbecnh)
	     DHC : in std_logic_vector(0 downto 0); 		--1 bit DCache Flag Input (1 for hit, 0 for miss)
		 R_W : in std_logic_vector(0 downto 0); 		--1 for read(Load), 0 for write(store)
		 Data_In : in std_logic_vector(31 downto 0);	--Data input used in SW Instruction
		 C_type : in std_logic_vector(0 downto 0); 		--1 for Data cache access, 0 for Instruction cache access
		 LW_Done : out std_logic_vector(0 downto 0);	--Load Word Done Flag
		 SW_Done : out std_logic_vector(0 downto 0);	--Store Word Done Flag	 
		 Data_Out: out std_logic_vector(31 downto 0);	--data output of 32-bit memory
		 Blk_Out: out std_logic_vector(255 downto 0));	--Block size of 8 words
end entity Memory;

architecture behave of Memory is 
	--initialaztion of a memory array of 1024 byte (Byte addressable decimal: 0-1023 (hex: 0x0 -> 0x3FF)
	type array_type is array (0 to 1023) of std_logic_vector(7 downto 0);
	signal memory : array_type := ((others => (others=>'0')));	--Initialize everything to 0
	shared variable mem_blk : natural;
	
	signal temp_blk_out: std_logic_vector(255 downto 0);
	
	--Instruion Positions (addr of the instructions):
	constant lw_addr : integer := 0;
	constant sw_addr : integer := 4;
	constant add_addr : integer := 8;
	constant beq_addr : integer := 12;
	constant bne_addr : integer := 16;
	constant lui_addr : integer := 20;

	--Cycle Time and Access time constants multipliers
	constant cycle_time : time := 10 ns;
	constant read_access : integer :=  5;
	constant write_access : integer := 3;
	constant read_add : integer := 3;
	constant write_add : integer := 4;
	
begin 
	mem_proc : process (Addr, IHC, DHC, R_W, Data_In, C_type)
	begin
		mem_blk := to_integer(unsigned(Addr));
		
		--I-Cahce Hit -> Write Thru (Write single word to memory)
		if (IHC = "1" and C_type /= "1") then
			memory(mem_blk) <= Data_In(31 downto 24) after (cycle_time * write_access) + (cycle_time * write_add);
			memory(mem_blk+1) <= Data_In(23 downto 16) after (cycle_time * write_access) + (cycle_time * write_add);
			memory(mem_blk+2) <= Data_In(15 downto 8) after (cycle_time * write_access) + (cycle_time * write_add);
			memory(mem_blk+3) <= Data_In(7 downto 0) after (cycle_time * write_access) + (cycle_time * write_add);
		
		--I-Cache Miss -> Write Allocate (Writes block to cache)
		elsif (IHC = "0" and C_type /= "1") then
			--Init of fake instruction memory
			memory(lw_addr) <= x"8D";
			memory(lw_addr+1) <= x"71";
			memory(lw_addr+2) <= x"00";
			memory(lw_addr+3) <= x"C8";
			
			memory(sw_addr) <= x"AD";
			memory(sw_addr+1) <= x"93";
			memory(sw_addr+2) <= x"00";
			memory(sw_addr+3) <= x"64";

			memory(add_addr) <= x"01";
			memory(add_addr+1) <= x"6A";
			memory(add_addr+2) <= x"90";
			memory(add_addr+3) <= x"20";
			
			memory(beq_addr) <= x"11";
			memory(beq_addr+1) <= x"11";
			memory(beq_addr+2) <= x"11";
			memory(beq_addr+3) <= x"11";
			
			memory(bne_addr) <= x"11";
			memory(bne_addr+1) <= x"11";
			memory(bne_addr+2) <= x"11";
			memory(bne_addr+3) <= x"11";	
			
			memory(lui_addr) <= x"3C";
			memory(lui_addr+1) <= x"16";
			memory(lui_addr+2) <= x"00";
			memory(lui_addr+3) <= x"28";
		
		--D-Cache Hit -> Write Thru (Write signle word to memory)
		--R_W = 1 -> Load Branch (Outputs data at mem)
		elsif (DHC = "1" and R_W = "1" and C_type = "1") then
			memory(mem_blk) <= Data_In(31 downto 24) after (cycle_time * write_access) + (cycle_time * write_add);
			memory(mem_blk+1) <= Data_In(23 downto 16) after (cycle_time * write_access) + (cycle_time * write_add);
			memory(mem_blk+2) <= Data_In(15 downto 8) after (cycle_time * write_access) + (cycle_time * write_add);
			memory(mem_blk+3) <= Data_In(7 downto 0) after (cycle_time * write_access) + (cycle_time * write_add);
			LW_Done <= "1" after (cycle_time * write_access) + (cycle_time * write_add);
			
		--D-Cache Miss -> Write Allocate (Writes block to cache)
		--R_w = 1 -> Load Branch (Outputs blk at mem)
		elsif (DHC = "0" and R_W = "1" and C_type = "1") then
			memory(mem_blk) <= x"EE";
			memory(mem_blk+1) <= x"EE";
			memory(mem_blk+2) <= x"DD";
			memory(mem_blk+3) <= x"DD";
		
		--D-Cache Hit -> Write Thru (Write single word to memory)
		--R_W = 0 -> Store Branch 
		elsif (DHC = "1" and R_W = "0" and C_type = "1") then
			memory(mem_blk) <= Data_In(31 downto 24) after (cycle_time * write_access) + (cycle_time * write_add);
			memory(mem_blk+1) <= Data_In(23 downto 16) after (cycle_time * write_access) + (cycle_time * write_add);
			memory(mem_blk+2) <= Data_In(15 downto 8) after (cycle_time * write_access) + (cycle_time * write_add);
			memory(mem_blk+3) <= Data_In(7 downto 0) after (cycle_time * write_access) + (cycle_time * write_add);
			SW_Done <= "1" after (cycle_time * write_access) + (cycle_time * write_add);
		
		--D-Cache Miss -> Write Allocate (Writes block to cache)
		--R_W = 0 -> Store Word (Write word to mem, then read blks to update cache)
		elsif (DHC = "0" and R_W = "0" and C_type = "1") then
			memory(mem_blk) <= Data_In(31 downto 24) after (cycle_time * write_access) + (cycle_time * write_add);
			memory(mem_blk+1) <= Data_In(23 downto 16) after (cycle_time * write_access) + (cycle_time * write_add);
			memory(mem_blk+2) <= Data_In(15 downto 8) after (cycle_time * write_access) + (cycle_time * write_add);
			memory(mem_blk+3) <= Data_In(7 downto 0) after (cycle_time * write_access) + (cycle_time * write_add);
		end if;
	end process mem_proc;
	
	--Writing the blk into the temp_blk
	temp_blk_out(255 downto 224) <= memory(mem_blk) & memory(mem_blk + 1) & memory(mem_blk + 2) & memory(mem_blk + 3);
	temp_blk_out(223 downto 192) <= memory(mem_blk + 4) & memory(mem_blk + 5) & memory(mem_blk + 6) & memory(mem_blk + 7);
	temp_blk_out(191 downto 160) <= memory(mem_blk + 8) & memory(mem_blk + 9) & memory(mem_blk + 10) & memory(mem_blk + 11);
	temp_blk_out(159 downto 128) <= memory(mem_blk + 12) & memory(mem_blk + 13) & memory(mem_blk + 14) & memory(mem_blk + 15);
	temp_blk_out(127 downto 96) <= memory(mem_blk + 16) & memory(mem_blk + 17) & memory(mem_blk + 18) & memory(mem_blk + 19);
	temp_blk_out(95 downto 64) <= memory(mem_blk + 20) & memory(mem_blk + 21) & memory(mem_blk + 22) & memory(mem_blk + 23);
	temp_blk_out(63 downto 32) <= memory(mem_blk + 24) & memory(mem_blk + 25) & memory(mem_blk + 26) & memory(mem_blk + 27);
	temp_blk_out(31 downto 0) <= memory(mem_blk + 28) & memory(mem_blk + 29) & memory(mem_blk + 30) & memory(mem_blk + 31);
			
	--When IHC = 1, write Data Out
	Data_Out <= Data_In after (cycle_time * write_access) + (cycle_time * write_add) when (IHC = "1" and C_type /= "1") else
				Data_In after (cycle_time * write_access) + (cycle_time * write_add) when (DHC = "1" and R_W = "1" and C_type = "1") else
				Data_In after (cycle_time * write_access) + (cycle_time * write_add) when (DHC = "0" and R_W = "0" and C_type = "1");
	
	--When IHC = 0, write Blk_Out
	Blk_Out <= temp_blk_out after 8*((cycle_time * read_access) + (cycle_time * read_add)) when (IHC = "0" and C_type /= "1") else
			   temp_blk_out after 8*((cycle_time * read_access) + (cycle_time * read_add)) when (DHC = "0" and R_W = "1" and C_type = "1") else
			   temp_blk_out after 8*((cycle_time * read_access) + (cycle_time * read_add)) when (DHC = "0" and R_W = "0" and C_type = "1");

end architecture behave;
