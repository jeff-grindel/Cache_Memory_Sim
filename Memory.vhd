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
   port (Addr : in std_logic_vector(31 downto 0); 	--32-bit Address between 0x0-0x3FF
		 IC_Flag : in std_logic_vector(0 downto 0); -- 1 bit ICache Flag Input (1 for hit, 0 for miss, given by testbecnh)
	     DC_Flag : in std_logic_vector(0 downto 0); -- 1 bit DCache Flag Input (1 for hit, 0 for miss)
		 R_W : in std_logic_vector(0 downto 0); 	--1 for read, 0 for write
		 Data_In : in std_logic_vector(31 downto 0);-- Data input used in SW Instruction
		 
		Data_Out: out std_logic_vector(31 downto 0);	--data output of 32-bit memory
		Blk_Out: out std_logic_vector(255 downto 0));	--Block size of 8 words
		 

end entity Memory;

architecture behave of Memory is 
	
		
	--initialaztion of a memory array of 1024 byte (Byte addressable decimal: 0-1023 (hex: 0x0 -> 0x3FF)
	type array_type is array (0 to 1023) of std_logic_vector(7 downto 0);
	signal memory : array_type := ((others => (others=>'0')));	--Initialize everything to 0
	shared variable mem_blk : natural;
	
	
	--Instruion Positions (addr of the instructions):
	constant lw_addr : integer := 0;
	constant sw_addr : integer := 4;
	constant add_addr : integer := 8;
	constant beq_addr : integer := 12;
	constant bne_addr : integer := 16;
	constant lui_addr : integer := 20;
	
	--Constants
	constant cycle_time : integer := 10;
	constant read_access : integer := cycle_time * 5;
	constant write_access : integer := cycle_time * 3;
	constant read_add : integer := cycle_time * 3;
	constant write_add : integer := cycle_time * 4;
	
begin 
	mem_proc : process (Addr)
	begin
		mem_blk := to_integer(unsigned(Addr)); 

		if (DC_Flag = "0" and R_W = "0") then
			--SW Dcache miss + Write signal
			memory(mem_blk) <= Data_In(31 downto 24);
			memory(mem_blk+1) <= Data_In(23 downto 16);
			memory(mem_blk+2) <= Data_In(15 downto 8);
			memory(mem_blk+3) <= Data_In(7 downto 0);
		end if;
		
		if ((IC_Flag = "0" or DC_Flag = "0") and R_W = "1") then
			--LW ICache miss or Dcache miss + Read signal
			--Data_Out <= memory(mem_blk) & memory(mem_blk + 1) & memory(mem_blk + 2) & memory(mem_blk + 3);
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

		end if;
	
					--Blk Out Outputs a 8 words starting with the input address
			Blk_Out(255 downto 224) <= memory(mem_blk) & memory(mem_blk + 1) & memory(mem_blk + 2) & memory(mem_blk + 3);
			Blk_Out(223 downto 192) <= memory(mem_blk + 4) & memory(mem_blk + 5) & memory(mem_blk + 6) & memory(mem_blk + 7);
			Blk_Out(191 downto 160) <= memory(mem_blk + 8) & memory(mem_blk + 9) & memory(mem_blk + 10) & memory(mem_blk + 11);
			Blk_Out(159 downto 128) <= memory(mem_blk + 12) & memory(mem_blk + 13) & memory(mem_blk + 14) & memory(mem_blk + 15);
			Blk_Out(127 downto 96) <= memory(mem_blk + 16) & memory(mem_blk + 17) & memory(mem_blk + 18) & memory(mem_blk + 19);
			Blk_Out(95 downto 64) <= memory(mem_blk + 20) & memory(mem_blk + 21) & memory(mem_blk + 22) & memory(mem_blk + 23);
			Blk_Out(63 downto 32) <= memory(mem_blk + 24) & memory(mem_blk + 25) & memory(mem_blk + 26) & memory(mem_blk + 27);
			Blk_Out(31 downto 0) <= memory(mem_blk + 28) & memory(mem_blk + 29) & memory(mem_blk + 30) & memory(mem_blk + 31);
	
		Data_Out <= memory(mem_blk) & memory(mem_blk + 1) & memory(mem_blk + 2) & memory(mem_blk + 3);
	end process mem_proc;
		
end architecture behave;
