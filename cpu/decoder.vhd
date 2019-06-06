library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder is
	port(Instru : in std_logic_vector(31 downto 0);
			A,B,C:out std_logic_vector(15 downto 0);
			OP:out std_logic_vector(7 downto 0)
	);
end decoder;

architecture Behavioral of decoder is
begin
	-- AFC 0x6, LOAD 0x7
	-- STORE 0x8, JMP 0xE, JMPC 0xF
	-- ADD 0x1, MUL 0x2, SUB 0x3, DIV 0x4, EQU 0x9, LSS 0xA, LEQ 0xB, GTR 0xC, GEQ 0xD
	
	OP <= Instru(31 downto 24);
	
	with Instru(31 downto 24) select A <= 
		Instru(23 downto 8) when x"08" | x"0E" | x"0F", 
		x"00"&Instru(23 downto 16) when others;
	with Instru(31 downto 24) select B <= 
		Instru(15 downto 0) when x"06" | x"07",
		x"0000" when x"08" | x"0E" | x"0F",
		x"00"&Instru(15 downto 8) when others;
	with Instru(31 downto 24) select C <= 
		x"0000" when x"06" | x"07",
		x"00"&Instru(7 downto 0) when others;
		
end Behavioral;

