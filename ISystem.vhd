--BETA Class for the instruction cache,mem and CPU process
--NOTE:ADD bus

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity iSystem is
  port (IAddr : in std_logic_vector;
	 ALU_DONE: out std_logic_vector (0 downto 0); 
   R_W: out std_logic_vector (0 downto 0); 
   DAddr: out std_logic_vector (31 downto 0);    Data: out std_logic_vector (0 downto 0); 
   Data_reg: out std_logic_vector (31 downto 0) 
 );
 
 
end iSystem;

architecture behave of iSystem is 

COMPONENT I_Cache is
   port (IAddr : in std_logic_vector; -- 0x0 - 0x40
		 IHC : in std_logic_vector(0 downto 0); --I-Cahche hit flag 1: Hit 0: Miss
		 Blk_In: in std_logic_vector(255 downto 0);	--Block size of 8 words
		 I_Cache_Data: out std_logic_vector(31 downto 0));	--data output of 32-bit memory
end COMPONENT;

COMPONENT Mux2_32 is
	port (ZERO: in std_logic_vector(31 downto 0);
		  ONE: in std_logic_vector(31 downto 0);
		  CTRL: in std_logic_vector(0 downto 0);
		  OUTPUT: out std_logic_vector(31 downto 0));
end COMPONENT;

COMPONENT Memory is
   port (Addr : in std_logic_vector; 			--32-bit Address between 0x0-0x3FF
		 IHC : in std_logic_vector(0 downto 0); -- 1 bit ICache Flag Input (1 for hit, 0 for miss, given by testbecnh)
	     DHC : in std_logic_vector(0 downto 0); -- 1 bit DCache Flag Input (1 for hit, 0 for miss)
		 R_W : in std_logic_vector(0 downto 0); 	--1 for read(Load), 0 for write(store)
		 Data_In : in std_logic_vector(31 downto 0);-- Data input used in SW Instruction
		 C_type : in std_logic_vector(0 downto 0); --1 for Data cache access, 0 for Instruction cache access
		 LW_Done : out std_logic_vector(0 downto 0);
		 SW_Done : out std_logic_vector(0 downto 0);
		 	 
		Data_Out: out std_logic_vector(31 downto 0);	--data output of 32-bit memory
		Blk_Out: out std_logic_vector(255 downto 0));	--Block size of 8 words	 
end COMPONENT;

COMPONENT CPU is
   port (OPC : in std_logic_vector(31 downto 0);--OP code for instruction
   ALU_DONE: out std_logic_vector (0 downto 0); --2 bit Instruction type flag (0==Load) (1==Store) (2==Alu)
   R_W: out std_logic_vector (0 downto 0); --2 bit Instruction type flag (0==Load) (1==Store) (2==Alu)
   DAddr: out std_logic_vector (31 downto 0); --2 bit Instruction type flag (0==Load) (1==Store) (2==Alu)
   Data: out std_logic_vector (0 downto 0); --2 bit Instruction type flag (0==Load) (1==Store) (2==Alu)
   Data_reg: out std_logic_vector (31 downto 0) --2 bit Instruction type flag (0==Load) (1==Store) (2==Alu)
 );
end COMPONENT;


------------------------------------------------First Cache Signals------------------------------------------------------
--Declaration of Inputs
signal ICACHE_I_IAddr : std_logic_vector (7 downto 0);
signal ICACHE_I_IHC : std_logic_vector(0 downto 0); --I-Cahche hit flag	
signal ICACHE_I_Blk_In: std_logic_vector(255 downto 0); --1 for read, 0 for write
--Declaration of Outputs	
signal ICACHE_I_I_Cache_Data: std_logic_vector(31 downto 0);
------------------------------------------------Second Cache Signals------------------------------------------------------
--Declaration of Inputs
signal ICACHE_II_IAddr : std_logic_vector (7 downto 0);
signal ICACHE_II_IHC : std_logic_vector(0 downto 0); --I-Cahche hit flag	
signal ICACHE_II_Blk_In: std_logic_vector(255 downto 0); --1 for read, 0 for write
--Declaration of Outputs	
signal ICACHE_II_cache_Data: std_logic_vector(31 downto 0);
------------------------------------------------Memory Signals------------------------------------------------------------
--Declaration of test signal Inputs
signal MEM_Addr : std_logic_vector(31 downto 0);								
signal MEM_IHC : std_logic_vector(0 downto 0);
signal MEM_DHC : std_logic_vector(0 downto 0);
signal MEM_R_W : std_logic_vector(0 downto 0); --1 for read, 0 for write
signal MEM_Data_In : std_logic_vector(31 downto 0);
signal MEM_C_type : std_logic_vector(0 downto 0);
--Declaration of test signal Outputs	
signal MEM_LW_Done : std_logic_vector(0 downto 0);								
signal MEM_SW_Done : std_logic_vector(0 downto 0);								
signal  MEM_Data_Out: std_logic_vector(31 downto 0);	--data output of 32-bit MEM
signal  MEM_Blk_Out: std_logic_vector(255 downto 0);	--Block size of 8 words
------------------------------------------------Mux Signals---------------------------------------------------------------
--Declaration of test signal Inputs
signal MUX_ZERO: std_logic_vector(31 downto 0);
signal MUX_ONE: std_logic_vector(31 downto 0);
signal MUX_CTRL: std_logic_vector(0 downto 0);
--Declaration of test signal Outputs
signal MUX_OUTPUT: std_logic_vector(31 downto 0);
------------------------------------------------CPU Signals---------------------------------------------------------------
--Declaration of test signal Inputs
signal CPU_OPC :  std_logic_vector(31 downto 0);
--Declaration of test signal Outputs	
signal CPU_ALU_DONE:  std_logic_vector (0 downto 0); 
signal CPU_R_W:  std_logic_vector (0 downto 0); 
signal CPU_DAddr:  std_logic_vector (31 downto 0); 
signal CPU_Data:  std_logic_vector (0 downto 0); 
signal CPU_Data_reg: std_logic_vector (31 downto 0);

			
begin
	i_cache_1: I_Cache PORT MAP (
			IAddr=>ICACHE_I_IAddr,
			IHC =>ICACHE_I_IHC,
			Blk_In =>ICACHE_I_Blk_In, --in (Undriven for first cache)
			I_Cache_Data =>ICACHE_I_I_Cache_Data);
			
	mem: Memory PORT MAP (
			Addr => ICACHE_I_IAddr,--in
			IHC => ICACHE_I_IHC,   --in
			DHC => MEM_DHC,        --in (Undriven for Instruction flow)    
			R_W => MEM_R_W,        --in (Undriven for Instruction flow)   
			Data_In => ICACHE_I_I_Cache_Data,--in
			C_type => "1",  --in   (instruction)
			LW_Done => MEM_LW_Done,   --(Undriven for Instruction flow)   
			SW_Done => MEM_SW_Done,   --(Undriven for Instruction flow) 
			Data_Out => MEM_Data_Out, --(Undriven for Instruction flow) 
			Blk_Out => MEM_Blk_Out);

	i_cache_2: I_Cache PORT MAP (
			IAddr=>ICACHE_I_IAddr,--in
			IHC => ICACHE_I_IHC,--in
			Blk_In => MEM_Blk_Out,--in
			I_Cache_Data =>ICACHE_II_Cache_Data);
			
	mux: Mux2_32 PORT MAP (
			ZERO => ICACHE_II_Cache_Data, --in
			ONE => MEM_Data_Out,--in
			CTRL => ICACHE_I_IHC,--in
			OUTPUT => MUX_OUTPUT);
			
  cpu_uut: CPU PORT MAP (
			OPC => MUX_OUTPUT, --in
			ALU_DONE => CPU_ALU_DONE,
			R_W => CPU_R_W,
			DAddr => CPU_DAddr,
			Data => CPU_Data,
			Data_reg => CPU_Data_reg); 

  
  
end architecture behave;



