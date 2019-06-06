library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.STD_LOGIC_ARITH.ALL;
-- use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory is
	port( Addr: in std_logic_vector(15 downto 0);
			Din : in std_logic_vector(15 downto 0);
			Dout : out std_logic_vector(15 downto 0);
			CK, W: in std_logic);
			--RST actif à 0
end memory;

architecture beh of memory is
type reg is array(0 to 511) of std_logic_vector(31 downto 0);
signal S:reg;
constant ck_period:time := 100 ns;
begin
		comport: process
		begin
		wait until CK'event and CK='1';

		if W='1' then S(to_integer(unsigned(Addr))) <= Din;
		else Dout <= S(to_integer(unsigned(Addr)));
		end if;
		end process comport;
		
end beh;
