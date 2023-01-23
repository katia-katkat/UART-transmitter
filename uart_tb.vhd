--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:16:14 09/27/2022
-- Design Name:   
-- Module Name:   C:/Users/katia/Desktop/Digital design/UART_transmitter/uart_tb.vhd
-- Project Name:  UART_transmitter
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: transmitter
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
 
ENTITY uart_tb IS
END uart_tb;
 
ARCHITECTURE behavior OF uart_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT transmitter
    PORT(
         clock : IN  std_logic;
         trig : IN  std_logic;
			done : OUT std_logic;
         data_in : IN  std_logic_vector(7 downto 0);
         data_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal trig : std_logic := '0';   
	signal done: std_logic := '0';
   signal data_in : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal data_out : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: transmitter PORT MAP (
          clock => clock,
          trig => trig,
			 done => done,
          data_in => data_in,
          data_out => data_out
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clock_period*10;

      -- insert stimulus here 
		trig <= '1';
		data_in <= "10101100";
		wait until done = '1';
		data_in <= "11111111";
      wait;
   end process;

END;
