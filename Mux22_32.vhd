--MUX FOR 2-input 32-bit Information with 2x1-bit control

library ieee;
use ieee.std_logic_1164.all;

entity Mux22_32 is
	port (ZERO: in std_logic_vector(31 downto 0);
		  ONE: in std_logic_vector(31 downto 0);
		  CTRL1: in std_logic_vector(0 downto 0);
		  CTRL2: in std_logic_vector (0 downto 0);
		  OUTPUT: out std_logic_vector(31 downto 0));
end entity Mux22_32;

architecture behavior of Mux22_32 is
begin
	OUTPUT <= ONE when (CTRL1 = "1" and CTRL2 = "1") else		--I-TYPE, Outputs IMM
			  ZERO when (CTRL1 = "0" and CTRL2 = "1");
end architecture behavior;

		