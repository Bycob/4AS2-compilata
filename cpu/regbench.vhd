library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.STD_LOGIC_ARITH.ALL;
-- use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity regbench is
	port( AddrA, AddrB, AddrW: in std_logic_vector(3 downto 0);
			QA, QB: out std_logic_vector(7 downto 0);
			DATA : in std_logic_vector(7 downto 0);
			CK, RST, W: in std_logic);
			--RST actif à 0
end regbench;

architecture beh of regbench is
	type reg is array(0 to 15) of std_logic_vector(7 downto 0);
	signal S:reg;
	constant ck_period:time := 100 ns;
begin
		comport: process
		begin
			wait until CK'event and CK='1';
			
			if RST='0' then S <= (others => x"00");
			end if;
			
			if W='1' then S(to_integer(unsigned(AddrW))) <= DATA;
			end if;
		end process comport;
		
		QA <= DATA when W='1' and AddrA=AddrW else
				S(to_integer(unsigned(AddrA)));
		QB <= DATA when W='1' and AddrB=AddrW else
				S(to_integer(unsigned(AddrB)));
end beh;
