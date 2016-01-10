require_relative 'piece'
require_relative '../board'

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

  def attackable?(move)
    @offsets.each do |offset|
      current_pos = [@pos[0] + offset[0], @pos[1] + offset[1]]
      if in_bounds?(current_pos) && current_pos == move
        return true
      end
    end
    false
  end
end
