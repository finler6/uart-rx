-- uart_rx_fsm.vhd: UART controller - finite state machine controlling RX side
-- Author(s): Gleb Litvinchuk (xlitvi02)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



entity UART_RX_FSM is
    port(
       CLK : in std_logic;
       RST : in std_logic;
	int : in std_logic;
	count1    : in std_logic_vector(4 downto 0);
	ard       : in std_logic;
	rd_data   : out std_logic;
	count1_en : out std_logic;
	valid_data: out std_logic
    );
end entity;



architecture behavioral of UART_RX_FSM is

type mycond is (wait_t, data_wait, data_read, wait_stop, valid);

signal state: mycond := wait_t;

begin
	rd_data  <= '1' when state = data_read else '0';
	count1_en <= '1' when state = data_wait or state = wait_stop or state = data_read else '0';
	valid_data     <= '1' when state = valid else '0';
	
	man: process (CLK) begin
      		if rising_edge(CLK) then
         		if RST = '1' then
            			state <= wait_t;
         		else
            			case state is
            			when wait_t => if int = '0' then
                                	state <= data_wait;
                              		end if;
            			when data_wait => if count1 = "11000" then
                                	state <= data_read;
                              		end if;
            			when data_read   => if ard = '1' then
                                	state <= wait_stop;
                              		end if;
            			when wait_stop => if (count1 = "10000" and int = '1') then
                                	state <= valid;
                              		end if;
            			when valid   =>state <=  wait_t;
            			when others => null;
            			end case;
         		end if;
      		end if;
   	end process man;

end architecture;
