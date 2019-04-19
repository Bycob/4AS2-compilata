library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
	port(OP : in std_logic_vector(3 downto 0);
	--ajouter FLAG plus tard
			A:in std_logic_vector(7 downto 0);
			B:in std_logic_vector(7 downto 0);
			Sout: out std_logic_vector(15 downto 0)
	);
			
end alu;

architecture data_flow of alu is
	signal S: std_logic_vector(15 downto 0);
	--constant A: std_logic_vector(N-1 downto 0) <= (Champ0 => 1,others => 0);
	--constant ck_period:time := 100 ns;
begin
		--wait until CK' event and CK='1';
		-- ADD 0x01
		S <= x"00"&(('0'&A)+('0'&B)) when OP=x"01" else
		-- MUL 0x02
		S <= ('0'&A)*('0'&B) when OP=x"02" else
		-- SUB 0x03
		S <= x"00"&(('0'&A)-('0'&B)) when OP=x"03" else
		-- DIV 0x04
		S <= x"00"&(('0'&A)/('0'&B)) when OP=x"04" else
		-- EQU 0x09
		S <= x"0001" when OP=x"09" and (('0'&A)=('0'&B))else
		S <= x"0000" when OP=x"09" and not (('0'&A)=('0'&B))else
		-- LSS 0x0A
		S <= x"0001" when OP=x"0A" and (('0'&A)<('0'&B)) else
		S <= x"0000" when OP=x"0A" and not (('0'&A)<('0'&B)) else
		-- LEQ 0x0B
		S <= x"0001" when OP=x"0B" and (('0'&A)<=('0'&B)) else
		S <= x"0000" when OP=x"0B" and not (('0'&A)<=('0'&B)) else
		-- GTR 0x0C
		S <= x"0001" when OP=x"0C" and (('0'&A)>('0'&B)) else
		S <= x"0000" when OP=x"0C" and not (('0'&A)>('0'&B)) else
		-- GEQ 0x0D
		S <= x"0001" when OP=x"0D" and (('0'&A)>=('0'&B)) else
		S <= x"0000" when OP=x"0D" and not (('0'&A)>=('0'&B)) else
		
		Sout<= S;

end data_flow;
