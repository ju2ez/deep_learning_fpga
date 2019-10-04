library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.audioDataPkg.all;


entity ring_buffer_toplevel
is
  port
    (
        CLK            : in    std_logic;                           -- clock
        RESET          : in    std_logic;                           -- reset
        READ_S         : in    std_logic;
		  s_enable       : in	 std_logic; 									--	mux input         
		  input_data 	  : in	 std_logic_vector(47 downto 0);
		  output_data    : out	 std_logic_vector(1023 downto 0)
		  
    );
end ring_buffer_toplevel;

architecture BEHAVE of ring_buffer_toplevel is

signal s_all_data : std_logic_vector(1023 downto 0);

signal s_output_data : std_logic_vector (47 downto 0 );
signal s_data_ready : std_logic; 

component circular_buffer is 
	 port(
       read : in std_logic;
       write : in std_logic;
       reset : in std_logic;
       datain : in std_logic_vector(48-1 downto 0);
       dataout : out std_logic_vector(48-1 downto 0);
       data_ready : out std_logic;
       clk : in std_logic
); END COMPONENT;

begin
	  GEN_REG: 
		for I in 0 to 20 generate

	FIRST_BUFFER: if I=0 generate
			B0: circular_buffer port map
         (
			  clk     => CLK,
			  reset   => RESET,
			  read    => READ_S,
			  write   => s_enable,
			  datain  => input_data, 
			  data_ready => s_data_ready,
			  dataout => s_all_data (47 downto 0)
			);
    end generate FIRST_BUFFER;

    MIDDLE_BUFFERS: if I>0 and I<20 generate
      UX: circular_buffer port map
         (
			  clk     => CLK,
			  reset   => RESET,
			  data_ready => s_data_ready,
			  read    => s_data_ready,
			  write   => s_data_ready,
			  datain  => input_data, 
			  dataout => s_all_data (48*(I+1) -1 downto 48*I )
			);
    end generate MIDDLE_BUFFERS;
	 
	 END_BUFFER: if I=20 generate
	  UE:  circular_buffer port map 
	  (
			  clk     => CLK,
			  reset   => RESET,
			  read    => READ_S,
			  write   => s_enable,
			  datain  => input_data, 
			  dataout => s_output_data
	  );
		end generate END_BUFFER;
		
		end generate GEN_REG;
		
		s_all_data (1023 downto 960) <= (others => '0'); -- because 1024 / 48*20 = 64 which leads to 1023 downto 0 which are not set. 
		output_data <= s_all_data;
		

end BEHAVE;