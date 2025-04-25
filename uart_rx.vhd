-- uart_rx.vhd: UART controller - receiving (RX) side
-- Author(s): Gleb Litvinchuk (xlitvi02)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Entity declaration (DO NOT ALTER THIS PART!)
entity UART_RX is
    port(
        CLK      : in std_logic;
        RST      : in std_logic;
        DIN      : in std_logic;
        DOUT     : out std_logic_vector(7 downto 0);
        DOUT_VLD : out std_logic
    );
end entity;


-- Architecture implementation (INSERT YOUR IMPLEMENTATION HERE)
architecture behavioral of UART_RX is
signal count1 	: std_logic_vector(4 downto 0);
signal count2 	: std_logic_vector(3 downto 0);
signal count1_en : std_logic;
signal rd_data  : std_logic;
signal valid_data: std_logic;

begin

    -- Instance of RX FSM
    fsm: entity work.UART_RX_FSM
    port map (
        CLK => CLK,
        RST => RST,
	int => DIN,
	count1 	=> count1,
	count1_en => count1_en,
	rd_data => rd_data,
	ard => count2(3),
	valid_data=> valid_data
    );
    DOUT_VLD <= valid_data;

man: process (CLK) begin
		if rising_edge(CLK) then
			if RST = '1' then
				count1 <= "00000";
				count2 <= "0000";
			else
				if count1_en = '1' then 
					count1 <= count1 + 1;
				else 
					count1 <= "00000";
				end if;
				if rd_data = '1' and (to_integer(unsigned(count1)) >= 16) then
					DOUT(to_integer(unsigned(count2))) <= DIN;
					count2 <= count2 + 1;
					count1 <= "00001";
				end if;
				if rd_data = '0' then 
					count2 <= "0000";
				end if;
			end if; 
		end if;
	end process man;
end architecture;
