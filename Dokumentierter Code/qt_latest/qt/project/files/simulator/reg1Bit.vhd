library ieee;
use ieee.std_logic_1164.all;
entity reg1Bit is
  port(clk, reset, w : in std_logic;
       d: in std_logic;
       q: out std_logic);
end reg1Bit;

architecture behv of reg1Bit is
begin
  process(clk, reset, w, d) is
    variable state: std_logic;
  begin
    if reset = '1' then
      state := '0';
    elsif rising_edge(clk) then
      if w = '1' then
        state := d;
      end if;
    end if;
    q <= state;
  end process;
end behv;
