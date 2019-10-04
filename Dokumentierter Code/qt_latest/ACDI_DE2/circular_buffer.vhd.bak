LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity circular_buffer is
  generic (ram_data_width : integer := 48;    -- width of data
           ram_address_width : integer := 1; -- width of address
           num_values : integer := 48);       -- number of values
  port(
       read : in std_logic;
       write : in std_logic;
       reset : in std_logic;
       datain : in std_logic_vector(ram_data_width-1 downto 0);
       dataout : out std_logic_vector(ram_data_width-1 downto 0);
       data_ready : out std_logic;
       clk : in std_logic
);
end circular_buffer;