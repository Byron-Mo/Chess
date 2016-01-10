require_relative 'sliding_piece'

class Bishop < SlidingPiece
  attr_reader :point

  def initialize(pos, color = nil, board = nil)
    super
    @point = 3
    @value = '♝'
    @offsets = @offsets.select{|x, y| x.abs == y.abs}
  end
end
