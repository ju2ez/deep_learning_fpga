library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.audioDataPkg.all; 

entity ringbuffer is
  generic(BUFSIZE: integer := 128);
  port(clk, reset: in std_logic;
       clkBuf: in std_logic;
       readS: in std_logic;
       SampleIn: in SampleType;
       SampleOut: out SampleType;
       BufEmpty, BufFull: out std_logic);
end ringbuffer;

architecture behv of ringbuffer is
begin
  process(clk, reset, clkBuf, SampleIn) is
    variable ri, oldri, wi: natural range 0 to BUFSIZE+1;
    type bufferType is array(0 to BUFSIZE) of SampleType;
    variable buf: bufferType;
    constant nullSample: sampleType := (others => '0');
  begin
    if (reset = '1') then
      ri := 0;
      wi := 0;
	  oldri := BUFSIZE;
      buf := (others => nullSample);
    elsif clk'event and clk = '1' then
      if clkBuf = '1' then
        if ((wi + 1) mod (BUFSIZE+1)) /= ri then 
          buf(wi) := sampleIn;
          wi := (wi + 1) mod (BUFSIZE+1); 
        else
          NULL; -- ignore if buffer full
        end if;  
      elsif (readS = '1') then
        if (ri /= wi) then
		  oldri := ri;
          ri := (ri + 1) mod (BUFSIZE+1);
        else
          Null;  -- no new sample available
        end if;
      end if;
    end if;
    SampleOut <= buf(oldri);
    if ri = wi then
      bufEmpty <= '1';
      bufFull <= '0';
    elsif ((wi + 1) mod (BUFSIZE+1)) = ri then
      bufFull <= '1';
      bufEmpty <= '0';
    else
      bufFull <= '0';
      bufEmpty <= '0';
    end if;   
  end process;
end behv;