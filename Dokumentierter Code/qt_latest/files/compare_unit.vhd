library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.audioDataPkg.all;


entity compare_unit
is
  port
    (
        CLK             : in    std_logic;                           -- clock
        RESET           : in    std_logic;                           -- reset
        READ_S          : in    std_logic;       
		  full_signal_in  : in std_logic_vector (1023 downto 0);
		  done_processing : out std_logic;
        signal_detected :  out std_logic 
    );
end compare_unit;

architecture BEHAVE of compare_unit is

-- input
signal s_full_signal_in : std_logic_vector (1023 downto 0);

-- output 
signal s_signal_detected : std_logic;

signal true_audio_signal : std_logic_vector (1023 downto 0);
signal difference : integer range -1000 to 1000;
signal max_difference : integer := 100;


begin
	-- input in ff-signal ablegen
	s_full_signal_in <= full_signal_in;
	
	true_audio_signal <= (others => '0');
	
	
	-- input speichern
	check_if_train: process (clk,reset,READ_S)
		begin
			if (reset = '1') then
				  s_signal_detected <= '0';
				  done_processing <='0';
			 elsif (clk'event) and (clk = '1') then
				 if (READ_S='1') then				  
					--difference<= to_integer(unsigned(s_full_signal_in(1023 downto 0)) - unsigned(true_audio_signal(1023 downto 0)));
					-- 1023 downto 0 leads to a too big integer !!
					difference<= to_integer(unsigned(s_full_signal_in(7 downto 0)) - unsigned(true_audio_signal(7 downto 0)));
					if ( difference < max_difference) then
						s_signal_detected <= '1';
					else 
						s_signal_detected <= '0';
					end if;
					done_processing <= '1';
					
					
					 
				else
					done_processing <='0';
				 end if;
				
			end if; 
			end process;
			
			signal_detected <= s_signal_detected;
	

		end BEHAVE;