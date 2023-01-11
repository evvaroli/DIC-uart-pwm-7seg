------------------------------
-- counterNbit
------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity counterNbit is
   generic (N : integer :=8);
   port( clr: in std_logic;
         clk: in std_logic;
         q: out std_logic_vector(N-1 downto 0)
        ); 
end counterNbit;

architecture arch of counterNbit is
signal counterValue: std_logic_vector (N-1 downto 0);
begin
   process(clr, clk)
   begin 
     if clr = '1' then
	     counterValue <= (others =>'0');
	  elsif rising_edge(clk) then
        counterValue <= counterValue + 1;	  
	  end if;
   end process;
	
	q <= counterValue;

end architecture arch;