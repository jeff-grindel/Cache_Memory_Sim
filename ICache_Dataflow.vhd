--BETA Class for the instruction cache,mem and CPU process
--NOTE:ADD bus

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ICache_Dataflow is
  port (aIAddr : in std_logic_vector(31 downto 0);
		aIHC : in std_logic_vector(0 downto 0); --I-Cahche hit flag 1: Hit 0: Miss
		aALU_DONE: out std_logic_vector (0 downto 0); 
		aR_W: out std_logic_vector (0 downto 0); 
		aDAddr: out std_logic_vector (31 downto 0);    
		aData: out std_logic_vector (0 downto 0); 
		aData_reg: out std_logic_vector (31 downto 0);
		aReg_Num: out std_logic_vector (4 downto 0)); --5 bit register number
end ICache_Dataflow;

architecture behave of ICache_Dataflow is 

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
   Data_reg: out std_logic_vector (31 downto 0); --2 bit Instruction type flag (0==Load) (1==Store) (2==Alu)
   Reg_Num: out std_logic_vector (4 downto 0)); --5 bit register number

end COMPONENT;

COMPONENT Bus_Model is
   port (Addr : in std_logic_vector; 	
		 IHC : in std_logic_vector (0 downto 0);
	     DHC : in std_logic_vector (0 downto 0); 
		 R_W : in std_logic_vector (0 downto 0);
		 C_Type : in std_logic_vector (0 downto 0);
		 Data_In : in std_logic_vector (31 downto 0);
		 Blk_In : in std_logic_vector (255 downto 0);
		
		 Addr_Out: out std_logic_vector; 
		 IHC_Out: out std_logic_vector (0 downto 0); 
	     DHC_Out : out std_logic_vector (0 downto 0);
		 R_W_Out : out std_logic_vector (0 downto 0);
		 C_Type_Out : out std_logic_vector (0 downto 0);
		 Data_Out : out std_logic_vector (31 downto 0);
		 Blk_Out : out std_logic_vector(255 downto 0)); 
end COMPONENT;


------------------------------------------------First Cache Signals------------------------------------------------------
--Declaration of Inputs
signal ICACHE_I_IAddr : std_logic_vector (7 downto 0);
signal ICACHE_I_IHC : std_logic_vector(0 downto 0); --I-Cahche hit flag	
signal ICACHE_I_Blk_In: std_logic_vector(255 downto 0);
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

signal T_Addr_Out : std_logic_vector(31 downto 0);
signal T_Data_out : std_logic_vector(31 downto 0);			
signal T_Data_out2 : std_logic_vector(31 downto 0);			
signal T_Data_out3 : std_logic_vector(31 downto 0);			
signal T_Data_out4 : std_logic_vector(31 downto 0);			
signal T_Blk_Out2 : std_logic_vector(255 downto 0);

begin
	i_cache_1: I_Cache PORT MAP (
			IAddr=>aIAddr,
			IHC =>aIHC,
			Blk_In =>T_Blk_Out2, --in (Undriven for first cache)
			I_Cache_Data =>T_Data_out);
		
	Bus_1 : Bus_Model port map (Addr => aIAddr,
							IHC => aIHC,
							DHC =>  "U",
							R_W =>  "U",
							C_Type => "0",
							Data_In => T_Data_out,
							Blk_In =>  MEM_Blk_Out,
							Addr_Out =>T_Addr_Out,
							Data_Out =>  T_Data_Out2);
		
	mem: Memory PORT MAP (
			Addr => aIAddr,--in
			IHC => aIHC,   --in
			DHC => "U",        --in (Undriven for Instruction flow)    
			R_W => "U",        --in (Undriven for Instruction flow)   
			Data_In => T_Data_Out2,--in
			C_type => "0",  --in   (instruction)
			--LW_Done => "0",   --(Undriven for Instruction flow)   
			--SW_Done => "0",   --(Undriven for Instruction flow) 
			Data_Out => T_Data_out3, --(Undriven for Instruction flow) 
			Blk_Out => MEM_Blk_Out);

	Bus_2 : Bus_Model port map (Addr => aIAddr,
						IHC => aIHC,
						DHC =>  "U",
						R_W =>  "U",
						C_Type => "0",
						Data_In => T_Data_out3,
						Blk_In =>  MEM_Blk_Out,
						Addr_Out =>T_Addr_Out,
						Data_Out =>  T_Data_Out4,
						Blk_Out => T_Blk_Out2);		
			
	-- i_cache_2: I_Cache PORT MAP (
			-- IAddr=>aIAddr,--in
			-- IHC => aIHC,--in
			-- Blk_In => MEM_Blk_Out,--in
			-- I_Cache_Data =>ICACHE_II_Cache_Data);
			
	mux: Mux2_32 PORT MAP (
			ZERO => T_Data_out, --in
			ONE => T_Data_Out4,--in
			CTRL => aIHC,--in
			OUTPUT => MUX_OUTPUT);
			
  cpu_uut: CPU PORT MAP (
			OPC => MUX_OUTPUT, --in
			ALU_DONE => aALU_DONE,
			R_W => aR_W,
			DAddr => aDAddr,
			Data => aData,
			Data_reg => aData_reg,
			Reg_Num=>aReg_Num); 

  
  
end architecture behave;





