-- SimACDI_Wr

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SIMACDI_WR is
    port
    (
        CLK         : in    std_logic;                           -- clock
        RESET       : in    std_logic;                           -- reset
        WRITE       : in    std_logic;                           -- Write command
        BUFFULL     : in    std_logic;                           -- Internal Buffer empty
        WRITE_READY : out   std_logic;                           -- Space available
        NEXTSAMPLE  : out   std_logic                            -- GetNextSample cmd to buffer
    );
end SIMACDI_WR;

architecture BEHAVE of SIMACDI_WR is
begin
    process(RESET, CLK, WRITE, BUFFULL) is
        -- DEFINE A STATE-TYPE
        type TSTATE is(
            WAIT_SPACE,    -- 
            SPACE_READY,   -- 
            PUTNEXTSAMPLE  -- 
        );
        variable STATE : TSTATE;
    begin
        if RESET='1' then
            STATE := WAIT_SPACE;
        elsif CLK'event and CLK='1' then
            -- STATE-TRANSITION-FUNCTION
            case STATE is
                when WAIT_SPACE =>
                    if((BUFFULL='0')) then
                        STATE := SPACE_READY;
                    end if;
                when SPACE_READY =>
                    if((WRITE='1')) then
                        STATE := PUTNEXTSAMPLE;
                    end if;
                when PUTNEXTSAMPLE =>
                    if(true) then
                        STATE := WAIT_SPACE;
                    end if;
                when others =>
                    STATE := WAIT_SPACE;
            end case;
        end if;
        -- OUTPUT-FUNCTION
        case STATE is
                when WAIT_SPACE =>
                    WRITE_READY <= '0';
                    NEXTSAMPLE  <= '0';
                when SPACE_READY =>
                    WRITE_READY <= '1';
                    NEXTSAMPLE  <= '0';
                when PUTNEXTSAMPLE =>
                    WRITE_READY <= '0';
                    NEXTSAMPLE  <= '1';
            end case;
    end process;

end BEHAVE;
