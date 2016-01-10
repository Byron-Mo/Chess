require_relative 'piece'

class SlidingPiece < Piece
  def initialize(pos, color = nil, board = nil)
    super
    @offsets = [0, 1, -1].repeated_permutation(2).to_a - [[0, 0]]
  end

  def moves
    moves = []
    original_piece = @board[*@pos]
    @offsets.each do |offset|
      current_pos = [@pos[0] + offset[0], @pos[1] + offset[1]]
      while in_bounds?(current_pos)
        current_piece = @board[*current_pos]
        if current_piece.nil?
          moves << current_pos
        elsif diff_color?(current_piece, original_piece)
          moves << current_pos
          break
        elsif same_color?(current_piece, original_piece)
          break
        end
        current_pos = [current_pos[0]+offset[0], current_pos[1]+offset[1]]
      end
    end
    moves
  end

  def attackable?(move)
    @offsets.each do |offset|
      current_pos = [@pos[0] + offset[0], @pos[1] + offset[1]]
      while in_bounds?(current_pos)
        if current_pos == move
          return true
        end
        current_pos = [current_pos[0]+offset[0], current_pos[1]+offset[1]]
      end
    end
    false
  end
end
