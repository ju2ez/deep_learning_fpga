-- input buffer register

--Julian Hatzky

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.audioDataPkg.all;


entity buffer_register is
    port
    (
        CLK            : in    std_logic;                           -- clock
        RESET          : in    std_logic;                           -- reset
        READ_S         : in    std_logic;
		  s_enable       : in	 std_logic; 									--	mux input         
		  readdata_left, readdata_right:    in sampleType;
        writedata_left, writedata_right:  out sampleType
		  
    );
end buffer_register;

architecture BEHAVE of buffer_register is

-- input
signal s_next_value_left: sampleType;
signal s_next_value_right: sampleType;
-- gespeichert
signal s_current_value_left: sampleType;
signal s_current_value_right: sampleType;

begin
	-- input in ff-signal ablegen
	s_next_value_left <= readdata_left;
	s_next_value_right <= readdata_right;
	
	-- input speichern
	buffer_register: process (clk,reset,s_enable)
		begin
			if (reset = '1') then
				  s_current_value_left <= (others => '0');
				  s_current_value_right <= (others => '0');
			 elsif (clk'event) and (clk = '1') then
				  -- ausgang ff  erhält  eingang ff
				  s_current_value_left <= s_next_value_left;
				  s_current_value_right <= s_next_value_right; 		
				 if (s_enable='1') then				  
					writedata_left <= s_current_value_left;
					writedata_right <= s_current_value_right;
				 end if;
		
			end if; 
			end process;
	
	

		end BEHAVE;
