----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:33:16 09/27/2022 
-- Design Name: 
-- Module Name:    transmitter - Behavioral 
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

entity transmitter is
	generic (clock_per_bit : integer := 10416
	);
    Port ( clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
		   trig :  in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (7 downto 0);
		   done : out std_logic;
           data_out : out  STD_LOGIC);
end transmitter;

architecture Behavioral of transmitter is
type state is(idle, start, send, stop);
signal transmit : state := idle;
signal clock_count : integer range 0 to clock_per_bit-1 :=0;
signal index : integer range 0 to 7 := 0;
signal en : std_logic := '0';

begin   
enable : process(clock)  -- 50Mhz / 2* 9600 = 38400;
	begin 
		if(rising_edge(clock)) then 
			if( trig = '1') then 
				if(clock_count = clock_per_bit - 1 ) then
					en <= '1';
					clock_count <= 0;
				else 
					en <= '0';
					clock_count <= clock_count + 1;
				end if;
			end if;
		end if;
	end process enable;
	
state_machine : process(clock)
	begin 
		if(rising_edge(clock)) then 
            if(reset = '1') then 
              transmit <= idle;
            else
		case transmit is 
			when idle =>
				data_out <= '1';
				done <= '1';
				if (en = '1') then 
					transmit <= start;
				end if;
				
			when start =>
				data_out <= '0';
				done <= '0';
				if (en = '1') then 
				transmit <= send;
				end if;		
				
			when send =>
			done <= '0';
				data_out <= data_in(index);
				if (en = '1') then 
					if(index = 7) then 
						index <= 0;
						transmit <= stop;
					else 
						index <= index + 1;
						transmit <= send;
					end if;
				end if;
			when stop =>
				data_out <= '1';
				if (en = '1') then 
				transmit <= idle;
				end if;
		end case;
		end if;
		end if;
	end process state_machine;
end Behavioral;



