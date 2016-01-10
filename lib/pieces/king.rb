require_relative 'stepping_piece'

class King < SteppingPiece
  attr_accessor :has_moved
  attr_reader :point

  def initialize(pos, color = nil, board = nil)
    @has_moved = false
    super
    @point = 10
    @value = '♚'
    @offsets = [0, 1, -1].repeated_permutation(2).to_a - [[0, 0]]
  end

  def moves
    new_moves = super
    unless @has_moved
      right_rook = @board[@pos[0], 7]
      left_rook = @board[@pos[0], 0]
      if right_rook.instance_of?(Rook) && right_rook.has_moved == false
        if check_empty_space?([@pos[0], 5], [@pos[0], 6])
          new_moves << [@pos[0], 6]
        end
      end
      if left_rook.instance_of?(Rook) && left_rook.has_moved == false
        if check_empty_space?([@pos[0], 3], [@pos[0], 2], [@pos[0], 1])
          new_moves << [@pos[0], 2]
        end
      end
    end
    new_moves
  end

  def check_empty_space?(*positions)
    positions.each do |position|
      return false unless @board[*position].nil?
    end
    true
  end
end
