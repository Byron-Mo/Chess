require_relative 'sliding_piece'

class Queen < SlidingPiece
  attr_reader :point

  def initialize(pos, color = nil, board = nil)
    super
    @point = 9
    @value = '♛'
  end
end
