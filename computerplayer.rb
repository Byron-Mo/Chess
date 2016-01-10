require 'byebug'

class ComputerPlayer
  attr_reader :color, :display, :board

  def initialize(board, color)
    @color = color
    @board = board
    # @display = display
  end

  def move
    piece = select_piece
    [piece.pos, move_to_location(piece)]
  end

  def select_piece
    pieces = moveable_pieces
    attack_pieces = []
    pieces.each do |piece|
      attack_piece = check_if_can_attack(piece.valid_moves)
      # unless attack_piece
      #   attack_pieces << piece
      #   @end_pos = attack_piece.pos
      # end

      if attack_piece != false
        attack_pieces << piece
      end
    end

    if attack_pieces.empty?
      piece = pieces[rand(pieces.length)]
    else
      piece = attack_pieces[rand(attack_pieces.length)]
    end
    piece
    # return pieces[rand(pieces.length)]
  end

  def check_if_can_attack(valid_moves)
    enemy_pieces = @board.grid.flatten.select{|piece| !piece.nil? && piece.color != color}
    enemy_pieces.each do |piece|
      valid_moves.each do |move|
        if piece.pos == move
          return piece
        end
      end
    end
    false
  end

  def move_to_location(piece)
    # byebug
    # unless check_if_can_attack(piece.valid_moves)
    #   move = check_if_can_attack(piece.valid_moves).pos
    # end

    victim = check_if_can_attack(piece.valid_moves)

    if victim != false
      return victim.pos
    else
      moves_from_selected_piece = piece.valid_moves
      return moves_from_selected_piece[rand(moves_from_selected_piece.length)]
    end

    # if @end_pos.nil?
    #   moves_from_selected_piece = piece.valid_moves
    #   return moves_from_selected_piece[rand(moves_from_selected_piece.length)]
    # else
    #   pos = @end_pos
    #   @end_pos = nil
    #   return pos
    # end
  end

  def moveable_pieces
    pieces = all_pieces
    pieces.select{|piece| piece.valid_moves.size > 0}
  end

  def all_pieces
    @board.grid.flatten.select{ |piece| !piece.nil? && piece.color == color }
  end
end
