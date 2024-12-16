LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ball IS
    PORT (
        v_sync    : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        btnu      : IN STD_LOGIC;
        btnd      : IN STD_LOGIC;
        btnl      : IN STD_LOGIC;
        btnr      : IN STD_LOGIC;
        reset     : IN STD_LOGIC; -- New reset button
        red       : OUT STD_LOGIC;
        green     : OUT STD_LOGIC;
        blue      : OUT STD_LOGIC;
        coins : Out std_logic_vector (15 downto 0)
    );
END ball;

ARCHITECTURE Behavioral OF ball IS
    CONSTANT size  : INTEGER := 8; -- Radius of the ball
    CONSTANT coin_size : INTEGER := 6; -- Radius of the coins
    CONSTANT init_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(10, 11); -- Initial X position
    CONSTANT init_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(590, 11); -- Initial Y position
    SIGNAL ball_on, maze_on, coin_on : STD_LOGIC; -- Indicates ball or maze presence
    SIGNAL ball_x  : STD_LOGIC_VECTOR(10 DOWNTO 0) := init_x; -- Ball X position
    SIGNAL ball_y  : STD_LOGIC_VECTOR(10 DOWNTO 0) := init_y; -- Ball Y position
    SIGNAL coin_count : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0'); -- Coin counter
    CONSTANT number_of_coins : INTEGER := 5; -- Number of coins in the maze
    TYPE coin_position_type IS ARRAY (0 TO number_of_coins-1) OF INTEGER range 0 to 1023;
    CONSTANT coin_positions_x : coin_position_type := (500, 500, 200, 200, 675); -- Coin X positions
    CONSTANT coin_positions_y : coin_position_type := (500, 300, 500, 125, 25); -- Coin Y positions
    SIGNAL coin_present : STD_LOGIC_VECTOR(number_of_coins-1 DOWNTO 0) := (others => '1'); -- Coin presence flags

BEGIN
    -- Set the color logic
PROCESS (ball_on, maze_on, coin_on)
BEGIN
    IF ball_on = '1' THEN
        red <= '1';   -- Ball is red
        green <= '1';
        blue <= '0';
    ELSIF coin_on = '1' THEN
        red <= '1';   -- Coins can also be red (or another color)
        green <= '0'; -- Example: Yellow for coins
        blue <= '1';
    ELSIF maze_on = '1' THEN
        red <= '0';
        green <= '0'; -- Maze is green
        blue <= '1';
    ELSE
        red <= '0';   -- Default to black
        green <= '0';
        blue <= '0';
    END IF;
END PROCESS;
  bdraw : PROCESS (ball_x, ball_y, pixel_row, pixel_col)
    VARIABLE vx, vy : INTEGER; -- Distances from the pixel to the center of the ball
    CONSTANT mouth_size : INTEGER := size / 2; -- Size of the Pac-Man mouth
BEGIN
    -- Calculate distances from the pixel to the center of the ball
   
    vx := CONV_INTEGER(pixel_col) - CONV_INTEGER(ball_x);
    vy := CONV_INTEGER(pixel_row) - CONV_INTEGER(ball_y);

    -- Check if the pixel is within the circle
    IF (vx * vx + vy * vy) < (size * size) THEN
        -- Exclude the mouth area using geometric constraints
        -- Mouth is a triangular area on the right side of the circle
        IF NOT ((vx > 0) AND (vy >= -mouth_size) AND (vy <= mouth_size) AND (vx >= ABS(vy))) THEN
            ball_on <= '1'; -- Pixel is part of the Pac-Man
        ELSE
            ball_on <= '0'; -- Pixel is part of the mouth
        END IF;
    ELSE
        ball_on <= '0'; -- Pixel is outside the circle
    END IF;
END PROCESS;


    -- Process to draw the maze
mazedraw : PROCESS (pixel_row, pixel_col)
    BEGIN
        IF (
            (pixel_col >= 135 AND pixel_col <= 185 AND pixel_row >= 50 AND pixel_row <= 100) or
            (pixel_col >= 135 AND pixel_col <= 185 AND pixel_row >= 150 AND pixel_row <= 170) or
            (pixel_col >= 605 AND pixel_col <= 655 AND pixel_row >= 150 AND pixel_row <= 170) or
            (pixel_col >= 235 AND pixel_col <= 335 AND pixel_row >= 50 AND pixel_row <= 100) OR
            (pixel_col >= 385 AND pixel_col <= 405 AND pixel_row >= 0 AND pixel_row <= 100) OR
            (pixel_col >= 455 AND pixel_col <= 555 AND pixel_row >= 50 AND pixel_row <= 100) OR
            (pixel_col >= 605 AND pixel_col <= 655 AND pixel_row >= 50 AND pixel_row <= 100) OR
            (pixel_col >= 705 AND pixel_col <= 715 AND pixel_row >= 0 AND pixel_row <= 220) OR
           
            (pixel_col >= 135 AND pixel_col <= 335 AND pixel_row >= 535 AND pixel_row <= 555) or
            (pixel_col >= 230 AND pixel_col <= 250 AND pixel_row >= 480 AND pixel_row <= 540) or
           
            (pixel_col >= 455 AND pixel_col <= 655 AND pixel_row >= 535 AND pixel_row <= 555) or
            (pixel_col >= 545 AND pixel_col <= 565 AND pixel_row >= 480 AND pixel_row <= 540) or
           
            (pixel_col >= 325 AND pixel_col <= 465 AND pixel_row >= 475 AND pixel_row <= 495) OR
            (pixel_col >= 385 AND pixel_col <= 405 AND pixel_row >= 480 AND pixel_row <= 550) OR
           
            (pixel_col >= 325 AND pixel_col <= 465 AND pixel_row >= 150 AND pixel_row <= 170) OR
            (pixel_col >= 385 AND pixel_col <= 405 AND pixel_row >= 170 AND pixel_row <= 240) OR
           
            (pixel_col >= 325 AND pixel_col <= 465 AND pixel_row >= 375 AND pixel_row <= 395) OR
            (pixel_col >= 385 AND pixel_col <= 405 AND pixel_row >= 380 AND pixel_row <= 450) OR
           
            (pixel_col >= 135 AND pixel_col <= 190 AND pixel_row >= 425 AND pixel_row <= 445) or
            (pixel_col >= 170 AND pixel_col <= 190 AND pixel_row >= 430 AND pixel_row <= 480) or
           
            (pixel_col >= 230 AND pixel_col <= 340 AND pixel_row >= 425 AND pixel_row <= 445) or
           
            (pixel_col >= 600 AND pixel_col <= 655 AND pixel_row >= 425 AND pixel_row <= 445) or
            (pixel_col >= 600 AND pixel_col <= 620 AND pixel_row >= 430 AND pixel_row <= 480) or
           
            (pixel_col >= 455 AND pixel_col <= 555 AND pixel_row >= 425 AND pixel_row <= 445) or
           
            (pixel_col >= 230 AND pixel_col <= 250 AND pixel_row >= 315 AND pixel_row <= 380) or
           
            (pixel_col >= 540 AND pixel_col <= 560 AND pixel_row >= 315 AND pixel_row <= 380) or
           
            (pixel_col >= 235 AND pixel_col <= 335 AND pixel_row >= 215 AND pixel_row <= 235) OR
            (pixel_col >= 230 AND pixel_col <= 250 AND pixel_row >= 150 AND pixel_row <= 285) OR
           
            (pixel_col >= 455 AND pixel_col <= 555 AND pixel_row >= 215 AND pixel_row <= 235) or
            (pixel_col >= 540 AND pixel_col <= 560 AND pixel_row >= 150 AND pixel_row <= 285) or
           
            --tiny lines
            (pixel_col >= 85 AND pixel_col <= 105 AND pixel_row >= 475 AND pixel_row <= 495) or
            (pixel_col >= 685 AND pixel_col <= 705 AND pixel_row >= 475 AND pixel_row <= 495) or
           
            -- Left entrance
            (pixel_col >= 75 AND pixel_col <= 185 AND pixel_row >= 220 AND pixel_row <= 230) OR
            (pixel_col >= 175 AND pixel_col <= 185 AND pixel_row >= 220 AND pixel_row <= 285) OR
            (pixel_col >= 75 AND pixel_col <= 185 AND pixel_row >= 275 AND pixel_row <= 285) OR
           
            (pixel_col >= 75 AND pixel_col <= 185 AND pixel_row >= 315 AND pixel_row <= 325) OR
            (pixel_col >= 175 AND pixel_col <= 185 AND pixel_row >= 315 AND pixel_row <= 380) OR
            (pixel_col >= 75 AND pixel_col <= 185 AND pixel_row >= 370 AND pixel_row <= 380) OR
           
            --Right exit
            (pixel_col >= 605 AND pixel_col <= 715 AND pixel_row >= 220 AND pixel_row <= 230) OR
            (pixel_col >= 605 AND pixel_col <= 615 AND pixel_row >= 220 AND pixel_row <= 285) OR
            (pixel_col >= 605 AND pixel_col <= 715 AND pixel_row >= 275 AND pixel_row <= 285) OR
           
            (pixel_col >= 605 AND pixel_col <= 715 AND pixel_row >= 315 AND pixel_row <= 325) OR
            (pixel_col >= 605 AND pixel_col <= 615 AND pixel_row >= 315 AND pixel_row <= 380) OR
            (pixel_col >= 605 AND pixel_col <= 715 AND pixel_row >= 370 AND pixel_row <= 380) OR
           
            -- Box in middle
            (pixel_col >= 325 AND pixel_col <= 465 AND pixel_row >= 320 AND pixel_row <= 330) OR
           
            (pixel_col >= 325 AND pixel_col <= 385 AND pixel_row >= 260 AND pixel_row <= 270) OR
            (pixel_col >= 405 AND pixel_col <= 465 AND pixel_row >= 260 AND pixel_row <= 270) OR
           
            (pixel_col >= 325 AND pixel_col <= 335 AND pixel_row >= 260 AND pixel_row <= 330) or
            (pixel_col >= 455 AND pixel_col <= 465 AND pixel_row >= 260 AND pixel_row <= 330) or
           
            -- end of box in middle
           
            (pixel_col >= 75 AND pixel_col <= 85 AND pixel_row >= 380 AND pixel_row <= 600) OR
           
            (pixel_col >= 705 AND pixel_col <= 715 AND pixel_row >= 380 AND pixel_row <= 600) OR
           
            (pixel_col >= 75 AND pixel_col <= 85 AND pixel_row >= 0 AND pixel_row <= 220) OR
            (pixel_col >= 75 AND pixel_col <= 715 AND pixel_row >= 590 AND pixel_row <= 600) OR
            (pixel_col >= 75 AND pixel_col <= 715 AND pixel_row >= 0 AND pixel_row <= 10)
           ) THEN
            maze_on <= '1';
        ELSE
            maze_on <= '0';
        END IF;
    END PROCESS;
      -- Process to draw the coins
      -- Process to draw the coins
    coindraw : PROCESS (pixel_row, pixel_col)
        VARIABLE index : INTEGER range 0 to number_of_coins-1;
        VARIABLE dx, dy : INTEGER;
    BEGIN
        coin_on <= '0';
        FOR index IN 0 TO number_of_coins-1 LOOP
            dx := CONV_INTEGER(pixel_col) - coin_positions_x(index);
            dy := CONV_INTEGER(pixel_row) - coin_positions_y(index);
            IF (dx * dx + dy * dy) < (coin_size * coin_size) AND coin_present(index) = '1' THEN
                coin_on <= '1';
            END IF;
        END LOOP;
    END PROCESS;

    -- Process to move the ball with collision handling and reset functionality
-- Process to move the ball with collision handling and reset functionality
mball : PROCESS
    VARIABLE next_x, next_y : STD_LOGIC_VECTOR(10 DOWNTO 0);
    VARIABLE i : INTEGER range 0 to number_of_coins-1;
    VARIABLE dx, dy : INTEGER;
    VARIABLE all_coins_collected : BOOLEAN;
BEGIN
    WAIT UNTIL rising_edge(v_sync);

    -- Handle reset
    IF reset = '1' THEN
        ball_x <= init_x;
        ball_y <= init_y;
        coin_count <= (others => '0');
        coin_present <= (others => '1');
    ELSE
        -- Check if all coins are collected
        all_coins_collected := TRUE;
        FOR i IN 0 TO number_of_coins-1 LOOP
            IF coin_present(i) = '1' THEN
                all_coins_collected := FALSE;
            END IF;
        END LOOP;

        -- Check if the ball goes past pixel row 800 after collecting all coins
        IF all_coins_collected AND CONV_INTEGER(ball_x) >= 750 THEN
            -- Reset game
            ball_x <= init_x;
            ball_y <= init_y;
            coin_count <= (others => '0');
            coin_present <= (others => '1');
        ELSE
            -- Default next position to current position
            next_x := ball_x;
            next_y := ball_y;

            -- Calculate next position based on button inputs
            IF btnu = '1' THEN
                next_y := ball_y - CONV_STD_LOGIC_VECTOR(2, 11); -- Move up
            ELSIF btnd = '1' THEN
                next_y := ball_y + CONV_STD_LOGIC_VECTOR(2, 11); -- Move down
            END IF;

            IF btnl = '1' THEN
                next_x := ball_x - CONV_STD_LOGIC_VECTOR(2, 11); -- Move left
            ELSIF btnr = '1' THEN
                next_x := ball_x + CONV_STD_LOGIC_VECTOR(2, 11); -- Move right
            END IF;

            -- Coin collection logic
            FOR i IN 0 TO number_of_coins-1 LOOP
                dx := CONV_INTEGER(next_x) - coin_positions_x(i);
                dy := CONV_INTEGER(next_y) - coin_positions_y(i);
                IF (dx * dx + dy * dy) < (coin_size * coin_size) AND coin_present(i) = '1' THEN
                    coin_count <= coin_count + 1;
                    coin_present(i) <= '0'; -- Mark the coin as collected
                END IF;
            END LOOP;

            -- Check for collisions with maze walls

IF NOT (
                (next_x + size >= 135 AND next_x - size <= 185 AND next_y + size >= 50 AND next_y - size <= 100) OR
                (next_x + size >= 135 AND next_x - size <= 185 AND next_y + size >= 150 AND next_y - size <= 170) OR
                (next_x + size >= 605 AND next_x - size <= 655 AND next_y + size >= 150 AND next_y - size <= 170) OR
                (next_x + size >= 235 AND next_x - size <= 335 AND next_y + size >= 50 AND next_y - size <= 100) OR
                (next_x + size >= 385 AND next_x - size <= 405 AND next_y + size >= 0 AND next_y - size <= 100) OR
                (next_x + size >= 455 AND next_x - size <= 555 AND next_y + size >= 50 AND next_y - size <= 100) OR
                (next_x + size >= 605 AND next_x - size <= 655 AND next_y + size >= 50 AND next_y - size <= 100) OR
           
                (next_x + size >= 705 AND next_x - size <= 715 AND next_y + size >= 0 AND next_y - size <= 220) OR
           
                (next_x + size >= 135 AND next_x - size <= 335 AND next_y + size >= 535 AND next_y - size <= 555) OR
                (next_x + size >= 230 AND next_x - size <= 250 AND next_y + size >= 480 AND next_y - size <= 540) OR
           
                (next_x + size >= 455 AND next_x - size <= 655 AND next_y + size >= 535 AND next_y - size <= 555) OR
                (next_x + size >= 545 AND next_x - size <= 565 AND next_y + size >= 480 AND next_y - size <= 540) OR
           
                (next_x + size >= 325 AND next_x - size <= 465 AND next_y + size >= 475 AND next_y - size <= 495) OR
                (next_x + size >= 385 AND next_x - size <= 405 AND next_y + size >= 480 AND next_y - size <= 550) OR
           
                (next_x + size >= 325 AND next_x - size <= 465 AND next_y + size >= 150 AND next_y - size <= 170) OR
                (next_x + size >= 385 AND next_x - size <= 405 AND next_y + size >= 170 AND next_y - size <= 240) OR
           
                (next_x + size >= 325 AND next_x - size <= 465 AND next_y + size >= 375 AND next_y - size <= 395) OR
                (next_x + size >= 385 AND next_x - size <= 405 AND next_y + size >= 380 AND next_y - size <= 450) OR
           
                (next_x + size >= 135 AND next_x - size <= 190 AND next_y + size >= 425 AND next_y - size <= 445) OR
                (next_x + size >= 170 AND next_x - size <= 190 AND next_y + size >= 430 AND next_y - size <= 480) OR
           
                (next_x + size >= 230 AND next_x - size <= 340 AND next_y + size >= 425 AND next_y - size <= 445) OR
           
                (next_x + size >= 600 AND next_x - size <= 655 AND next_y + size >= 425 AND next_y - size <= 445) OR
                (next_x + size >= 600 AND next_x - size <= 620 AND next_y + size >= 430 AND next_y - size <= 480) OR
           
                (next_x + size >= 455 AND next_x - size <= 555 AND next_y + size >= 425 AND next_y - size <= 445) OR
           
                (next_x + size >= 230 AND next_x - size <= 250 AND next_y + size >= 315 AND next_y - size <= 380) OR
           
                (next_x + size >= 540 AND next_x - size <= 560 AND next_y + size >= 315 AND next_y - size <= 380) OR
           
                (next_x + size >= 235 AND next_x - size <= 335 AND next_y + size >= 215 AND next_y - size <= 235) OR
                (next_x + size >= 230 AND next_x - size <= 250 AND next_y + size >= 150 AND next_y - size <= 285) OR
           
                (next_x + size >= 455 AND next_x - size <= 555 AND next_y + size >= 215 AND next_y - size <= 235) OR
                (next_x + size >= 540 AND next_x - size <= 560 AND next_y + size >= 150 AND next_y - size <= 285) OR
           
                --tiny lines
                (next_x + size >= 85 AND next_x - size <= 105 AND next_y + size >= 475 AND next_y - size <= 495) OR
                (next_x + size >= 685 AND next_x - size <= 705 AND next_y + size >= 475 AND next_y - size <= 495) OR
           
                -- Left entrance
                (next_x + size >= 75 AND next_x - size <= 185 AND next_y + size >= 220 AND next_y - size <= 230) OR
                (next_x + size >= 175 AND next_x - size <= 185 AND next_y + size >= 220 AND next_y - size <= 285) OR
                (next_x + size >= 75 AND next_x - size <= 185 AND next_y + size >= 275 AND next_y - size <= 285) OR
           
                (next_x + size >= 75 AND next_x - size <= 185 AND next_y + size >= 315 AND next_y - size <= 325) OR
                (next_x + size >= 175 AND next_x - size <= 185 AND next_y + size >= 315 AND next_y - size <= 380) OR
                (next_x + size >= 75 AND next_x - size <= 185 AND next_y + size >= 370 AND next_y - size <= 380) OR
           
                --Right exit
                (next_x + size >= 605 AND next_x - size <= 715 AND next_y + size >= 220 AND next_y - size <= 230) OR
                (next_x + size >= 605 AND next_x - size <= 615 AND next_y + size >= 220 AND next_y - size <= 285) OR
                (next_x + size >= 605 AND next_x - size <= 715 AND next_y + size >= 275 AND next_y - size <= 285) OR
           
                (next_x + size >= 605 AND next_x - size <= 715 AND next_y + size >= 315 AND next_y - size <= 325) OR
                (next_x + size >= 605 AND next_x - size <= 615 AND next_y + size >= 315 AND next_y - size <= 380) OR
                (next_x + size >= 605 AND next_x - size <= 715 AND next_y + size >= 370 AND next_y - size <= 380) OR
           
                -- Box in middle
                (next_x + size >= 325 AND next_x - size <= 465 AND next_y + size >= 320 AND next_y - size <= 330) OR
           
                (next_x + size >= 325 AND next_x - size <= 385 AND next_y + size >= 260 AND next_y - size <= 270) OR
                (next_x + size >= 405 AND next_x - size <= 465 AND next_y + size >= 260 AND next_y - size <= 270) OR
           
                (next_x + size >= 325 AND next_x - size <= 335 AND next_y + size >= 260 AND next_y - size <= 330) OR
                (next_x + size >= 455 AND next_x - size <= 465 AND next_y + size >= 260 AND next_y - size <= 330) OR
           
                -- end of box in middle
           
                (next_x + size >= 75 AND next_x - size <= 85 AND next_y + size >= 380 AND next_y - size <= 600) OR
           
                (next_x + size >= 705 AND next_x - size <= 715 AND next_y + size >= 380 AND next_y - size <= 600) OR
           
                (next_x + size >= 75 AND next_x - size <= 85 AND next_y + size >= 0 AND next_y - size <= 220) OR
                (next_x + size >= 75 AND next_x - size <= 715 AND next_y + size >= 590 AND next_y - size <= 600) OR
                (next_x + size >= 75 AND next_x - size <= 715 AND next_y + size >= 0 AND next_y - size <= 10)
            ) then      
                -- Update ball position only if no collision
                ball_x <= next_x;
                ball_y <= next_y;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    coins <= coin_count;
    
end behavioral;