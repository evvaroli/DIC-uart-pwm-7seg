-- full adder

library ieee;
use ieee.std_logic_1164.all;


entity fa is
  port( a_in : in std_logic;
        b_in : in std_logic;
        c_in : in std_logic;
        s_out : out std_logic;
        c_out : out std_logic
       );
end fa;

architecture gate_level of fa is

begin
  c_out <= (a_in AND b_in) OR (c_in AND a_in) OR (c_in AND b_in) ;
  s_out <= (a_in xor b_in) xor c_in;

end architecture gate_level;