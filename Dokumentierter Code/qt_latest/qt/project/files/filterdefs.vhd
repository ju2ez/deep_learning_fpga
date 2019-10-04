library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package filterdefs is
  constant filter_length: integer := 4;
  constant sample_length: integer := 24;
  subtype Sample_type is signed(sample_length-1 downto 0);
  type Filter_param_type is array(filter_length-1 downto 0) of Sample_type;
  subtype stdLogicVector32 is std_logic_vector(31 downto 0);
  type array_stdLogicVector32 is array(filter_length - 1 downto 0) of stdLogicVector32;
  subtype signed24_8 is signed(31 downto 0);
  type array_signed24_8 is array(filter_length-1 downto 0) of signed24_8;
  subtype product_type is signed(47 downto 0); -- 24 + 24 bit
  type array_products is array(filter_length-1 downto 0) of product_type;

end filterdefs;