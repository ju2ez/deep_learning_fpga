-- copy_machine_control_unit

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.audioDataPkg.all;


entity COPY_MACHINE_CONTROL_UNIT is
    port
    (
        CLK            : in    std_logic;                           -- clock
        RESET          : in    std_logic;                           -- reset
		  READ_READY : in std_logic;
		  WRITE_READY : in std_logic;
        READ_S_IN_BUF         : out    std_logic;                           -- x
		  READ_S_OUT_BUF 	  : out   std_logic;
		  READ_FROM_CODEC : out std_logic;
		  WRITE_TO_CODEC : out std_logic
    );
end COPY_MACHINE_CONTROL_UNIT;

architecture BEHAVE of COPY_MACHINE_CONTROL_UNIT is
begin
    process(RESET, CLK ) is
        -- DEFINE A STATE-TYPE
        type TSTATE is(
            WAIT_FOR_DATA,            -- 
            INPUT_BUFFER,             -- 
            PROCESSING,               -- 
            TO_AUDIO_CODEC_INTERFACE  -- 
        );
        variable STATE : TSTATE;
        -- VARIABLES
        variable READDATA              : std_logic;                           -- Daten wurden erfolgreich in den Buffer geschrieben
        variable OUTPUT_BUFFER         : std_logic_vector(23 downto 0);       -- Schreiben in den output buffer
        variable READ_S                : std_logic;                           -- x
    begin
        if RESET='1' then
            STATE := WAIT_FOR_DATA;
        elsif CLK'event and CLK='1' then
            -- STATE-TRANSITION-FUNCTION
            case STATE is
                when WAIT_FOR_DATA =>
                    if((READ_READY='0')) then
                        STATE := WAIT_FOR_DATA;
                    elsif((READ_READY='1')) then
                        STATE := INPUT_BUFFER;
                    end if;
                when INPUT_BUFFER =>
							if (READ_S='1') then
                        STATE := PROCESSING;
							end if;
							
                when PROCESSING =>
							if((WRITE_READY='1')) then
                        STATE := TO_AUDIO_CODEC_INTERFACE;
							elsif((WRITE_READY='0')) then
                        STATE := PROCESSING;
                    end if;
                when TO_AUDIO_CODEC_INTERFACE =>
                        STATE := WAIT_FOR_DATA;
                when others =>
                    STATE := WAIT_FOR_DATA;
            end case;
        end if;
        -- OUTPUT-FUNCTION
        case STATE is
                when WAIT_FOR_DATA =>
						   READ_S_IN_BUF     <= '0';                        
							READ_S_OUT_BUF 	<= '0';
							READ_FROM_CODEC   <= '1';
							WRITE_TO_CODEC    <= '0';						
							READ_S := '0';
				
                when INPUT_BUFFER =>
                    	READ_S_IN_BUF     <= '1';                        
							READ_S_OUT_BUF 	<= '0';
							READ_FROM_CODEC   <= '0';
							WRITE_TO_CODEC    <= '0';
							READ_S := '1';
                when PROCESSING =>
                    	READ_S_IN_BUF     <= '0';                        
							READ_S_OUT_BUF 	<= '1';
							READ_FROM_CODEC   <= '0';
							WRITE_TO_CODEC    <= '0';
							READ_S := '0';
                when TO_AUDIO_CODEC_INTERFACE =>
                   	READ_S_IN_BUF     <= '0';                        
							READ_S_OUT_BUF 	<= '0';
							READ_FROM_CODEC   <= '0';
							WRITE_TO_CODEC    <= '1';
							READ_S := '0';
            end case;
    end process;

end BEHAVE;
