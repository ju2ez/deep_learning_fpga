library ieee;
use ieee.std_logic_1164.all;
use work.audioDataPkg.all;

entity tb_testWithSimulator is
end  tb_testWithSimulator;

architecture tb of  tb_testWithSimulator is
	COMPONENT simulationacdi
		PORT(clk : IN STD_LOGIC;
			 reset : IN STD_LOGIC;
			 Read_s : IN STD_LOGIC;
			 Write_s : IN STD_LOGIC;
			 sampleOutL : IN sampleType;
			sampleOutR: in sampleType;
			readReady :  OUT  STD_LOGIC;
			writeReady :  OUT  STD_LOGIC;
			sampleL :  OUT  sampleType;
			sampleR: OUT sampleType
		);
	END COMPONENT;

	COMPONENT copy_machine
		PORT(clk : IN STD_LOGIC;
			 reset : IN STD_LOGIC;
			 read_ready : IN STD_LOGIC;
			 write_ready : IN STD_LOGIC;
			 readdata_left : IN sampleType;
			 readdata_right : IN sampleType;
			 read_s : OUT STD_LOGIC;
			 write_s : OUT STD_LOGIC;
			 writedata_left : OUT sampleType;
			 writedata_right : OUT sampleType
		);
	END COMPONENT;

  for all: copy_machine use entity work.copy_machine;
  for all: simulationACDI use entity work.simulationACDI(bdf_type);
  signal reset, clk: std_logic;
  signal readData_left, readData_right,
         writeData_left, writeData_right: sampleType;
  signal read_ready, write_ready, read_s, write_s: std_logic; 
begin
  dut: copy_machine
    port map(clk => clk,
			 reset => reset,
			 read_ready => read_ready,
			 write_ready => write_ready,
			 readdata_left => readdata_left,
			 readdata_right  => readdata_right,
			 read_s => read_s,
			 write_s => write_s,
			 writedata_left => writeData_left,
			 writedata_right => writeData_right);
			 
  simulator: simulationacdi
		port map(clk => clk,
			 reset => reset,
			 Read_s  => read_s,
			 Write_s => write_s,
			 sampleOutL => writeData_left,
			 sampleOutR => writeData_right,
			 readReady => read_ready,
			 writeReady => write_ready,
			 sampleL => readData_left,
			 sampleR => readData_right);
			 
  process is
  begin
    clk <= '0', '1' after 10 ns;
    wait for 20 ns;
  end process;
  reset <= '1', '0' after 100 ns;
end tb;
