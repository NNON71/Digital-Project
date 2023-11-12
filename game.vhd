library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.TETRIS_PACKAGE.ALL;

entity game is
    port(
        clock : in STD_LOGIC;
        --clear : in STD_LOGIC;
        --
        hsync : out STD_LOGIC;
        vsync : out STD_LOGIC;
        red : out STD_LOGIC;
        green : out STD_LOGIC;
        blue : out STD_LOGIC ;
        --
		  start_in : in std_logic;
		  left_in : in std_logic;
		  right_in : in std_logic;
		  up_in	: in std_Logic;
		  down_in : in std_logic
    );
end entity;

architecture BEHV of  game is

    component CLOCK_GENERATOR is
        port(
            clock : in STD_LOGIC;
            clear : in STD_LOGIC;
            --
            clock_out : out STD_LOGIC;
            clock_ten : out STD_LOGIC
        );
    end component;
    
    component VGA_CONTROLLER is
        port(
            clock : in STD_LOGIC;
            clear : in STD_LOGIC;
            --
            hsync : out STD_LOGIC;
            vsync : out STD_LOGIC;
            x_coor : out STD_LOGIC_VECTOR (9 downto 0);
            y_coor : out STD_LOGIC_VECTOR (9 downto 0);
            vidon : out STD_LOGIC
        );
    end component;
    
    component IMAGE_SOURCE is
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
    end component;
    
    component TETRIS_DATA is
        port(
            clock : in STD_LOGIC;
            clear : in STD_LOGIC;
            --
            fall : in STD_LOGIC;
            move_left : in STD_LOGIC;
            move_right : in STD_LOGIC;
            rotate : in STD_LOGIC;
            --
            can_fall : out STD_LOGIC;
            can_move_left : out STD_LOGIC;
            can_move_right : out STD_LOGIC;
            can_rotate : out STD_LOGIC;
            --
            merge : in STD_LOGIC;
            create_new : in STD_LOGIC;
            line_complete : out STD_LOGIC;
            game_over : out STD_LOGIC;
            --
            board : out BOARD_TYPE;
            next_tetrimino : out TETRIMINO_TYPE;
            next_null : out STD_LOGIC;
            random_tetrimino : in TETRIMINO_TYPE
        );
    end component;
    
    component TETRIS_CONTROLLER is
        port(
            clock : in STD_LOGIC;
            clock_ten : in STD_LOGIC;
            clear : in STD_LOGIC;
            --
            key_enter : in STD_LOGIC;
            key_left : in STD_LOGIC;
            key_right : in STD_LOGIC;
            key_up : in STD_LOGIC;
            key_down : in STD_LOGIC;
            --
            fall : out STD_LOGIC;
            move_left : out STD_LOGIC;
            move_right : out STD_LOGIC;
            rotate : out STD_LOGIC;
            --
            can_fall : in STD_LOGIC;
            can_move_left : in STD_LOGIC;
            can_move_right : in STD_LOGIC;
            can_rotate : in STD_LOGIC;
            --
            merge : out STD_LOGIC;
            create_new : out STD_LOGIC;
            line_complete : in STD_LOGIC;
            game_over : in STD_LOGIC;
            --
            score : out INTEGER range 0 to 1000 
        );
    end component;
    
    component RAND_NUM_GEN is
        port(
            clock : in STD_LOGIC;
            clear : in STD_LOGIC;
            --
            start : in STD_LOGIC;
            tetrimino : out TETRIMINO_TYPE
        );        
    end component;
        

    signal clock_out : STD_LOGIC;
    signal clock_ten : STD_LOGIC;
    
    signal wire : STD_LOGIC_VECTOR (12 downto 0);
    
    signal wire_board : BOARD_TYPE;
    signal wire_next : TETRIMINO_TYPE;
    signal wire_next_null : STD_LOGIC;
    signal wire_tetrimino : TETRIMINO_TYPE;
    
    signal wire_score : INTEGER range 0 to 1000;
    
    signal x_coor : STD_LOGIC_VECTOR (9 downto 0);
    signal y_coor : STD_LOGIC_VECTOR (9 downto 0);
    signal vidon : STD_LOGIC;

    signal game_over : STD_LOGIC;
    signal game_reset : STD_LOGIC;
	 
    
begin
    
    game_reset <= start_in and game_over;

    U1 : CLOCK_GENERATOR port map(
        clock => clock,
        clear => '0',
        --
        clock_out => clock_out,
        clock_ten => clock_ten
    );
    
    U2 : VGA_CONTROLLER port map(
        clock => clock_out,
        clear => '0',
        --
        hsync => hsync,
        vsync => vsync,
        x_coor => x_coor,
        y_coor => y_coor,
        vidon => vidon
    );
    
    U3 : IMAGE_SOURCE port map(
        board => wire_board,
        next_tetrimino => wire_next,
        next_null => wire_next_null,
        --
        score => wire_score,
        --
        x_coor => x_coor,
        y_coor => y_coor,
        vidon => vidon,
        --
        red => red,
        green => green,
        blue => blue
    );
        
    U4 : TETRIS_DATA port map(
        clock => clock_out,
        clear => game_reset,
        --
        fall => wire(0),
        move_left => wire(1),
        move_right => wire(2),
        rotate => wire(3),
        --
        can_fall => wire(4),
        can_move_left => wire(5),
        can_move_right => wire(6),
        can_rotate => wire(7),
        --
        merge => wire(8),
        create_new => wire(9),
        line_complete => wire(10),
        game_over => game_over,
        --
        board => wire_board,
        next_tetrimino => wire_next,
        next_null => wire_next_null,
        random_tetrimino => wire_tetrimino
    );
    
    U5 : TETRIS_CONTROLLER port map(
        clock => clock_out,
        clock_ten => clock_ten,
        clear => game_reset,
        --
        key_enter => start_in,
        key_left => left_in,
        key_right => right_in,
        key_up => up_in,
        key_down => down_in,
        --
        fall => wire(0),
        move_left => wire(1),
        move_right => wire(2),
        rotate => wire(3),
        --
        can_fall => wire(4),
        can_move_left => wire(5),
        can_move_right => wire(6),
        can_rotate => wire(7),
        --
        merge => wire(8),
        create_new => wire(9),
        line_complete => wire(10),
        game_over => game_over,
        --
        score => wire_score
    );
    
    U6 : RAND_NUM_GEN port map(
        clock => clock_out,
        clear => '0',
        --
        start => start_in,
        tetrimino => wire_tetrimino
    );
    
end architecture;