library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.audioDataPkg.all;


entity full_signal_unit
is
  port
    (
        CLK             : in    std_logic;                           -- clock
        RESET           : in    std_logic;                           -- reset
        buffer_full     : in    std_logic;
		  buffer_empty    : in    std_logic;
		  done_processing : in    std_logic ; 
		  full_signal_in  : in    std_logic_vector(47 downto 0) ;
		  fill_count_in   : in    integer range 21 - 1 downto 0;
		  read_data_out       : out   std_logic;
		  write_data      : out   std_logic;
		  read_ready      : out   std_logic;
        full_signal 	   : out   std_logic_vector(1023 downto 0) 
		   
    );
end full_signal_unit;

architecture BEHAVE of full_signal_unit is

-- input
signal s_next_value :  std_logic_vector(47 downto 0);


-- gespeichert
signal s_current_value : std_logic_vector(47 downto 0) ;

signal s_full_signal : std_logic_vector (1023 downto 0);

signal start_buffering : std_logic;

TYPE State_type IS (Start, Wait_For_Data, Read_Data, Process_Data);  
	SIGNAL State : State_Type;    
		
		
type Feldelement is array (0 to 20) of std_logic_vector(47 downto 0); 
		
signal sig_xN : Feldelement;
		
BEGIN 

		
  PROCESS (clk, reset) 
  BEGIN 
    If (reset = '1') THEN            -- Upon reset, set the state to A
	State <= Start;
 
    ELSIF rising_edge(clk) THEN    -- if there is a rising edge of the
			 -- clock, then do the stuff below
 
	-- The CASE statement checks the value of the State variable,
	-- and based on the value and any other control signals, changes
	-- to a new state.
	CASE State IS
 
		WHEN Start => 
			IF buffer_empty='1' THEN 
				State <= Wait_For_Data; 
			END IF; 
 

		WHEN Wait_For_Data => 
			IF buffer_full='1' THEN 
				State <= Read_Data; 
			END IF; 

		WHEN Read_Data => 
		     
			sig_xn(fill_count_in) <= full_signal_in;
			
			IF buffer_empty='1' THEN 
				State <= Process_Data; 
			END IF; 

		WHEN Process_Data=> 
			IF done_processing='1' THEN 
				State <= Start; 
			ELSE 
				State <= Process_Data; 
			END IF; 
		WHEN others =>
			State <= Start;
	END CASE; 
    END IF; 
  END PROCESS;

-- Decode the current state to create the output
-- if the current state is D, R is 1 otherwise R is 0
      --  full_signal <= (others => '1') WHEN State=Process_Data ELSE (others => '0'); -- for testing purposes
        write_data  <= '1' WHEN State = Wait_For_DATA ELSE '0';
		  read_ready  <= '1' WHEN State = Process_Data ELSE '0'; 
		  read_data_out   <= '1' WHEN State = Read_Data ELSE '0';
	
	
	-- if the state is in Read_Data task is to build up 
	-- the whole input vector within in the circles of the "fill_counter"
		 
		
		full_signal(47   downto 0)  <= sig_xN(0);
		full_signal(95   downto 48) <= sig_xN(1);
		full_signal(143  downto 96 ) <= sig_xn(2);
		full_signal(191  downto 144  ) <= sig_xn(3);
		full_signal(239  downto 192 ) <= sig_xn(4);
		full_signal(287  downto 240   ) <= sig_xn(5);
		full_signal(335  downto 288  ) <= sig_xn(6);
		full_signal(383  downto 336  ) <= sig_xn(7);
		full_signal(431  downto 384  ) <= sig_xn(8);
		full_signal(479  downto 432 ) <= sig_xn(9);
		full_signal(527  downto 480  ) <= sig_xn(10);
		full_signal(575  downto 528  ) <= sig_xn(11);
		full_signal(623  downto 576  ) <= sig_xn(12);
		full_signal(671  downto 624  ) <= sig_xn(13);
		full_signal(719  downto 672  ) <= sig_xn(14);
		full_signal(767  downto 720  ) <= sig_xn(15);
		full_signal(815  downto 768  ) <= sig_xn(16);
		full_signal(863  downto 816 ) <= sig_xn(17);
		full_signal(911  downto 864  ) <= sig_xn(18);
		full_signal(959  downto 912  ) <= sig_xn(19);
		full_signal(1007 downto 960  ) <= sig_xn(20);
		full_signal(1023 downto 1008  ) <= (others => '0');

				
	
		end BEHAVE;