--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:38:33 05/13/2019
-- Design Name:   
-- Module Name:   /home/hanin/Bureau/4eme_annee/4AS2-compilata/cpu/memory_tb.vhd
-- Project Name:  cpu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: memory
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
 
ENTITY memory_tb IS
END memory_tb;
 
ARCHITECTURE behavior OF memory_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT memory
    PORT(
         Addr : IN  std_logic_vector(15 downto 0);
         Din : IN  std_logic_vector(15 downto 0);
         Dout : OUT  std_logic_vector(15 downto 0);
         CK : IN  std_logic;
         W : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Addr : std_logic_vector(15 downto 0) := (others => '0');
   signal Din : std_logic_vector(15 downto 0) := (others => '0');
   signal CK : std_logic := '0';
   signal W : std_logic := '0';

 	--Outputs
   signal Dout : std_logic_vector(15 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant ck_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: memory PORT MAP (
          Addr => Addr,
          Din => Din,
          Dout => Dout,
          CK => CK,
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
      wait for 100 ns;	

      wait for ck_period;
		W <='1';
		Addr <= x"000A";
		Din <= x"0042";

      wait for ck_period;
		W <='1';
		Addr <= x"000B";
		Din <= x"ACC0";

      wait for ck_period;
		W <='0';
		Addr <= x"000A";
		
      wait for ck_period;
		Addr <= x"000B";

      -- insert stimulus here 

      wait;
   end process;

END;
