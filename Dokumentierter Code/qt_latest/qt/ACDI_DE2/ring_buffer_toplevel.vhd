library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.audioDataPkg.all;


entity ring_buffer_toplevel
is
  port
    (
        CLK            : in    std_logic;                           -- clock
        RESET          : in    std_logic;                           -- reset
        READ_S         : in    std_logic;
		  s_enable       : in	 std_logic; 									--	mux input         
		  input_data 	  : in	 std_logic_vector(47 downto 0);
		  output_data    : out	 std_logic_vector(1023 downto 0)
		  
    );
end ring_buffer_toplevel;

architecture BEHAVE of ring_buffer_toplevel is

component circular_buffer is 
	 port(
       read : in std_logic;
       write : in std_logic;
       reset : in std_logic;
       datain : in std_logic_vector(48-1 downto 0);
       dataout : out std_logic_vector(48-1 downto 0);
       data_ready : out std_logic;
       clk : in std_logic
); END COMPONENT;

		begin
	
	

		end BEHAVE;