-- Top Level DE2 project
-- For a project using the Intel SoPC Audio Codec Inteface IP

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
library work;
use work.audioDataPkg.all;

ENTITY tb_top_level IS
END tb_top_level;

ARCHITECTURE Struct OF tb_top_level IS





        COMPONENT clock_generator
                PORT(   CLOCK2_50                                                                                                               :IN STD_LOGIC;
                        reset                                                                                                                   :IN STD_LOGIC;
                                AUD_XCK                                                                                                         :OUT STD_LOGIC);
        END COMPONENT;

        COMPONENT audio_and_video_config
                PORT(   CLOCK_50,reset                                                                                          :IN STD_LOGIC;
                        I2C_SDAT                                                                                                                :INOUT STD_LOGIC;
                                I2C_SCLK                                                                                                                :OUT STD_LOGIC);
        END COMPONENT;



      COMPONENT audio_codec
              PORT(CLOCK_50,reset,read_s,write_s               :IN STD_LOGIC;
                   writedata_left, writedata_right             :IN sampleType;
                   AUD_ADCDAT,AUD_BCLK,AUD_ADCLRCK,AUD_DACLRCK :IN STD_LOGIC;
                   read_ready, write_ready                     :OUT STD_LOGIC;
                   readdata_left, readdata_right               :OUT sampleType;
                   AUD_DACDAT                                                                                                      :OUT STD_LOGIC);
      END COMPONENT;
      component yourCircuit is
        port(clk, reset: in std_logic;
             read_ready, write_ready: in STD_LOGIC;
             readdata_left, readdata_right:    in STD_LOGIC_VECTOR(23 DOWNTO 0);
              writedata_left, writedata_right:  out STD_LOGIC_VECTOR(23 DOWNTO 0);
              read_s, write_s: out STD_LOGIC);
      end component;
		
		  component copy_machine is
          port(clk, reset: in std_logic;
       read_ready, write_ready: in STD_LOGIC;
       readdata_left, readdata_right:    in sampleType;
       writedata_left, writedata_right:  out sampleType;
		 led_out : out STD_LOGIC;
       read_s, write_s: out STD_LOGIC);
      end component;
		
	
		
		signal led_on_off : std_logic;
      signal read_s, write_s, read_ready, write_ready: std_LOGIC;
      signal writedata_left, writedata_right, readdata_left, readdata_right: sampleType; 
		
		
		for all: copy_machine use entity work.copy_machine;
		signal reset, clk: std_logic;
	--	signal read_ready, write_ready, read_s, write_s, 
	   signal led_out: std_logic; 
		signal READ_S_2 , s_enable : std_logic;
		
BEGIN
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
		  

END Struct;