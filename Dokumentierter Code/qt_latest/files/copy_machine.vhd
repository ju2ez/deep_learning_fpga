-- copy_machine
--
-- A state machine and signal forwarding/processing unit based on the lab of Gregor Hartung @TH Köln
--
-- created by Julian Hatzky
-- 
-- Modules for copy and filter
-- CopyRights:
-- GHartung 2016/11
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.audioDataPkg.all;


entity copy_machine is
  port(clk, reset: in std_logic;
       read_ready, write_ready: in STD_LOGIC;
       readdata_left, readdata_right:    in sampleType;
       writedata_left, writedata_right:  out sampleType;
		 led_out : out STD_LOGIC;
       read_s, write_s: out STD_LOGIC);
end copy_machine;

architecture arch of copy_machine is

COMPONENT copy_machine_control_unit 
	PORT(
        CLK            : in    std_logic;                           -- clock
        RESET          : in    std_logic;                           -- reset
	     READ_READY    : in   std_logic ;   
		  WRITE_READY : in std_logic;
        READ_S_IN_BUF         : out    std_logic;                           -- x
		  READ_S_OUT_BUF 	  : out   std_logic;
		  READ_FROM_CODEC : out std_logic;
		  WRITE_TO_CODEC : out std_logic
		  );                         -- 
END COMPONENT;

COMPONENT buffer_register
	PORT(
		  CLK            : in    std_logic;                           -- clock
        RESET          : in    std_logic;                           -- reset
        READ_S         : in    std_logic;
		  s_enable       : in	 std_logic; 									--	mux input           
		  readdata_left, readdata_right:    in sampleType;
        writedata_left, writedata_right:  out sampleType);
END COMPONENT;

COMPONENT denoising_auto_encoder 
	PORT(
		  CLK            : in    std_logic;                           -- clock
        RESET          : in    std_logic;                           -- reset
        READ_S         : in    std_logic;
		  s_enable       : in	 std_logic; 									--	mux input           
		  full_signal_in : in    std_logic_vector(1023 downto 0 );
		  done_processing : out std_logic;
        full_signal :  out std_logic_vector(1023 downto 0 )
		  );
END COMPONENT;



COMPONENT ring_buffer_toplevel is
  port(
       clk : in std_logic;
		 rst : in std_logic;
	 
		 -- Write port
		 wr_en : in std_logic;
		 wr_data : in std_logic_vector(48 - 1 downto 0);
	 
		 -- Read port
		 rd_en : in std_logic;
		 rd_valid : out std_logic;
		 rd_data : out std_logic_vector(48 - 1 downto 0);
	 
		 -- Flags
		 empty : out std_logic;
		 empty_next : out std_logic;
		 full : out std_logic;
		 full_next : out std_logic;
	 
		 -- The number of elements in the FIFO
		 fill_count : out integer range 20 - 1 downto 0
		  );
end COMPONENT;


component compare_unit is
	port(
			  CLK             : in    std_logic;                           -- clock
			  RESET           : in    std_logic;                           -- reset
			  READ_S          : in    std_logic;       
			  full_signal_in  : in    std_logic_vector (1023 downto 0);
			  done_processing : out std_logic;
			  signal_detected : out   std_logic 
			);
end component;


component full_signal_unit
is
  port
    (
        CLK             : in    std_logic;                           -- clock
        RESET           : in    std_logic;                           -- reset
        buffer_full     : in    std_logic;
		  buffer_empty    : in    std_logic;
		  done_processing : in   std_logic ; 
		  full_signal_in  : in    std_logic_vector(47 downto 0) ;
		  fill_count_in   : in    integer range 20 - 1 downto 0;
		  read_data_out       : out   std_logic;
		  write_data      : out   std_logic;
		  read_ready      : out   std_logic;
        full_signal 	   : out   std_logic_vector(1023 downto 0) 
		  
    );
end component;



signal read_ready_sig : std_logic;
signal write_ready_sig : std_logic;

signal read_s_sig : std_logic;
signal read_s_sig_in, read_s_sig_out : std_logic;
signal write_s_sig : std_logic;


signal s_enable_sig, s_enable_sig_out_buf : std_logic;

signal buffered_input_left,buffered_input_right : sampleType ;

 signal s_auto_enc_read_s : std_logic;
 signal s_auto_enc_s_enable : std_logic;
 signal s_auto_enc_readdata_left : sampleType;
 signal s_auto_enc_readdata_right : sampleType;
 signal s_auto_enc_writedata_left : sampleType;
 signal s_auto_enc_writedata_right : sampleType;
 signal s_auto_enc_full_signal : std_logic_vector(1023 downto 0);


signal s_compare_unit_full_signal: std_logic_vector (1023 downto 0); 
signal s_signal_detected : std_logic;
signal s_compare_unit_read_s : std_logic;
 
 
signal s_ledR : std_logic; 


signal s_ringbuffer_in : std_logic_vector(47 downto 0);
signal s_ringbuffer_out : std_logic_vector(47 downto 0);
signal s_ringbuffer_enable : std_logic;
signal s_ringbuffer_read_s : std_logic;
signal s_ringbuffer_write_s : std_logic;
signal s_ringbuffer_rd_valid : std_logic;
signal s_ringbuffer_empty, s_ringbuffer_empty_next, s_ringbuffer_full, s_ringbuffer_full_next : std_logic;
signal s_ringbuffer_fill_count : integer range 21 - 1 downto 0;


signal s_full_signal : std_logic_vector(1023 downto 0);
signal s_full_signal_unit_read : std_logic;
signal s_read_data : std_logic;

signal s_done_processing,s_done_processing_autoenc, s_done_processing_compare_unit: std_logic;



begin	
		control_unit : copy_machine_control_unit
		PORT MAP(
					CLK=>clk,
					RESET => reset,
					READ_S_IN_BUF => read_s_sig_in,
					READ_S_OUT_BUF => read_s_sig_out,
					READ_READY => read_ready,
					WRITE_READY => write_ready,
					READ_FROM_CODEC => read_s_sig,
					WRITE_TO_CODEC => write_s_sig
					);
					
	
		input_register : buffer_register
		PORT MAP(
					CLK => clk,
					RESET => reset,
					READ_S => read_s_sig_in,
					s_enable => s_enable_sig,
					readdata_left => readdata_left,
					readdata_right => readdata_right,
					writedata_left => buffered_input_left,
					writedata_right => buffered_input_right
		);
		
		
		output_register : buffer_register
		PORT MAP(
					CLK => clk,
					RESET => reset,
					READ_S => read_s_sig_out,
					s_enable => s_enable_sig_out_buf,
					readdata_left => buffered_input_left,
					readdata_right => buffered_input_right,	
					writedata_left => writedata_left,
					writedata_right => writedata_right
		);
		
		
		denoising_AutoEncoder: denoising_auto_encoder
		PORT MAP(
					CLK => clk,
					RESET => reset,
					READ_S => s_auto_enc_read_s,
					s_enable => s_auto_enc_s_enable,
					full_signal_in => s_full_signal,
					done_processing => s_done_processing_autoenc, 
					full_signal => s_auto_enc_full_signal
		);
		
		cmp_unit : compare_unit
		PORT MAP (
			  CLK             => clk,                  
			  RESET           => reset, 
			  READ_S          => s_done_processing_autoenc,      
			  full_signal_in  => s_compare_unit_full_signal,
			  done_processing => s_done_processing_compare_unit,
			  signal_detected => s_ledR
		);
		
		
		rng_buf : ring_buffer_toplevel 
		PORT MAP (
	
		  clk  => clk,
		  rst  => reset,
		  
		 -- Write port
		  wr_en => s_ringbuffer_write_s,
		  wr_data => s_ringbuffer_in,
	 
		 -- Read port
		  rd_en => s_read_data,
		  rd_valid => s_ringbuffer_rd_valid,
		  rd_data => s_ringbuffer_out,
	 
		 -- Flags
		 empty => s_ringbuffer_empty,
		 empty_next => s_ringbuffer_empty_next,
		 full => s_ringbuffer_full,
		 full_next => s_ringbuffer_full_next, 
	 
		 -- The number of elements in the FIFO
		 fill_count => s_ringbuffer_fill_count

		);
		
		
		full_signal_u : full_signal_unit 
		PORT MAP (
			  CLK            => clk,
			  RESET          => reset,
			  buffer_full    => s_ringbuffer_full,
			  buffer_empty   => s_ringbuffer_empty,
			  done_processing => s_done_processing,
			  full_signal_in => s_ringbuffer_out,	
			  fill_count_in  => s_ringbuffer_fill_count,  
			  read_data_out      => s_read_data, 
			  write_data     => s_ringbuffer_write_s,
			  read_ready     => s_full_signal_unit_read,
			  full_signal 	  => s_full_signal
			  
    );
		

		

					
  process(clk, reset) is
  begin
	read_ready_sig<=read_ready;
	write_ready_sig <=write_ready;
	write_s<= write_s_sig;
	read_s <= read_s_sig;
	s_enable_sig <= read_s_sig_in;
	s_enable_sig_out_buf<= read_s_sig_out;
	s_compare_unit_full_signal <= s_auto_enc_full_signal;
	led_out <= s_ledR;
	s_ringbuffer_in(47 downto 24) <= std_logic_vector(buffered_input_left);
   s_ringbuffer_in(23 downto 0) <= std_logic_vector(buffered_input_right);
	s_ringbuffer_enable <= s_enable_sig;
	s_ringbuffer_read_s <= s_enable_sig;
	s_done_processing <= s_done_processing_compare_unit;
	s_auto_enc_read_s <= s_full_signal_unit_read;
	
  end process;
end arch;
