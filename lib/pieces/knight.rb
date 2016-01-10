require_relative 'stepping_piece'

class Knight < SteppingPiece
  attr_reader :point

  def initialize(pos, color = nil, board = nil)
    super
    @point = 3
    @value = '♞'
    @offsets = [2, -2, 1, -1].permutation(2).to_a.reject{|x, y| x.abs == y.abs}
  end
end
