### CPE487 Final Project
---
![create project](https://www.fizzcreations.com/wp-content/uploads/2020/01/PAC-MAN-Banner.jpg)

## Coin Collecting Maze - Pac-Man Inspired
---
# Description of expected behavior
  The project is a VGA-based interactive game that uses an FPGA to render a Pac-Man-inspired maze where a pac-man shape ball collects coins and navigates to the maze exit. The game starts with the ball positioned at an initial location, and coins are distributed throughout the maze. The player uses the buttons on the board (btnU, btnD, btnL, btnR) to control the ball's movement as well as btnc to reset the game, while collision detection prevents it from passing through walls. As the ball overlaps with coins, they disappear, and the game tracks the total coins collected while displaying the coin count on the board display. Once all coins are collected, the player must guide the ball to the exit of the maze to reset the game. 

 ### **Attachments needed**

 - VGA connector 
 - Nexys A7-100T board
 - HDMI cable
# Steps to run the code 
Create a new RTL project *ball* in vivado quick start.
![create project](https://raw.githubusercontent.com/Alopez1607/CPE487/refs/heads/main/Picture/Screenshot%20(57).png)
Add sources.
![add sources](https://github.com/Alopez1607/CPE487/blob/main/Picture/Screenshot%20(60).png)
Add constraints. 
![add constrain](https://github.com/Alopez1607/CPE487/blob/main/Picture/Screenshot%20(61).png)
Choose Nexys A7-100T board for the project.
![add board](https://github.com/Alopez1607/CPE487/blob/main/Picture/Screenshot%20(62).png)
Run synthesis.
![add constrain](https://github.com/Alopez1607/CPE487/blob/main/Picture/Screenshot%20(64).png)
Run Implementation.
![add constrain](https://github.com/Alopez1607/CPE487/blob/main/Picture/Screenshot%20(65).png)
Generate bitstream.
![add constrain](https://github.com/Alopez1607/CPE487/blob/main/Picture/Screenshot%20(66).png)
Open 'hardware manager' and click 'Open target' then 'auto connect'. Click 'Program Device' then xc7a100t_0 to download vga_top.bit to the Nexys A7 board.
![add constrain](https://github.com/Alopez1607/CPE487/blob/main/Picture/Screenshot%20(67).png)
![add constrain](https://github.com/Alopez1607/CPE487/blob/main/Picture/Screenshot%20(68).png)

# Description of inputs and outputs added

## Ball.vhd
    Added inputs and outputs to Entity 
        btnu      : IN STD_LOGIC; -- up button
        btnd      : IN STD_LOGIC; -- down button
        btnl      : IN STD_LOGIC; --left button
        btnr      : IN STD_LOGIC; -- right button
        reset     : IN STD_LOGIC; -- New reset button
        coins : Out std_logic_vector (15 downto 0) -- coin count output 
## Vga_top.vhd
    Added inputs and outputs to Entity
        btnu    : IN STD_LOGIC;  -- Button for moving ball up
        btnd  : IN STD_LOGIC;  -- Button for moving ball down
        btnl    : IN STD_LOGIC; -- Button for moving ball to the right 
        btnr  : IN STD_LOGIC; -- Button for moving ball to thr right
        btn0  : IN STD_LOGIC; -- Button for reset
        SEG7_anode : out std_logic_vector (7 downto 0); -- leddec16 anode 
        SEG7_seg : OUT std_logic_vector (6 downto 0) --leddec16 segment 

         COMPONENT ball added inputs and outputs
            btnu    : IN STD_LOGIC;
            btnd  : IN STD_LOGIC;
            btnl    : IN STD_LOGIC;
            btnr  : IN STD_LOGIC;
            reset     : IN STD_LOGIC; -- New reset butto
            coins : Out std_logic_vector (15 downto 0)

             Component leddec16 added input and outputs to vga_top
    
        dig : IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- which digit to currently display
		    data : IN STD_LOGIC_VECTOR (15 DOWNTO 0); -- 16-bit (4-digit) data
		    anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- which anode to turn on
		    seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
	
        Added inputs and outputs PORT MAP for ball
            btnu    => btnu,
            btnd  => btnd,
            btnl => btnl,
            btnr => btnr,
            reset => btn0,
            coins => data
            
       Modified Port Map for ledded16
        dig => led_mpx, data => data,
        anode => SEG7_anode, seg => SEG7_seg
        
         
 ## Vga_top.xdc

    set_property -dict { PACKAGE_PIN B11   IOSTANDARD LVCMOS33 } [get_ports { vga_hsync }]; #IO_L4P_T0_15 Sch=vga_hs
    set_property -dict { PACKAGE_PIN B12   IOSTANDARD LVCMOS33 } [get_ports { vga_vsync }]; #IO_L3N_T0_DQS_AD1N_15 Sch=vga_vs
    set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports { btnu }];    # Adjust pin P3 as per your board
    set_property -dict { PACKAGE_PIN P18 IOSTANDARD LVCMOS33 } [get_ports { btnd }];  # Adjust pin P4 as per your board
    set_property -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports { btnl }];    # Adjust pin P3 as per your board
    set_property -dict { PACKAGE_PIN M17 IOSTANDARD LVCMOS33 } [get_ports { btnr }];  # Adjust pin P4 as per your board
    set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports { btn0 }];  # Adjust pin P4 as per your board

    set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports {SEG7_seg[0]}]
    set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports {SEG7_seg[1]}]
    set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports {SEG7_seg[2]}]
    set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports {SEG7_seg[3]}]
    set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports {SEG7_seg[4]}]
    set_property -dict {PACKAGE_PIN R10 IOSTANDARD LVCMOS33} [get_ports {SEG7_seg[5]}]
    set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {SEG7_seg[6]}]

    set_property -dict {PACKAGE_PIN U13 IOSTANDARD LVCMOS33} [get_ports {SEG7_anode[7]}]
    set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports {SEG7_anode[6]}]
    set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports {SEG7_anode[5]}]
    set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {SEG7_anode[4]}]
    set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports {SEG7_anode[3]}]
    set_property -dict {PACKAGE_PIN T9 IOSTANDARD LVCMOS33} [get_ports {SEG7_anode[2]}]
    set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports {SEG7_anode[1]}]
    set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports {SEG7_anode[0]}]   

# Modifications
We used lab 3 (vgball) as a starter code, we also used lab 6 bat motion to modify ball motion using buttons and incorporated up and down buttons as well as reset. Additionally, we incorporated hits counter from lab 6 for coin collection and added leddec16 to display the coin count. Lastly we added buttons (btn) for ball movement as well as anodes and seg for the display to the constraints file. 

## Future Modifications

- Modify shape of the ball to the Pac-Man iconic shape (circle with triangle cutout)
- Design maze inspired by Pac-Man
- Add wall collisions  
- Draw multiple coins and add them to the maze
- Change colors to match the game
- Reset game after all coins have been collected and the ball reaches the exit of the maze

## Ball.vhd

- In entity ball, the buttons (btnu, btnd, btnl, btnr) were added as well as reset and coins
- In architecture behavioral of ball we added the coin components:
    - Coin_size
    - Coin_count
    - Number_of_coins
    - Coin_positions_x
    - Coin_positions_y
    - Coin_present 
    - Signals Ball_on, maze_on_, coin_on were also added
      
Changed color of Signals maze_on(blue), ball_on(yellow), and coin_on(pink) individually as well as the background by setting all color signals to ‘0’

Added pacman ball draw (bdraw) process:
- Used pixel_col and pixel_row as well as ball_x and ball_y to draw the ball as a circle
Used AND statement to not include triangle cutout for the mouth

Incorporated maze draw (mdraw) process: 
- Used pixel_col and pixel_row and used ‘and’ statements to state the area that the wall would cover

Incorporated coin draw process
- Used array for x and y coordinates of the coin
- Made it easier to draw each coin in a for loop
- For the for loop it uses index 0 to number_of_coins-1 and so it iterates 5 times which is the number of coins and does the circle equation each time using the x and y coordinates and goes through the array, each time it goes through the for loop it goes to the next coordinates in the next index of the array

Added mball process for ball movement
- Added reset functionality
    - when the button btn0 is pressed and when all coins are collected and ball goes past column 750
- Added button movement
- Added collision detection
  - Used IF NOT statement that stated if ball not on maze walls, then update ball position
    
Lastly we mapped coin_count to output signal coin

## Leddec16.vhd
Downloaded leddec16.vhd and added it to the project 

## Vga_top.xdc
- Added buttons: btnu, btnd, btnl, btnr, btn0
- Added segments and anodes as well

## Vga_top.vhd

- Entity: buttons added, SEG7_anode and SEG7_seg for leddec16
- Signals of colors, count, led_mpx, display, and data added

**In component ball, coins and buttons were added**
  - Port map: Buttons added, and coins mapped to data
**Component leddec16 added**
  - Port map: data => data

# Team Contributions
Adriana: draw, leddec16, constraints, motion of the ball, reset

Caroline: draw coins, coin collection, maze, wall_constraint





