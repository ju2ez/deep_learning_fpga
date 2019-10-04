library ieee;
use ieee.std_logic_1164.all;
use work.audioDataPkg.all;

entity tb_ringbuffer_and_autoencoder is
end  tb_ringbuffer_and_autoencoder;

architecture tb of  tb_ringbuffer_and_autoencoder is
	
	
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
		  done_processing : in    std_logic ; 
		  full_signal_in  : in    std_logic_vector(47 downto 0) ;
		  fill_count_in   : in    integer range 20 - 1 downto 0;
		  write_data      : out   std_logic;
		  read_ready      : out   std_logic;
        full_signal 	   : out   std_logic_vector(1023 downto 0) 
		  
    );
end component;






	
	
   for all: ring_buffer_toplevel use entity work.ring_buffer_toplevel;
	for all: denoising_auto_encoder use entity work.denoising_auto_encoder;
	signal reset, clk: std_logic;
	signal READ_S_1, READ_S_2 , s_enable, s_enable_2 : std_logic;
	signal input_data :  std_logic_vector(47 downto 0);
	signal output_data : std_logic_vector(1023 downto 0);
	signal full_signal_in, full_signal : std_logic_vector(1023 downto 0) ;
	
	
	 
	signal s_ledR : std_logic; 


	signal s_ringbuffer_in : std_logic_vector(47 downto 0);
	signal s_ringbuffer_out : std_logic_vector(47 downto 0);
	signal s_ringbuffer_enable : std_logic;
	signal s_ringbuffer_read_s : std_logic;
	signal s_ringbuffer_write_s : std_logic;
	signal s_ringbuffer_rd_valid : std_logic;
	signal s_ringbuffer_empty, s_ringbuffer_empty_next, s_ringbuffer_full, s_ringbuffer_full_next : std_logic;
	signal s_ringbuffer_fill_count : integer range 21 - 1 downto 0;
   signal s_auto_enc_full_signal : std_logic_vector(1023 downto 0);

	signal s_full_signal : std_logic_vector(1023 downto 0);
	signal s_full_signal_unit_read : std_logic;


	signal s_auto_enc_s_enable : std_logic;
	signal s_auto_enc_read_s : std_logic;
	
	signal s_done_processing,s_done_processing_autoenc, s_done_processing_compare_unit: std_logic;
	
	
	
	signal s_compare_unit_read_s : std_logic;
	signal s_compare_unit_full_signal_in : std_logic_vector (1023 downto 0);
	signal s_compare_unit_done_processing : std_logic;
	signal s_compare_unit_signal_detected : std_logic;
	
begin
		 
		rng_buf : ring_buffer_toplevel 
		PORT MAP (
	
		  clk  => clk,
		  rst  => reset,
		  
		 -- Write port
		  wr_en => s_ringbuffer_write_s,
		  wr_data => input_data,
	 
		 -- Read port
		  rd_en => s_ringbuffer_read_s,
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
		  

	full_signal_u : full_signal_unit 
		PORT MAP (
			  CLK            => clk,
			  RESET          => reset,
			  buffer_full    => s_ringbuffer_full,
			  buffer_empty   => s_ringbuffer_empty,
			  done_processing => s_done_processing,
			  full_signal_in => s_ringbuffer_out,		
			  write_data     => s_ringbuffer_write_s,
			  read_ready     => s_full_signal_unit_read,
			  full_signal 	  => s_full_signal,
			  fill_count_in => s_ringbuffer_fill_count
			  
    );
	 
	 
	 the_compare_unit :  compare_unit
  PORT MAP(
        CLK             => clk,                      
        RESET           => reset,
        READ_S          => s_compare_unit_read_s,
		  full_signal_in  => s_compare_unit_full_signal_in,
		  done_processing => s_compare_unit_done_processing,
        signal_detected => s_compare_unit_signal_detected
    );


		
			 
	
	
		  process is
		  begin
			 clk <= '0', '1' after 10 ns;
			 wait for 20 ns;
		  end process;
		--  READ_S_1 <= '0', '1' after 100 ns;
		--  s_enable <= '1', '0' after 100 ns;
		  s_ringbuffer_write_s <= '1', '0' after 2000 ns;
		  s_ringbuffer_read_s <= '0', '1' after 2100 ns;
		  input_data <= (others => '1'), (others => '1') after 10 ns;
		  s_auto_enc_read_s <= s_full_signal_unit_read;
		  s_compare_unit_full_signal_in <= s_auto_enc_full_signal;
		  s_compare_unit_read_s <= s_done_processing_autoenc;
		  reset <= '0';
		  
end tb;