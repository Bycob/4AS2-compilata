--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:17:24 05/13/2019
-- Design Name:   
-- Module Name:   /home/hanin/Bureau/4eme_annee/4AS2-compilata/cpu/regbench_tb.vhd
-- Project Name:  cpu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: regbench
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY regbench_tb IS
END regbench_tb;
 
ARCHITECTURE behavior OF regbench_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
    

   --Inputs
   signal AddrA : std_logic_vector(3 downto 0) := (others => '0');
   signal AddrB : std_logic_vector(3 downto 0) := (others => '0');
   signal AddrW : std_logic_vector(3 downto 0) := (others => '0');
   signal DATA : std_logic_vector(7 downto 0) := (others => '0');
   signal CK : std_logic := '0';
   signal RST : std_logic := '0';
   signal W : std_logic := '0';

 	--Outputs
   signal QA : std_logic_vector(7 downto 0);
   signal QB : std_logic_vector(7 downto 0);
	-- signal S : array(0 to 15) of std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant ck_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: regbench PORT MAP (
          AddrA => AddrA,
          AddrB => AddrB,
          AddrW => AddrW,
          QA => QA,
          QB => QB,
          DATA => DATA,
          CK => CK,
          RST => RST,
          W => W
        );

   -- Clock process definitions
   ck_process :process
   begin
		CK <= '0';
		wait for ck_period/2;
		CK <= '1';
		wait for ck_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.	
		RST <= '0';
			 
		wait for ck_period;

      -- insert stimulus here 
			 RST <= '1';
          AddrW <= b"0010";
			 AddrA <= b"0011";
			 DATA <= b"11111111";
			 W <= '1';

      wait for ck_period;

      -- insert stimulus here
          AddrW <= b"0000";		
          AddrB <= b"0010";

      wait for ck_period;

      -- insert stimulus here
			 DATA <= b"11011011";
			 W <= '1';
          AddrW <= b"0010";		
          AddrB <= b"0010";
			 
      wait for ck_period;

      -- insert stimulus here
			 DATA <= b"00011000";
			 W <= '0';
          AddrW <= b"0010";		
          AddrB <= b"0010";


      wait;
   end process;

END;
