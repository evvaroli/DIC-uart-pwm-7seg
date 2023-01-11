library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity PWM is
	port(clk195kHz: in std_logic;
	     Ena: in std_logic;
		  DC: in unsigned (7 downto 0);
  		  ClkO: out std_logic;
		  PWM1: out std_logic;
		  PWM2: out std_logic
		 );
end PWM;

architecture PWM_a of PWM is
Signal Count1, Count2 : unsigned (7 downto 0);
Signal CountPre : unsigned (12 downto 0);

begin
PWMi1 : PROCESS (clk195kHz)
begin
	IF (clk195kHz'EVENT AND clk195kHz = '1') THEN
		IF Ena = '1' THEN 
			Count1 <= Count1+1;
			IF Count1 >= 100 THEN
				Count1 <= (others=>'0');
			ELSIF Count1 >= 25 THEN
				PWM1 <= '1';
			ELSE 
				PWM1 <= '0';
			END IF;
 		END IF;
	END IF;
ClkO <= Count1(0);
END PROCESS PWMi1;

PWMi2 : PROCESS (clk195kHz)
begin
	IF (clk195kHz'EVENT AND clk195kHz = '1') THEN
		IF Ena = '1' THEN 
			IF CountPre < 3000 THEN
				CountPre <= CountPre+1;
			ELSE
				CountPre <= (others=>'0');
				Count2 <= Count2+1;
				IF Count2 >= 255 THEN
					Count2 <= (others=>'0');
				ELSIF Count2 >= DC THEN
					PWM2 <= '1';
				ELSE 
					PWM2 <= '0';
				END IF;
			END IF;
 		END IF;
	END IF;
END PROCESS PWMi2;

end PWM_a;