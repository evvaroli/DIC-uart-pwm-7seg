
library ieee;
use ieee.std_logic_1164.all;


entity decoder1of8 is
   port( sel: in std_logic_vector(2 downto 0);
         y: out std_logic_vector(7 downto 0)
        ); 
end decoder1of8;

architecture arch of decoder1of8 is

begin
   process(sel)
   begin 
      case sel is
           when "000"  => y <= "00000001"; 
           when "001"  => y <= "00000010";  -- 1
           when "010"  => y <= "00000100";  -- 2
           when "011"  => y <= "00001000";  -- 3
           when "100"  => y <= "00010000";  -- 4
           when "101"  => y <= "00100000";  -- 5
           when "110"  => y <= "01000000";  -- 6
           when others => y <= "10000000"; -- 
      end case;

   end process;


end architecture arch;
