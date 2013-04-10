--Combination of DCache, Mem

library ieee;
use ieee.std_logic_1164.all;

entity DCache_Dataflow is
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
end entity DCache_Dataflow;
	
architecture behave of DCache_Dataflow is



--Component declaration
COMPONENT D_Cache is
   port (DAddr : in std_logic_vector; 	--Data address
		 DHC : in std_logic_vector(0 downto 0); -- 1 bit DCache Flag Input (1 for hit, 0 for miss, given by testbecnh)
	     Data_In : in std_logic_vector(31 downto 0); --32-bit data in
		 Blk_In: in std_logic_vector(255 downto 0);	--Block size of 8 words
		 R_W : in std_logic_vector(0 downto 0); -- 1 for load, 0 for store
		 ALU_Done : in std_logic_vector (0 downto 0); --1 for done, 0 for not done
		 LW_Done : out std_logic_vector (0 downto 0); --1 for done, 0 for not done
		 SW_Done : out std_logic_vector (0 downto 0); --1 for done, 0 for not done
		 D_Cache_Data: out std_logic_vector(31 downto 0));	--data output of 32-bit memory
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

COMPONENT Mux22_32 is
	port (ZERO: in std_logic_vector(31 downto 0);
		  ONE: in std_logic_vector(31 downto 0);
		  CTRL1: in std_logic_vector(0 downto 0);
		  CTRL2: in std_logic_vector(0 downto 0);
		  OUTPUT: out std_logic_vector(31 downto 0));
end COMPONENT;

--Temp signals used as connections between components 
signal T_Data_In : std_logic_vector (31 downto 0);
signal T_Blk_In : std_logic_vector (255 downto 0);
signal T_Data_Out : std_logic_vector (31 downto 0);
signal T_Data_Out2 : std_logic_vector (31 downto 0);
signal T_Data_Out3 : std_logic_vector (31 downto 0);
signal T_Data_Out4 : std_logic_vector (31 downto 0);
signal T_Blk_Out : std_logic_vector (255 downto 0);
signal T_Blk_Out2 : std_logic_vector (255 downto 0);
signal T_Addr_Out : std_logic_vector(31 downto 0);
begin

D_Cache_Mod : D_Cache port map (DAddr => aDAddr,
								DHC =>  aDHC,
								Data_In => aData,
								Blk_In => T_Blk_Out2,
								R_W => aR_W,
								ALU_Done => aALU_Done,
								LW_Done => aLW_Done,
								SW_Done => aSW_Done,
								D_Cache_Data => T_Data_Out);

Bus_1 : Bus_Model port map (Addr => aDAddr,
							IHC => "U",
							DHC =>  aDHC,
							R_W =>  aR_W,
							C_Type => aType,
							Data_In => T_Data_Out,
							Blk_In =>  aBlk,
							Addr_Out =>T_Addr_Out,
							Data_Out =>  T_Data_Out2);
										
D_Mem : Memory port map (Addr => aDAddr,	
						 IHC =>  "U",
						 DHC => aDHC,
						 R_W => aR_W,
						 Data_In => T_Data_Out2,
						 C_type => aType,
						 LW_Done => aLW_Done, 
						 SW_Done => aSW_Done,
						 Data_Out => T_Data_Out3,
						 Blk_Out => T_Blk_Out);							

Bus_2 : Bus_Model port map (Addr => aDAddr,
							IHC => "U",
							DHC =>  aDHC,
							R_W =>  aR_W,
							C_Type => aType,
							Data_In => T_Data_Out3,
							Blk_In =>  T_Blk_Out,
							Addr_Out =>T_Addr_Out,
							Data_Out =>  T_Data_Out4,
							Blk_Out => T_Blk_Out2);

Mux_32 : Mux22_32 port map (ZERO => 	T_Data_Out,
						   ONE => T_Data_Out3,
						   CTRL1 => aDHC,
						   CTRL2 => aR_W,
						   OUTPUT => aOut);


						
end architecture behave;	
