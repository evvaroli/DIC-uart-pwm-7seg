library ieee;
use ieee.std_logic_1164.all;


entity rx_buffer is 
  port (
    rdrf : in STD_LOGIC;
    rx_data : in STD_LOGIC_VECTOR (7 downto 0);
	 clr: in std_logic;
	 
    data0 : out STD_LOGIC_VECTOR (7 downto 0);
	 data1 : out STD_LOGIC_VECTOR (7 downto 0)
  ); 
end  rx_buffer;



architecture rx_buffer_arch of rx_buffer is

 signal data0_temp : STD_LOGIC_VECTOR (7 downto 0);
 signal data1_temp : STD_LOGIC_VECTOR (7 downto 0);


begin

   process(rdrf)
   begin 
     if clr = '1' then
	     data0_temp <= (others =>'0');
	     data1_temp <= (others =>'0');
	  elsif rising_edge(rdrf) then
       data1_temp <= data0_temp;	  
       data0_temp <= rx_data;	  
	  end if;
   end process;
	data1 <= data1_temp;
	data0 <= data0_temp;
	
end rx_buffer_arch;
