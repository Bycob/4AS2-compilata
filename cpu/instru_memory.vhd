library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.STD_LOGIC_ARITH.ALL;
-- use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instru_memory is
	port( Addr: in std_logic_vector(15 downto 0);
			Dout : out std_logic_vector(31 downto 0)
			);
			--RST actif à 0

			
end instru_memory;

architecture beh of instru_memory is
	type mem is array(0 to 511) of std_logic_vector(31 downto 0);
	signal S:mem := ((others=> (others=>'0')));
begin
	Dout <= S(to_integer(unsigned(Addr)));
end beh;
