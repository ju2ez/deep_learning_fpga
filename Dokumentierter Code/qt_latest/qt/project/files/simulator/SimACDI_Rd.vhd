-- SimACDI_Rd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SIMACDI_RD is
    port
    (
        CLK        : in    std_logic;                           -- clock
        RESET      : in    std_logic;                           -- reset
        READ       : in    std_logic;                           -- Read command
        BUFEMPTY   : in    std_logic;                           -- Internal Buffer empty
        READ_READY : out   std_logic;                           -- Sample available
        NEXTSAMPLE : out   std_logic                            -- x
    );
end SIMACDI_RD;

architecture BEHAVE of SIMACDI_RD is
begin
    process(RESET, CLK, READ, BUFEMPTY) is
        -- DEFINE A STATE-TYPE
        type TSTATE is(
            WAIT_SAMPLE,   -- 
            SAMPLE_READY,  -- 
            GETNEXTSAMPLE  -- 
        );
        variable STATE : TSTATE;
    begin
        if RESET='1' then
            STATE := WAIT_SAMPLE;
        elsif CLK'event and CLK='1' then
            -- STATE-TRANSITION-FUNCTION
            case STATE is
                when WAIT_SAMPLE =>
                    if((BUFEMPTY='0')) then
                        STATE := SAMPLE_READY;
                    end if;
                when SAMPLE_READY =>
                    if((READ='1')) then
                        STATE := GETNEXTSAMPLE;
                    end if;
                when GETNEXTSAMPLE =>
                    if(true) then
                        STATE := WAIT_SAMPLE;
                    end if;
                when others =>
                    STATE := WAIT_SAMPLE;
            end case;
        end if;
        -- OUTPUT-FUNCTION
        case STATE is
                when WAIT_SAMPLE =>
                    READ_READY <= '0';
                    NEXTSAMPLE <= '0';
                when SAMPLE_READY =>
                    READ_READY <= '1';
                    NEXTSAMPLE <= '0';
                when GETNEXTSAMPLE =>
                    READ_READY <= '0';
                    NEXTSAMPLE <= '1';
            end case;
    end process;

end BEHAVE;
