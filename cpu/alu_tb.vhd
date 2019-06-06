--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:00:44 05/10/2019
-- Design Name:   
-- Module Name:   /home/hanin/Bureau/4eme_annee/4AS2-compilata/cpu/alu_tb.vhd
-- Project Name:  cpu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu
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
 
ENTITY alu_tb IS
END alu_tb;
 
ARCHITECTURE behavior OF alu_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu
    PORT(
         OP : IN  std_logic_vector(3 downto 0);
         A : IN  std_logic_vector(7 downto 0);
         B : IN  std_logic_vector(7 downto 0);
         Sout : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal OP : std_logic_vector(3 downto 0) := (others => '0');
   signal A : std_logic_vector(7 downto 0) := (others => '0');
   signal B : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal Sout : std_logic_vector(15 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu PORT MAP (
          OP => OP,
          A => A,
          B => B,
          Sout => Sout
        );

  
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.	
		A <= x"23";
		B <= x"2A";
		OP <= x"1";
      wait for 100 ns;
		A <= x"42";
		B <= x"69";
		OP <= x"2";
		wait for 100 ns;
		A <= x"94";
		B <= x"30";
		OP <= x"3";
		wait for 100 ns;
		A <= x"04";
		B <= x"02";
		OP <= x"C";
	   wait for 100 ns;
		A <= x"02";
		B <= x"04";
		OP <= x"C";
		wait for 100 ns;
		A <= x"02";
		B <= x"02";
		OP <= x"C";
      -- insert stimulus here 

      wait;
   end process;

END;
