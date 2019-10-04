-- GenSampleCtrl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.simACDIPkg.all;

entity GENSAMPLECTRL is
    port
    (
        CLK         : in    std_logic;                           -- clock
        RESET       : in    std_logic;                           -- reset
        CLKBUF      : out   std_logic                            -- Clock Buffer
    );
end GENSAMPLECTRL;

architecture BEHAVE of GENSAMPLECTRL is
begin
    process(RESET, CLK) is
        -- DEFINE A STATE-TYPE
        type TSTATE is(
            INIT0,      -- 
            WAITINIT,   -- 
            WAITSAMPLE, --
            GENSAMPLE			
        );
        variable STATE : TSTATE;
        -- VARIABLES
        variable CNTINIT       : unsigned(15 downto 0);               -- Initiailzation Counter
        variable CNTNEXTSAMPLE : unsigned(15 downto 0);               -- CoDec Counter
        variable VALSAMPLE     : signed(23 downto 0);                 -- sample value
    begin
        if RESET='1' then
            STATE := INIT0;
        elsif CLK'event and CLK='1' then
            -- STATE-TRANSITION-FUNCTION
            case STATE is
                when INIT0 =>
                    cntInit := INITDELAY; -- variable assignment
                    cntNextSample := SAMPLEDELAY; -- variable assignment
                    STATE := WAITINIT;
                when WAITINIT =>
                    cntInit := cntInit - 1; -- variable assignment
                    if(CNTINIT=0) then
                        STATE := WAITSAMPLE;
                    end if;
                when WAITSAMPLE =>
                    cntNextSample := cntNextSample - 1; -- variable assignment
                    if(CNTNEXTSAMPLE=0) then
                        STATE := GENSAMPLE;
                    end if;
                when GENSAMPLE =>
                    cntNextSample := SAMPLEDELAY; -- variable assignment
					state := WAITSAMPLE;
                when others =>
                    STATE := INIT0;
            end case;
        end if;
        -- OUTPUT-FUNCTION
        case STATE is
                when INIT0 =>
                    CLKBUF <= '0';
                when WAITINIT =>
                    CLKBUF <= '0';
                when WAITSAMPLE =>
                    CLKBUF <= '0';
                when GENSAMPLE =>
                    CLKBUF <= '1';
            end case;
    end process;

end BEHAVE;
