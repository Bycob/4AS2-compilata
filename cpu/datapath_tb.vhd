--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:14:04 05/15/2019
-- Design Name:   
-- Module Name:   /home/hanin/Bureau/4eme_annee/4AS2-compilata/cpu/datapath_tb.vhd
-- Project Name:  cpu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: datapath
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
 
ENTITY datapath_tb IS
END datapath_tb;
 
ARCHITECTURE behavior OF datapath_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT datapath
    PORT(
         CK : IN  std_logic;
         RST : IN  std_logic;
			Instru : IN std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CK : std_logic := '0';
   signal RST : std_logic := '0';
	signal Instru: std_logic_vector(31 downto 0) := x"00000000";
   -- No clocks detected in port list. Replace CK below with 
   -- appropriate port name 
 
   constant CK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: datapath PORT MAP (
          CK => CK,
			 RST => RST,
			 Instru => Instru
        );

   -- Clock process definitions
   CK_process :process
   begin
		CK <= '0';
		wait for CK_period/2;
		CK <= '1';
		wait for CK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		RST <= '1';
		
      -- insert stimulus here 
		-- AFC in reg 1 AAAA
      wait for CK_period;
		Instru <= x"0601AAAA";
		
		-- NOP
      wait for CK_period;
		Instru <= x"00000000";
		
		-- COP reg 1 in reg 0
      wait for CK_period * 4;
		Instru <= x"05000100";
		
		-- NOP
		wait for CK_period;
		Instru <= x"00000000";
		
		-- ADD reg 0 and reg 1 in reg 4
		wait for CK_period * 4;
		Instru <= x"01040001";
		
		-- NOP
		wait for CK_period;
		Instru <= x"00000000";
		
		-- STORE reg 1 in @0000
		wait for CK_period * 4;
		Instru <= x"08060001";
		
		-- NOP
		wait for CK_period;
		Instru <= x"00000000";
      wait;

   end process;

END;
