require_relative "lib/board"
require_relative "lib/player"
require_relative "lib/display"
require_relative "lib/computerplayer"

class Game
  attr_reader :board, :display, :current_player

  def initialize(user_input)
    @board = Board.new
    @display = Display.new(@board)
    @player1 = Player.new(@display, :white)
    @current_player = @player1
    if user_input == 1
      @player2 = ComputerPlayer.new(@board, :black)
    else
      @player2 = Player.new(@display, :black)
    end
  end

  def run
    until board.checkmate?(current_player.color) || board.stalemate?(current_player.color)
      begin
        start_pos, end_pos = current_player.move
        board.move_piece(start_pos, end_pos, current_player.color)

        switch_players!
        notify_players
      rescue StandardError => e
        @display.notifications[:error] = e.message
        retry
      end
    end
    display.display_grid

    if board.checkmate?(current_player.color)
      puts "CHECKMATE. #{current_player.color.upcase} LOSES."
    elsif board.stalemate?(current_player.color)
      puts "It's a stalemate!"
    end
  end

  def notify_players
    if board.in_check?(current_player.color)
      display.set_check!
    else
      display.uncheck!
    end
  end

  def switch_players!
    @current_player = (current_player == @player1) ? @player2 : @player1
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Welcome to Chess! How would you like to play?"
  puts "1. Against AI"
  puts "2. Two players"
  puts "Please enter your selection."
  user_input = $stdin.gets.chomp.to_i
  game = Game.new(user_input)
  game.run
end
