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
		  readdata_left, readdata_right:    in sampleType;
        full_signal :  out std_logic_vector(1023 downto 0 )
		  );
END COMPONENT;



COMPONENT ring_buffer_toplevel is
  port(
        CLK            : in    std_logic;                           -- clock
        RESET          : in    std_logic;                           -- reset
        READ_S         : in    std_logic;
		  s_enable       : in	 std_logic; 									--	mux input         
		  input_data 	  : in	 std_logic_vector(47 downto 0);
		  output_data    : out	 std_logic_vector(1023 downto 0)
		  );
end COMPONENT;



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
					readdata_left => s_auto_enc_readdata_left,
					readdata_right => s_auto_enc_readdata_right,	
					full_signal => s_auto_enc_full_signal
		);

					
  process(clk, reset) is
  begin
	read_ready_sig<=read_ready;
	write_ready_sig <=write_ready;
	write_s<= write_s_sig;
	read_s <= read_s_sig;
	s_enable_sig <= read_s_sig_in;
	s_enable_sig_out_buf<= read_s_sig_out;
	
  end process;
end arch;
