library ieee;
use ieee.std_logic_1164.all;
use work.audioDataPkg.all;

entity tb_audio_processing_copy_machine is
end  tb_audio_processing_copy_machine;

architecture tb of  tb_audio_processing_copy_machine is
	
	component copy_machine is 
		port(clk, reset: in std_logic;
       read_ready, write_ready: in STD_LOGIC;
       readdata_left, readdata_right:    in sampleType;
       writedata_left, writedata_right:  out sampleType;
		 led_out : out STD_LOGIC;
       read_s, write_s: out STD_LOGIC);
end component;
	


	
	for all: copy_machine use entity work.copy_machine;
	signal reset, clk: std_logic;
   signal readData_left, readData_right,
         writeData_left, writeData_right: sampleType;
   signal read_ready, write_ready, read_s, write_s, led_out: std_logic; 
	
	signal READ_S_2 , s_enable : std_logic;
	--signal input_data :  std_logic_vector(47 downto 0);
	--signal output_data : std_logic_vector(1023 downto 0);
	
	
begin
  copy_machine_comp: copy_machine
    port map(clk => clk,
			 reset => reset,
			 read_ready => read_ready,
			 write_ready => write_ready,
			 readdata_left => readdata_left,
			 readdata_right  => readdata_right,
			 read_s => read_s,
			 write_s => write_s,
			 writedata_left => writeData_left,
			 writedata_right => writeData_right,
			 led_out => led_out);
			 
	
	
	
		  process is
		  begin
			 clk <= '0', '1' after 10 ns;
			 wait for 20 ns;
		  end process;
		  write_ready <= '0', '1' after 100 ns;
		  read_ready <= '1', '0' after 100 ns;
		  readdata_left <= (others => '0');
		  readdata_right <=  (others => '1');
		  reset <= '0';
end tb;