--
-- clkdiv
--
--
--  0.bit -> 25 MHz 
--  17. bit  -> 190.73 Hz 
--  23. bit  -> 2.98 HZ

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity clkdiv is
  port(
        clk50M: in std_logic;
        clr: in std_logic;
        clk25M: out std_logic;
        clk195kHz: out std_logic;
        clk760Hz: out std_logic;
        clk190Hz: out std_logic;
        clk3Hz:   out std_logic
       );
end clkdiv;

architecture clkdiv of clkdiv is
   signal q: std_logic_vector(23 downto  0);
begin
  -- clock divider
  clkdiv: process ( clk50M, clr)
  begin
     if clr = '1' then
        q <= (others => '0');
     elsif rising_edge(clk50M) then
        q <= q+1;      
     end if;
  end process clkdiv;

  clk25M <= q(0);     --  0.bit -> 25 MHz 
  clk195kHz  <= q(7);  --  7. bit  -> 195kHz 
  clk760Hz <= q(15);  --  15. bit  -> 762,92 Hz 
  clk190Hz <= q(17);  --  17. bit  -> 190.73 Hz 
  clk3Hz <= q(23);    --  23. bit  -> 2.98 HZ

end architecture clkdiv;