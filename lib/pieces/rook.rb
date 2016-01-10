require_relative 'sliding_piece'

class Rook < SlidingPiece
  attr_reader :offsets, :point
  attr_accessor :has_moved

  def initialize(pos, color = nil, board = nil)
    @has_moved = false
    super
    @value = '♜'
    @point = 5
    @offsets = @offsets.reject{|x, y| x.abs == y.abs}
  end
end
