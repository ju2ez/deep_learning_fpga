-- Generation of Sample
-- Produces a triangle sample between 1 and -1
-- 


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.audioDataPkg.all;

entity generateSample is
  generic (delta: sampleType := X"200000";      -- 0.25
           startVal: sampleType := X"100000");  -- 0.0625)
  port(reset, clk: in std_logic;
       genNextSample: in std_logic;
       nextSample: out sampleType) ; 
end generateSample;

architecture behv of generateSample is
  signal currSample, snextSample: sampleType; 
begin
  -- register to buffer Sample		 
  regSample: process(reset, clk, snextSample) is
  begin
	  if (reset = '1') then
		currSample <= startVal;
	  elsif rising_edge(clk) then
		  currSample <= snextSample;
	  end if;
  end process regSample;

  Process(reset, clk, currSample)is
    variable up: boolean := true;
	variable cs, ns: signed(27 downto 0); -- format 28.23 signed
  begin  
    cs := (27 downto 24 => currSample(23)) & currSample;
    if reset='1' then
      ns := (27 downto 24 => startVal(23)) & startVal;
      up := true;
    elsif clk'event and clk = '1' then
      if genNextSample = '1' then 
        if up then                                      -- upwards counting
          if cs <= X"0800000"-delta then  -- not at limit 1
            ns := cs + delta;       
          else                                          -- at limit 1: 2-cs-delta
            ns := x"1000000"-cs-delta;
            up := false;                                -- change direction
          end if;                                       -- 
        else                                            -- up= false => down
          if cs >= X"F800000" + delta then                -- not at limit -1
            ns := cs - delta;           -- decrement delta
          else                                          -- at limit -1: -2-cs+delta
            ns := X"F000000" - cs + delta;             
            up := true;                                 -- change direction
          end if;
        end if;
      end if;
    end if;
	sNextSample <= ns(23 downto 0);
  end process;
  nextSample <= sNextSample;
end behv;