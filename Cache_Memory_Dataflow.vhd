--BETA Class for the instruction cache,mem and CPU process
--NOTE:ADD bus

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Cache_Memory_Dataflow is
  port (t_IAddr : in std_logic_vector(31 downto 0);
		t_IHC : in std_logic_vector(0 downto 0); --I-Cahche hit flag 1: Hit 0: Miss
		t_DHC : in std_logic_vector(0 downto 0);
		t_ALU_DONE: out std_logic_vector (0 downto 0);
		t_LW_DONE: out std_logic_vector (0 downto 0);
		t_SW_DONE: out std_logic_vector (0 downto 0);
		t_Data_Out: out std_logic_vector (31 downto 0)); --5 bit register number
end Cache_Memory_Dataflow;

architecture behave of Cache_Memory_Dataflow is 

COMPONENT ICache_Dataflow is 
	  port (aIAddr : in std_logic_vector(31 downto 0);
		aIHC : in std_logic_vector(0 downto 0); --I-Cahche hit flag 1: Hit 0: Miss
		aALU_DONE: out std_logic_vector (0 downto 0); 
		aR_W: out std_logic_vector (0 downto 0); 
		aDAddr: out std_logic_vector (31 downto 0);    
		aData: out std_logic_vector (0 downto 0); 
		aData_reg: out std_logic_vector (31 downto 0);
		aReg_Num: out std_logic_vector (4 downto 0)); --5 bit register number
end component;

COMPONENT DCache_Dataflow is
	port (aDAddr : in std_logic_vector (31 downto 0);
		  aData : in std_logic_vector (31 downto 0);
		  aBlk : in std_logic_vector (255 downto 0);
		  aALU_Done : in std_logic_vector (0 downto 0);
	      aR_W : in std_logic_vector (0 downto 0);
		  aDHC : in std_logic_vector (0 downto 0);
		  aType : in std_logic_vector (0 downto 0);
		  
		  aOut : out std_logic_vector (31 downto 0);
		  aLW_Done : out std_logic_vector (0 downto 0);
		  aSW_Done : out std_logic_vector (0 downto 0));
end component;

COMPONENT Register_Data is 
   port (Reg_Num: in std_logic_vector (4 downto 0);		--5-bit Read Reg. 1
		 Data_In: in std_logic_vector (31 downto 0));
end component;

signal temp_rw : std_logic_vector (0 downto 0);
signal temp_DAddr : std_logic_vector (31 downto 0);
signal temp_C_Type : std_logic_vector (0 downto 0);
signal temp_CPU_Data : std_logic_vector (31 downto 0);
signal temp_Reg_Num : std_logic_vector (4 downto 0);
signal not_used_in_this_test : std_logic_vector (255 downto 0);
signal temp_ALU_DONE : std_logic_vector (0 downto 0);
signal temp_Data_Out : std_logic_vector (31 downto 0);
begin
	ICache : ICache_Dataflow port map(aIAddr  => t_IAddr,
									  aIHC  => t_IHC,
									  aALU_DONE => temp_ALU_DONE,
									  aR_W => temp_rw,
									  aDAddr => temp_DAddr,
									  aData => temp_C_Type,
									  aData_reg => temp_CPU_Data,
									  aReg_Num =>  temp_Reg_Num);
  
  DCache : DCache_Dataflow port map(aDAddr => temp_DAddr,
									 aData =>  temp_CPU_Data,
									 aBlk =>  not_used_in_this_test,
									 aALU_Done => temp_ALU_DONE,
									 aR_W =>  temp_rw,
									 aDHC => t_DHC,
									 aType => temp_C_Type,
									  
									 aOut  =>  temp_Data_Out,
									 aLW_Done  => t_LW_DONE,
									 aSW_Done  => t_SW_DONE);
	
	Reg_File : Register_Data port map(Reg_Num => temp_Reg_Num,
									  Data_In => temp_Data_Out);
									  
	t_ALU_DONE <= temp_ALU_DONE;	
	t_Data_Out <= temp_Data_Out;	
end architecture behave;





