require 'colorize'
# require_relative 'board'
require_relative "cursorable"

class Display
  include Cursorable
  attr_accessor :notifications

  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
    @notifications = {}
  end

  def display_grid

    system("clear")
    puts "Arrow keys or WASD to move, space or enter to confirm."
    grid = @board.grid
    grid.each.with_index do |row, i|
      row.each.with_index do |col, j|
        tile = grid[i][j]
        print " #{tile.to_s.colorize(tile.color)} ".colorize(colors_for(i, j))
      end
      puts
    end
    @notifications.each do |key, val|
      puts "#{val}"
    end
  end

  def set_check!
    @notifications[:check] = "Check!"
  end

  def uncheck!
    @notifications.delete(:check)
  end

  def reset!
    @notifications.delete(:error)
  end

  def message
    puts @board.error_message
    @board.error_message = nil
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :light_red
    elsif (i + j).even?
      bg = :light_blue
    else
      bg = :light_yellow
    end
    { background: bg}
  end
end

if __FILE__==$PROGRAM_NAME
  b = Board.new
  d = Display.new(b)
  d.display_loop

end
