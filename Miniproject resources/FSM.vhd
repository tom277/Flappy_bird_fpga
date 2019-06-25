--fsm.vhdl
--A Mealy machine responsible for the control of the UART capture process
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity fsm is
port
  (
   clk         : in std_logic;
   reset       : in std_logic;
	start_game : in std_logic;
	start_training : in std_logic;
	pause : in std_logic;
	collision : in std_logic;
	game_over : in std_logic;
	passsed_tube : in std_logic;
	score : in std_logic_vector(9 downto 0);
	mouse_in : in std_logic;
	enable_game : out std_logic;
	enable_menu : out std_logic;
	train_mode_enabled: out std_logic;
	level : out std_logic_vector(1 downto 0);
	reset_game : out std_logic;
	pausetxt_enable : out std_logic;
	collision_counter_enable : out std_logic;
	score_counter_enable : out std_logic;
	debug_machine : out std_logic_vector(4 downto 0)
  );
end entity;

architecture rtl of fsm is
  --Build an enumerated type for the state machine
  type state_type is (s_menu, s_train, s_game);
  
  --Register (and signal) to hold the current (and next) state
  signal state, next_state: state_type := s_menu;
 -- signal game_over : std_logic := '0';
  signal menu_d, train_d, game_d, score_d, pause_d : std_logic := '0';
begin
  state_reg: process (clk, reset)
  begin
   if reset = '1' then
    --reset logic
   
    state <= s_menu;
    
   elsif (rising_edge(clk)) then --next state register:
    state <= next_state;
   end if;
  end process;
 --Determine the next state based only on the current state
 --and the input (do not wait for a clock edge).
  
  
  next_state_fn: process(start_game, start_training, pause, game_over, state)
  begin
	 
    case state is 
     when s_menu =>
      if start_game = '1' then
			next_state <= s_game;
      elsif start_training = '1' then
			next_state <= s_train;
		else
			next_state <= s_menu;
      end if;
	 
     when s_train => 
		 if game_over = '1' then 
			next_state <= s_menu;
       else
        next_state <= s_train;
       end if;
    
     when s_game =>
		if game_over = '1' then 
			next_state <= s_menu;
       else
        next_state <= s_game;
       end if;
    end case;
  end process;
  
  
--Determine the output based only on the current state
--and the input (do not wait for a clock edge).s_menu, s_train, s_game, s_score, s_pause
  output_fn: process (collision, state, passsed_tube, score) --output logic
  begin
    --default output values
   enable_game <= '0';
	enable_menu <= '0';
	train_mode_enabled <= '0';
	level <= "00";
	reset_game <= '0';
	collision_counter_enable <= '0';
	score_counter_enable <= '0';
	
	--debugging
	menu_d <= '0'; 
	train_d <= '0'; 
	game_d  <= '0';
	score_d  <= '0';
	pause_d <= '0';
    
	 case state is
      when s_menu =>
        enable_menu <= '1';
		  reset_game <= '1';
		  menu_d <= '1';
		  
      when s_train =>
         train_mode_enabled<= '1';
			enable_game<= '1';
			train_d <= '1';
			if collision = '1' then
          collision_counter_enable <= '1';
         end if;
			if passsed_tube = '1' then 
				score_counter_enable <= '1';
			end if;
        
      when s_game =>
         enable_game<= '1';
			if collision = '1' then
          collision_counter_enable <= '1';
         end if;
			if passsed_tube = '1' then 
				score_counter_enable <= '1';
			end if;
			if score > "0000001100" then
				level <= "11";
			elsif score > "0000000111" then
				level <= "10";
			elsif score > "0000000100" then
				level <= "01";
			else
				level <= "00";
			end if;
			game_d  <= '1';

     end case;
  end process;
  
  debug_machine <= menu_d & train_d & game_d & score_d & pause_d;
  --debug_machine <= menu_d;
end rtl;