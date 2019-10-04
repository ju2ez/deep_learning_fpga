-- simACDIPkg
-- defines delays in the simulator for samples and initialization

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package simACDIPkg is
  constant InitDelay: unsigned(15 downto 0) := to_unsigned(100,16);
  constant SampleDelay: unsigned(15 downto 0) := to_unsigned(50,16);
end simACDIPkg;
  