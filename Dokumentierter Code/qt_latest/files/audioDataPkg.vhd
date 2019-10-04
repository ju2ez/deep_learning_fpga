library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package audioDataPkg is
  constant sample_width: integer := 24;
  subtype sampleType is signed(sample_width-1 downto 0);
end audioDataPkg;
  