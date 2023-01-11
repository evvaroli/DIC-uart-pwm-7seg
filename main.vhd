library ieee;
use ieee.std_logic_1164.all;

-- PIN_127 -to a_to_g[6]
-- PIN_126 -to a_to_g[5]
-- PIN_125 -to a_to_g[4]
-- PIN_124 -to a_to_g[3]
-- PIN_121 -to a_to_g[2]
-- PIN_120 -to a_to_g[1]
-- PIN_119 -to a_to_g[0]

-- PIN_128 -to segments[0]
-- PIN_129 -to segments[1]
-- PIN_132 -to segments[2]
-- PIN_133 -to segments[3]

-- PIN_135 -to segments[4]
-- PIN_136 -to segments[5]
-- PIN_137 -to segments[6]
-- PIN_138 -to segments[7]

-- PIN_87  -to nClr   (K4)
-- PIN_114  -to  RxD
entity main is
   port
	   (
		  a: in std_logic_vector (3 downto 0);
		  b: in std_logic_vector (3 downto 0);
		  clk50M: in std_logic;
		  
		  nClr: in std_logic;
		  RxD : in STD_LOGIC;
		  
		  a_to_g: out std_logic_vector (6 downto 0);
		  segments: out std_logic_vector (7 downto 0);
		  pwmOut: out std_logic
		 );	
end main;


architecture main of main is

--------------------------------------------------------
-------------------- COMPONENT -------------------------
--------------------------------------------------------

component rx_buffer  
  port (
    rdrf : in STD_LOGIC;
    rx_data : in STD_LOGIC_VECTOR (7 downto 0);
	 clr: in std_logic;
	 
    data0 : out STD_LOGIC_VECTOR (7 downto 0);
	 data1 : out STD_LOGIC_VECTOR (7 downto 0)
  ); 
end  component;




component uart_rx 
	port (
		 RxD : in STD_LOGIC;
		 clk25MHz : in STD_LOGIC;  
		 clr : in STD_LOGIC;

		 rdrf: out STD_LOGIC;  
		 FE : out STD_LOGIC;   
		 rx_data : out STD_LOGIC_VECTOR (7 downto 0)
	); 
end component;


component clkdiv is
  port(
        clk50M: in std_logic;
        clr: in std_logic;
        clk25M: out std_logic;
        clk195kHz: out std_logic;
		  clk760Hz: out std_logic;
        clk190Hz: out std_logic;
        clk3Hz:   out std_logic
       );
end component;

component hex7seg is
   port( x: in std_logic_vector(3 downto 0);
         a_to_g: out std_logic_vector(6 downto 0)
        ); 
end component;

component decoder1of8 is
   port( sel: in std_logic_vector(2 downto 0);
         y: out std_logic_vector(7 downto 0)
        ); 
end component;

component mux_quad_8to1 is
   port( sel: in std_logic_vector(2 downto 0);
         in0: in std_logic_vector(3 downto 0);
         in1: in std_logic_vector(3 downto 0);
         in2: in std_logic_vector(3 downto 0);
         in3: in std_logic_vector(3 downto 0);
         in4: in std_logic_vector(3 downto 0);
         in5: in std_logic_vector(3 downto 0);
         in6: in std_logic_vector(3 downto 0);
         in7: in std_logic_vector(3 downto 0);
         y: out std_logic_vector(3 downto 0)
        ); 
end component;

component counterNbit is
   generic (N : integer :=8);
   port( clr: in std_logic;
         clk: in std_logic;
         q: out std_logic_vector(N-1 downto 0)
        ); 
end component;

component fa4 is
   port(
         a_in: in std_logic_vector (3 downto 0);
         b_in: in std_logic_vector (3 downto 0);
         c_in: in std_logic;
         sum_out: out std_logic_vector (3 downto 0);
         c_out: out std_logic
       );
end component;

component servo_pwm 
	port(clk195kHz: in std_logic; 
	     clr: in std_logic;
	     enable: in std_logic;
		  dutyCycle: in std_logic_vector (7 downto 0);
		  pwmOut: out std_logic
		 );
end component;

--------------------------------------------------------
--------------------  SIGNALS --------------------------
--------------------------------------------------------
signal clk7Segm: std_logic;
signal segSelectors: std_logic_vector (7 downto 0);
signal temp4bit: std_logic_vector (3 downto 0);
signal selector: std_logic_vector (2 downto 0);
signal sum: std_logic_vector (3 downto 0);
signal cout:  std_logic;
signal clk195kHz: std_logic; 



signal clk25MHz: std_logic; 
signal rx_data: std_logic_vector (7 downto 0);
signal rdrf: std_logic;
signal rx_buffer0: std_logic_vector (7 downto 0);
signal rx_buffer1: std_logic_vector (7 downto 0);
begin



rxBuffer1: rx_buffer  
  port map(
    rdrf => rdrf,
    rx_data  => rx_data,
	 clr => not nClr,
	 
    data0 => rx_buffer0,
	 data1 => rx_buffer1
  ); 



uartRx: uart_rx 
	port map (
		 RxD => RxD,
		 clk25MHz=> clk25MHz,
		 clr=> not nClr,

		 rdrf=> rdrf,
		 FE=> open,
		 rx_data => rx_data
	); 




adder4bit: fa4
   port map (
         a_in => not a,
         b_in => not b,
         c_in => '0',
         sum_out => sum,
         c_out => cout
       );


clkdiv1: clkdiv 
    port map (
	     clk50M => clk50M,
        clr => '0',
        clk25M => clk25MHz,
        clk195kHz => clk195kHz,
		  clk760Hz =>clk7Segm,
        clk190Hz => open ,
        clk3Hz => open
	 );
	 
quadMux: mux_quad_8to1
	  port map ( sel => selector,
         in0  => sum,
         in1  => "000"&cout,
         in2  => not a,
         in3  => not b,
         in4  => rx_buffer1(3 downto 0),
         in5  => rx_buffer1(7 downto 4),
         in6  => rx_buffer0(3 downto 0),
         in7  => rx_buffer0(7 downto 4),
         y   => temp4bit
        );
	 
hex7seg1: hex7seg
    port map (
	     x => temp4bit ,
        a_to_g => a_to_g
	 );
	 
seg2bitCounter: counterNbit
   generic map (N => 3)
   port map (clr => '0',
         clk => clk7Segm, 
         q  => selector
        ); 	 
	 
	 
segDecoder: decoder1of8
    port map (
			  sel => selector,
				y =>segSelectors
    );	 
	 
	 segments <= not segSelectors;
	 
servoPWM1:servo_pwm	 
	port map(clk195kHz => clk195kHz , 
	     clr => '0',
	     enable => '1',
		  dutyCycle => rx_data, --not (b & a),
		  pwmOut => pwmOut
		 );
	 
	 
	 
end main;