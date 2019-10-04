-- yourCircuit
--
-- a test module for demonstration of simulator
--
-- Creates some simple test patterns for the simulator
-- to demonstrate its usage
-- Replace with own modules for copy and filter
-- 
-- GHartung 2016/11
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.audioDataPkg.all;

entity yourCircuit is
  port(clk, reset: in std_logic;
       read_ready, write_ready: in STD_LOGIC;
       readdata_left, readdata_right:    in sampleType;
        writedata_left, writedata_right:  out sampleType;
        read_s, write_s: out STD_LOGIC);
end yourCircuit;

architecture test of yourCircuit is
begin
  process(clk, reset) is
    constant STIM_MAX: natural := 10;
    variable state: natural range 0 to STIM_MAX;
	constant stim_read_s: std_logic_vector(0 to STIM_MAX) := (1=>'1', 4=>'1',6=>'1', 7=>'1', others => '0');
    constant stim_write_s: std_logic_vector(0 to STIM_MAX) := (2=>'1', 5=>'1',8=>'1', 9=>'1', others => '0');	
	variable next_stim_read_s: std_logic_vector(0 to STIM_MAX);
	variable next_stim_write_s: std_logic_vector(0 to STIM_MAX);
	variable patt: sampleType;
  begin
    next_stim_read_s := stim_read_s(1 to STIM_MAX)&'0';
	next_stim_write_s := stim_write_s(1 to STIM_MAX)&'0';
    if reset = '1' then
	  patt := (others => '0');
	  state := 0;
	elsif rising_edge(clk) then
	  -- wait read_ready if next stimulus is read
	  if next_stim_read_s(state) = '1' and read_ready = '1' then
	    if state < STIM_MAX then
	      state := state + 1;
	    end if;
	  -- wait write_ready if next stimulus is write
	  elsif next_stim_write_s(state) = '1' and write_ready = '1' then
	    if state < STIM_MAX then
	      state := state + 1;
	    end if;
	  elsif next_stim_read_s(state) = '0' and next_stim_write_s(state) = '0' then
	    if state < STIM_MAX then
	      state := state + 1;
	    end if;
	  end if;
	end if;
	read_s <= stim_read_s(state);
	write_s <= stim_write_s(state);
	writedata_left <= to_signed(state,sample_width);
	writedata_right <= to_signed(state,sample_width);
  end process;
end test;
