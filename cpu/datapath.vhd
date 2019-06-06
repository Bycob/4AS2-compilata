----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:21:52 05/14/2019 
-- Design Name: 
-- Module Name:    datapath - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity pipeline is
	port(	A,B,C:in std_logic_vector(15 downto 0);
			OP:in std_logic_vector(7 downto 0);
			Aout,Bout, Cout:out std_logic_vector(15 downto 0);
			OPout:out std_logic_vector(7 downto 0);
			CK: in std_logic
	);
end pipeline;

architecture Beh of pipeline is
begin
propagate: process

	begin
		wait until CK'event and CK='1';
		OPout <= OP;
		Aout <= A;
		Bout <= B;
		Cout <= C;
	end process propagate;

end Beh;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath is
--a voyr bougre de gredin
	port(
		CK : IN  std_logic;
		RST : IN  std_logic;
		Instru : IN std_logic_vector(31 downto 0)
	);
end datapath;

architecture Behavioral of datapath is

    COMPONENT decoder
    PORT(
         Instru : IN  std_logic_vector(31 downto 0);
         A : OUT  std_logic_vector(15 downto 0);
         B : OUT  std_logic_vector(15 downto 0);
         C : OUT  std_logic_vector(15 downto 0);
         OP : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
	 
	 COMPONENT regbench
    PORT(
         AddrA : IN  std_logic_vector(3 downto 0);
         AddrB : IN  std_logic_vector(3 downto 0);
         AddrW : IN  std_logic_vector(3 downto 0);
         QA : OUT  std_logic_vector(7 downto 0);
         QB : OUT  std_logic_vector(7 downto 0);
         DATA : IN  std_logic_vector(7 downto 0);
         CK : IN  std_logic;
         RST : IN  std_logic;
         W : IN  std_logic
        );
    END COMPONENT;
	 
    COMPONENT alu
    PORT(
         OP : IN  std_logic_vector(3 downto 0);
         A : IN  std_logic_vector(7 downto 0);
         B : IN  std_logic_vector(7 downto 0);
         Sout : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
	 
	 COMPONENT instru_memory
    PORT(
         Addr : IN  std_logic_vector(15 downto 0);
         Dout : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
	 
    COMPONENT pipeline
    PORT(
         OP : IN  std_logic_vector(7 downto 0);
         A, B, C: IN  std_logic_vector(15 downto 0);
         OPout : OUT  std_logic_vector(7 downto 0);
         Aout, Bout, Cout: OUT  std_logic_vector(15 downto 0);
         CK : IN  std_logic
        );
    END COMPONENT;
	 
	 COMPONENT memory
    PORT(
			Addr: in std_logic_vector(15 downto 0);
			Din : in std_logic_vector(15 downto 0);
			Dout : out std_logic_vector(15 downto 0);
			CK, W: in std_logic
        );
    END COMPONENT;
	 
	-- memory (_mem)
	
--	signal Addr_mem : IN  std_logic_vector(15 downto 0);
--   signal Din_mem : IN  std_logic_vector(15 downto 0);
--   signal Dout_mem : OUT  std_logic_vector(15 downto 0);
--   signal W_mem : IN  std_logic;
	 
	-- regbench (_reg)
--   signal AddrA_reg : IN  std_logic_vector(3 downto 0);
--   signal AddrB_reg : IN  std_logic_vector(3 downto 0);
--   signal AddrW_reg : IN  std_logic_vector(3 downto 0);
   signal QA_reg : std_logic_vector(7 downto 0);
   signal QB_reg : std_logic_vector(15 downto 0);
--   signal DATA_reg : IN  std_logic_vector(7 downto 0);
--   signal RST_reg : IN  std_logic;
   signal W_reg : std_logic;
	signal W_mem : std_logic;
	 
	-- alu (_alu)
--   signal OP_alu : IN  std_logic_vector(3 downto 0);
--   signal A_alu : IN  std_logic_vector(7 downto 0);
--   signal B_alu : IN  std_logic_vector(7 downto 0);
   signal Sout_alu : std_logic_vector(15 downto 0);

	-- instru_memory (_im)
	signal Addr_im :  std_logic_vector(15 downto 0);
	
	type stage_record is record
		A,B,C : std_logic_vector(15 downto 0);
		OP : std_logic_vector(7 downto 0);	
	end record stage_record;
	
	signal li, di, ex, mem, re : stage_record;
	signal Mux_di_B: std_logic_vector(15 downto 0);
	signal Mux_ex_B: std_logic_vector(15 downto 0);
	signal Mux_mem: std_logic_vector(15 downto 0);
	signal Mux_re: std_logic_vector(15 downto 0);


begin
   
   dec: decoder PORT MAP (
			Instru => Instru,
			A => li.A,
			B => li.B,
			C => li.C,
			OP => li.OP
        );

   pip_li_di: pipeline PORT MAP (
			A => li.A,
			B => li.B,
			C => li.C,
			OP => li.OP,
			Aout => di.A,
			Bout => di.B,
			Cout => di.C,
			OPout => di.OP,
			CK => CK
        );
		  
   pip_di_ex: pipeline PORT MAP (
			A => di.A,
			B => Mux_di_B,
			C => QB_Reg,
			OP => di.OP,
			Aout => ex.A,
			Bout => ex.B,
			Cout => ex.C,
			OPout => ex.OP,
			CK => CK
        );

   pip_ex_mem: pipeline PORT MAP (
			A => ex.A,
			B => Mux_ex_B,
			C => x"0000",
			OP => ex.OP,
			Aout => mem.A,
			Bout => mem.B,
			Cout => open,
			OPout => mem.OP,
			CK => CK
        );

   pip_mem_re: pipeline PORT MAP (
			A => mem.A,
			B => mem.B,
			C => mem.C,
			OP => mem.OP,
			Aout => re.A,
			Bout => re.B,
			Cout => open,
			OPout => re.OP,
			CK => CK
        );

	reg: regbench PORT MAP (
			AddrA => di.B(3 downto 0),
			AddrB => di.C(3 downto 0),
			AddrW => re.A(3 downto 0),
			QA => QA_reg,
			QB => QB_reg(7 downto 0),
			DATA => Mux_re(7 downto 0),
			RST => RST,
			CK => CK,
			W => W_reg
        );
		  
	ula: alu PORT MAP (
			OP => ex.OP(3 downto 0),
			A => ex.B(7 downto 0),
			B => ex.C(7 downto 0),
			Sout => Sout_alu
        );
	memo: memory PORT MAP (
		  	Addr => Mux_mem,
			Din => mem.B,
			Dout => open,
			CK => CK,
			W => W_mem
			);
	
	W_mem <= '1' when mem.OP = x"08" else '0';
	W_reg <= '1' when re.OP = x"06" or re.OP = x"05" or re.OP = x"01" else '0';
	Mux_di_B <= x"00"&QA_reg when di.OP = x"05" or di.OP = x"01" else di.B;
	Mux_mem <= mem.A when mem.OP = x"08" else mem.B when mem.OP = x"07" else x"0000";
	Mux_re <= re.C when re.OP = x"07" else re.B;
	Mux_ex_B <= Sout_alu when ex.OP = x"01" or ex.OP = x"02" or ex.OP = x"03" or ex.OP = x"04" or ex.OP = x"09" or ex.OP = x"0A" or ex.OP = x"0B" else ex.B;
end Behavioral;
