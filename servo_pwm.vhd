library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


-- clk195kHz = genau 195312,5 Hz
-- Tclk195  = 5,12us
-- 1ms -> 195 steps
-- 1.5ms -> 293 steps
-- 2ms -> 393 steps
-- 20ms -> 3906 steps

-- dutyCycle= 0 -> 165 steps -> 0,8448ms
-- dutyCycle= 255 -> 420 steps -> 2,1504ms


entity servo_pwm is
	port(clk195kHz: in std_logic; 
	     clr: in std_logic;
	     enable: in std_logic;
		  dutyCycle: in std_logic_vector (7 downto 0);
		  pwmOut: out std_logic
		 );
end servo_pwm;

architecture servo_pwm_a of servo_pwm is

signal counter : std_logic_vector (12 downto 0);

signal pwm: std_logic:='1';

constant MIN_PULSE_COUNT: integer:= 165;


begin

  counter1: process ( clk195kHz, clr)
  begin
     if clr = '1' then
        counter <= (others => '0');
     elsif rising_edge(clk195kHz) then
        
		  if counter >= 3906 then  -- 20ms reached
		     counter <= (others => '0');
		  else
   		  counter <= counter+1;      
	     end if;	  
     end if;
  end process counter1;

  pwm1: process ( counter,dutyCycle)

  begin
     if counter <  (("00000"&dutyCycle)+MIN_PULSE_COUNT) then
        pwm <= '1';
     else
        pwm <= '0';
	  end if;	  
  end process pwm1;
  


pwmOut <= enable and pwm;

end servo_pwm_a;