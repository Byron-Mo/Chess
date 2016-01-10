require_relative 'piece'
require_relative 'board'
require 'byebug'

class SteppingPiece < Piece

  def moves
    moves = []
    original_piece = @board[*@pos]
    @offsets.each do |offset|
      current_pos = [@pos[0] + offset[0], @pos[1] + offset[1]]
      if in_bounds?(current_pos) && diff_color?(@board[*current_pos], original_piece)
        moves << current_pos
      end
    end
    moves
  end
end

class Knight < SteppingPiece
  def initialize(pos, color = nil, board = nil)
    super
    @value = '♞'
    @offsets = [2, -2, 1, -1].permutation(2).to_a.reject{|x, y| x.abs == y.abs}
  end
end

class King < SteppingPiece
  attr_accessor :has_moved

  def initialize(pos, color = nil, board = nil)
    @has_moved = false
    super
    @value = '♚'
    @offsets = [0, 1, -1].repeated_permutation(2).to_a - [[0, 0]]
  end

  def moves
    new_moves = super
    unless @has_moved
      right_rook = @board[@pos[0], 7]
      left_rook = @board[@pos[0], 0]
      # new_moves = super
      if right_rook.instance_of?(Rook) && right_rook.has_moved == false
        # byebug
        if check_empty_space?([@pos[0], 5], [@pos[0], 6])
          new_moves << [@pos[0], 6]
        end
      end
      if left_rook.instance_of?(Rook) && left_rook.has_moved == false
        if check_empty_space?([@pos[0], 3], [@pos[0], 2], [@pos[0], 1])
          # super << [@pos[0], 2]
          new_moves << [@pos[0], 2]
        end
      end
    end
    new_moves
    # new_moves = super << [7, 6]
    # new_moves
  end

  def check_empty_space?(*positions)
    positions.each do |position|
      return false unless @board[*position].nil?
    end
    true
  end
end

if __FILE__==$PROGRAM_NAME
end
