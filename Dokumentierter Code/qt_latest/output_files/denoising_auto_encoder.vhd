library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.audioDataPkg.all;


entity denoising_auto_encoder
is
  port
    (
        CLK            : in    std_logic;                           -- clock
        RESET          : in    std_logic;                           -- reset
        READ_S         : in    std_logic;
		  s_enable       : in	 std_logic; 									--	mux input         
		  full_signal_in : in std_logic_vector(1023 downto 0) ;
		  done_processing : out std_logic;
        full_signal 	  :  out std_logic_vector(1023 downto 0) 
		  
    );
end denoising_auto_encoder;

architecture BEHAVE of denoising_auto_encoder is

-- input
signal s_next_value :  std_logic_vector(1023 downto 0) ;

-- gespeichert
signal s_current_value : std_logic_vector(1023 downto 0) ;


begin
	-- input in ff-signal ablegen
	s_next_value <= full_signal_in;
	
	-- input speichern
	buffer_register: process (clk,reset,s_enable)
		begin
			if (reset = '1') then
				  s_current_value  <= (others => '0');
			 elsif (clk'event) and (clk = '1') then
				  -- ausgang ff  erhält  eingang ff
				  s_current_value <= s_next_value;
				 if (READ_S ='1') then				  
						full_signal <= full_signal_in; 
						
						--here the machine learning magic should happen!
						
						done_processing <='1';
						
				 else 
						full_signal <= (others => '0');
				 end if;
			end if; 
			
		
			end process;
	
	

		end BEHAVE;