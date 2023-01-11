-- 4-bit full adder
library ieee;
use ieee.std_logic_1164.all;

entity fa4 is
   port(
         a_in: in std_logic_vector (3 downto 0);
         b_in: in std_logic_vector (3 downto 0);
         c_in: in std_logic;
         sum_out: out std_logic_vector (3 downto 0);
         c_out: out std_logic
       );
end fa4;


architecture behav of fa4 is

component fa is
  port( a_in : in std_logic;
        b_in : in std_logic;
        c_in : in std_logic;
        s_out : out std_logic;
        c_out : out std_logic
       );
end component;

signal cout_int : std_logic_vector (2 downto 0) := "000";

begin

 fa1: fa PORT MAP (
	a_in => a_in(0),
	b_in => b_in(0),
	c_in => c_in,
	s_out => sum_out(0),
	c_out => cout_int(0)
        );

 fa2: fa PORT MAP (
	a_in => a_in(1),
	b_in => b_in(1),
	c_in => cout_int(0),
	s_out => sum_out(1),
	c_out => cout_int(1)
        );

 fa3: fa PORT MAP (
	a_in => a_in(2),
	b_in => b_in(2),
	c_in => cout_int(1),
	s_out => sum_out(2),
	c_out => cout_int(2)
        );

 fa4: fa PORT MAP (
	a_in => a_in(3),
	b_in => b_in(3),
	c_in => cout_int(2),
	s_out => sum_out(3),
	c_out => c_out
        );


end architecture behav;
