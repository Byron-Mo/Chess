require_relative "board"
require_relative "player"
require_relative "display"
require_relative "computerplayer"

class Game
  attr_reader :board, :display, :current_player

  def initialize
    @board = Board.new
    @display = Display.new(@board)
    @player1 = Player.new(@display, :white)
    # @player2 = Player.new(@display, :black)
    @player2 = ComputerPlayer.new(@board, :black)
    @current_player = @player1
  end

  def run

    until board.checkmate?(current_player.color)
      begin
        start_pos, end_pos = current_player.move
        # if start_pos
        #   @selected_piece = board[*start_pos]
        # end
        board.move_piece(start_pos, end_pos, current_player.color)

        switch_players!
        notify_players
      rescue StandardError => e
        @display.notifications[:error] = e.message
        retry
      end
    end
    display.display_grid
    puts "CHECKMATE. #{current_player.color.upcase} LOSES."
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
  # game = Game.new
  # p game.board[7, 1].moves
  Game.new.run
end
