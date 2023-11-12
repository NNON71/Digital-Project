library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use WORK.TETRIS_PACKAGE.ALL;
use WORK.IMAGE_PACKAGE.ALL;

entity IMAGE_SOURCE is
    port(
        board : in BOARD_TYPE;
        next_tetrimino : in TETRIMINO_TYPE;
        next_null : in STD_LOGIC;
        --
        score : in INTEGER range 0 to 1000 ;
        --
        x_coor : in STD_LOGIC_VECTOR (9 downto 0);
        y_coor : in STD_LOGIC_VECTOR (9 downto 0);
        vidon : in STD_LOGIC;
        --
        red : out STD_LOGIC;
        green : out STD_LOGIC;
        blue : out STD_LOGIC
    );
end entity;

architecture BEHV of IMAGE_SOURCE is

    constant BOARD_POS_X : INTEGER := 180;
    constant BOARD_POS_Y : INTEGER := 80;
    
    constant SCORE_POS_X : INTEGER := 360;
    constant SCORE_POS_Y : INTEGER := 160;
    
begin

    process (x_coor, y_coor, vidon, board, next_tetrimino, next_null,  score)
    
        variable tile_x : INTEGER := 0;
        variable tile_y : INTEGER := 0;
        
        variable x_coor_centered : STD_LOGIC_VECTOR (9 downto 0);
        variable y_coor_centered : STD_LOGIC_VECTOR (9 downto 0);
    
        variable color : BOOLEAN := FALSE;
        variable color_shape : SHAPE_TYPE := SHAPE_SQUARE;
        
        variable digit : INTEGER := 0;
        variable power10 : INTEGER := 0;
        
    begin
        red <= '0'; green <= '0'; blue <= '0';
        if vidon = '1' then
        
            -- BACKGROUND COLOR
            red <= '0'; green <= '0'; blue <= '0';
            color := FALSE;
            color_shape := SHAPE_SQUARE;
            
            -- PIXEL COORDINATES => TILE COORDINATES
            x_coor_centered := x_coor - BOARD_POS_X;
            y_coor_centered := y_coor - BOARD_POS_Y;
            
            tile_x := conv_integer(x_coor_centered(9 downto 4));
            tile_y := conv_integer(y_coor_centered(9 downto 4));
            
            -- BOARD
            if (0 <= tile_x) and (tile_x < BOARD_WIDTH) and 
               (0 <= tile_y) and (tile_y < BOARD_HEIGHT) then
                
                red <= '1'; green <= '1'; blue <= '1';
                
                if board(tile_x, tile_y).state = '1' then
                    color := TRUE;
                    color_shape := board(tile_x, tile_y).shape;
                end if;
            
            -- NEXT TETRIMINO
            elsif (BOARD_WIDTH + 1 <= tile_x) and (tile_x < BOARD_WIDTH + 7) and 
                  (0 <= tile_y) and (tile_y < 4) then
            
                red <= '1'; green <= '1'; blue <= '1';
                
                if next_null = '0' then
                    for i in 0 to 3 loop
                        if (next_tetrimino.tiles(i).x + BOARD_WIDTH + 2 = tile_x) and
                           (next_tetrimino.tiles(i).y + 1 = tile_y) then
                            
                            color := TRUE;
                            color_shape := next_tetrimino.shape;
                           
                        end if;
                    end loop;
                end if;
				end if;
            
            -- SHAPE => COLOR
            if color then
                if color_shape = SHAPE_T then
                    red <= '1'; green <= '0'; blue <= '0';
                elsif color_shape = SHAPE_SQUARE then
					     red <= '1'; green <= '1'; blue <= '0';
                    red <= '0'; green <= '1'; blue <= '0';
                elsif color_shape = SHAPE_LINE then
                    red <= '0'; green <= '0'; blue <= '1';
                elsif color_shape = SHAPE_L_LEFT then
                    red <= '1'; green <= '0'; blue <= '1';
                elsif color_shape = SHAPE_L_RIGHT then
                    red <= '1'; green <= '0'; blue <= '1';
						  red <= '1'; green <= '0'; blue <= '0';
                elsif color_shape = SHAPE_Z_LEFT then
                    red <= '0'; green <= '1'; blue <= '1';
                else --SHAPE_Z_RIGHT
                    red <= '0'; green <= '1'; blue <= '1';
						  red <= '0'; green <= '0'; blue <= '1';
                end if;
            end if;
            
            -- PIXEL_COORDINATES => NUMBER_COORDINATES
            x_coor_centered := x_coor - SCORE_POS_X;
            y_coor_centered := y_coor - SCORE_POS_Y;
            
            tile_x := conv_integer(x_coor_centered(9 downto 1));
            tile_y := conv_integer(y_coor_centered(9 downto 1));
            
            -- SCORE
            power10 := 10000;
            for i in 0 to 4 loop
                if (5 * i <= tile_x) and (tile_x < 5 * i + 4) and (0 <= tile_y) and (tile_y < 7) then
                    
                    if DIGIT_ARRAY(digit_of_integer(score, 5 - i))(tile_y, tile_x - 5 * i) then
                        red <= '1'; green <= '1'; blue <= '1';
                    end if;
                      
                end if;
				end loop;
            
        end if;
    end process;
end architecture;