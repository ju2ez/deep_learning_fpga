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
        SAMPLE_RECEIVED : out   std_logic;                          
        READ_READY    : out   std_logic ;           
		  readdata_left, readdata_right:    in sampleType;
        writedata_left, writedata_right:  out sampleType;
		  
    );
end buffer_register;

architecture BEHAVE of input_buffer_register is
begin
    

end BEHAVE;
