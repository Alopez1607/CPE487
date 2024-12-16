LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY vga_top IS
    PORT (
        clk_in    : IN STD_LOGIC;
        btnu    : IN STD_LOGIC;  -- Button for moving ball up
        btnd  : IN STD_LOGIC;  -- Button for moving ball down
        btnl    : IN STD_LOGIC;
        btnr  : IN STD_LOGIC;
        btn0  : IN STD_LOGIC;
        vga_red   : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        vga_green : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        vga_blue  : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        vga_hsync : OUT STD_LOGIC;
        vga_vsync : OUT STD_LOGIC;
        SEG7_anode : out std_logic_vector (7 downto 0);
        SEG7_seg : OUT std_logic_vector (6 downto 0)
    );
END vga_top;

ARCHITECTURE Behavioral OF vga_top IS
    -- Internal signals
    SIGNAL pxl_clk : STD_LOGIC;
    SIGNAL S_red, S_green, S_blue : STD_LOGIC;
    SIGNAL S_vsync : STD_LOGIC;
    SIGNAL S_pixel_row, S_pixel_col : STD_LOGIC_VECTOR(10 DOWNTO 0);
    SIGNAL display : std_logic_vector (15 downto 0);
    Signal led_mpx: std_logic_vector (2 downto 0);
    SIGNAL count : STD_LOGIC_VECTOR (20 DOWNTO 0);
    Signal data: STD_LOGIC_VECTOR (15 Downto 0);
SIGNAL red_signal : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL green_signal : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL blue_signal : STD_LOGIC_VECTOR (3 DOWNTO 0);


    COMPONENT ball IS
        PORT (
            v_sync    : IN STD_LOGIC;
            pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            btnu    : IN STD_LOGIC;
            btnd  : IN STD_LOGIC;
            btnl    : IN STD_LOGIC;
            btnr  : IN STD_LOGIC;
            reset     : IN STD_LOGIC; -- New reset button
            red       : OUT STD_LOGIC;
            green     : OUT STD_LOGIC;
            blue      : OUT STD_LOGIC;
            coins : Out std_logic_vector (15 downto 0)

        );
    END COMPONENT;

    COMPONENT vga_sync IS
        PORT (
            pixel_clk : IN STD_LOGIC;
            red_in    : IN STD_LOGIC;
            green_in  : IN STD_LOGIC;
            blue_in   : IN STD_LOGIC;
            red_out   : OUT STD_LOGIC;
            green_out : OUT STD_LOGIC;
            blue_out  : OUT STD_LOGIC;
            hsync     : OUT STD_LOGIC;
            vsync     : OUT STD_LOGIC;
            pixel_row : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
            pixel_col : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT clk_wiz_0 IS
        PORT (
            clk_in1  : IN STD_LOGIC;
            clk_out1 : OUT STD_LOGIC
        );
    END COMPONENT;
    
    Component leddec16 is 
    PORT ( 
        dig : IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- which digit to currently display
		data : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- 16-bit (4-digit) data
		anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- which anode to turn on
		seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
		);
    end component; 

BEGIN
    -- Color setup
    red_signal <= S_red & "000";
    green_signal <= S_green & "000";
    blue_signal <= S_blue & "000";
    led_mpx <= count(19 DOWNTO 17); -- 7-seg multiplexing clock    

    -- Instantiate the ball component
    add_ball : ball
        PORT MAP(
            v_sync    => S_vsync,
            pixel_row => S_pixel_row,
            pixel_col => S_pixel_col,
            btnu    => btnu,
            btnd  => btnd,
            btnl => btnl,
            btnr => btnr,
            reset => btn0,
            red       => S_red,
            green     => S_green,
            blue      => S_blue,
            coins => data
        );

    -- Instantiate the VGA sync component
    vga_driver : vga_sync
        PORT MAP(
            pixel_clk => pxl_clk,
            red_in    => S_red,
            green_in  => S_green,
            blue_in   => S_blue,
            red_out   => vga_red(2),
            green_out => vga_green(2),
            blue_out  => vga_blue(1),
            pixel_row => S_pixel_row,
            pixel_col => S_pixel_col,
            hsync     => vga_hsync,
            vsync     => S_vsync
        );

    vga_vsync <= S_vsync; -- Connect output vsync

    -- Instantiate clock wizard
    clk_wiz_0_inst : clk_wiz_0
        PORT MAP (
            clk_in1 => clk_in,
            clk_out1 => pxl_clk
        );
        led1: leddec16
        Port Map(
        dig => led_mpx, data => data,
        anode => SEG7_anode, seg => SEG7_seg
        );
END Behavioral;
