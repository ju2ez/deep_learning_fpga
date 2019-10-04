-- Simulator top level
-- A simulator to replace the Alterat Audio Codec Interface (including Codec)
-- 
-- Georg Hartung, TH Koeln, 2016/11
-- 
-- The simulator was partly created using Alteras BDF editor. 
-- Hence the Altera copyright has to be mentioned:
-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Full Version"
-- CREATED		"Mon Nov 14 13:43:15 2016"

-- generated with Altera blockdiagram editor and 
-- enhanced with meaningful names
-- Adapted to package
-- Error Correction
-- Georg Hartung 2016/11/21

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;
use work.audioDataPkg.all;

ENTITY SimulationACDI IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		read_s :  IN  STD_LOGIC;
		write_s :  IN  STD_LOGIC;
		sampleOutL :  IN  sampleType;
		sampleOutR: in sampleType;
		readReady :  OUT  STD_LOGIC;
		writeReady :  OUT  STD_LOGIC;
		sampleL :  OUT  sampleType;
		sampleR: OUT sampleType
	);
END SimulationACDI;

ARCHITECTURE bdf_type OF SimulationACDI IS 

COMPONENT generatesample
GENERIC (delta : sampleType;
			startVal : sampleType
			);
	PORT(reset : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 genNextSample : IN STD_LOGIC;
		 nextSample : OUT sampleType
	);
END COMPONENT;

COMPONENT simacdi_rd
	PORT(CLK : IN STD_LOGIC;
		 RESET : IN STD_LOGIC;
		 read : IN STD_LOGIC;
		 BUFEMPTY : IN STD_LOGIC;
		 READ_READY : OUT STD_LOGIC;
		 NEXTSAMPLE : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT ringbuffer
GENERIC (BUFSIZE : INTEGER
			);
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 clkBuf : IN STD_LOGIC;
		 readS : IN STD_LOGIC;
		 SampleIn : IN sampleType;
		 BufEmpty : OUT STD_LOGIC;
		 BufFull : OUT STD_LOGIC;
		 SampleOut : OUT sampleType
	);
END COMPONENT;

COMPONENT simacdi_wr
	PORT(CLK : IN STD_LOGIC;
		 RESET : IN STD_LOGIC;
		 write : IN STD_LOGIC;
		 BUFFULL : IN STD_LOGIC;
		 WRITE_READY : OUT STD_LOGIC;
		 NEXTSAMPLE : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT gensamplectrl
	PORT(CLK : IN STD_LOGIC;
		 RESET : IN STD_LOGIC;
		 CLKBUF : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT outsamplectrl
	PORT(CLK : IN STD_LOGIC;
		 RESET : IN STD_LOGIC;
		 CLKBUF : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT reg1bit
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 w : IN STD_LOGIC;
		 d : IN STD_LOGIC;
		 q : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	genSampleNow :  STD_LOGIC;
SIGNAL	syntSampleNew :  sampleType;
SIGNAL	readBufEmpty :  STD_LOGIC;
SIGNAL	readBuf_Write :  STD_LOGIC;
SIGNAL	readBuf_Read :  STD_LOGIC;
SIGNAL	writeBuf_BufFull :  STD_LOGIC;
SIGNAL	writeBuf_Read :  STD_LOGIC;
SIGNAL	write_outBuffer :  STD_LOGIC;
signal sample: sampleType;
BEGIN 

b2v_inst1 : simacdi_rd
PORT MAP(CLK => clk,
		 RESET => reset,
		 read => read_s,
		 BUFEMPTY => readBufEmpty,
		 READ_READY => readReady,
		 NEXTSAMPLE => readBuf_Read);

b2v_inst4 : gensamplectrl
PORT MAP(CLK => clk,
		 RESET => reset,
		 CLKBUF => genSampleNow);


b2v_inst : generatesample
GENERIC MAP(delta => "001000000000000000000000",
			startVal => "000110000000000000000000"
			)
PORT MAP(reset => reset,
		 clk => clk,
		 genNextSample => genSampleNow,
		 nextSample => syntSampleNew);

b2v_inst8 : reg1bit
PORT MAP(clk => clk,
		 reset => reset,
		 w => '1',
		 d => genSampleNow,
		 q => readBuf_Write);

-- read_s buffer
b2v_inst2 : ringbuffer
GENERIC MAP(BUFSIZE => 128
			)
PORT MAP(clk => clk,
		 reset => reset,
		 clkBuf => readBuf_Write,
		 readS => readBuf_Read,
		 SampleIn => syntSampleNew,
		 BufEmpty => readBufEmpty,
		 SampleOut => sample);

sampleL <= sample;
sampleR <= sample;

b2v_inst3 : simacdi_wr
PORT MAP(CLK => clk,
		 RESET => reset,
		 write => write_s,
		 BUFFULL => writeBuf_BufFull,
		 WRITE_READY => writeReady,
		 NEXTSAMPLE => write_outBuffer);


b2v_inst7 : outsamplectrl
PORT MAP(CLK => clk,
		 RESET => reset,
		 CLKBUF => writeBuf_Read);

		 
-- Output Ringbuffer
b2v_inst5 : ringbuffer
GENERIC MAP(BUFSIZE => 128
			)
PORT MAP(clk => clk,
		 reset => reset,
		 clkBuf => write_outBuffer,
		 readS => writeBuf_Read,
		 SampleIn => sampleOutL,
		 BufFull => writeBuf_BufFull);


END bdf_type;