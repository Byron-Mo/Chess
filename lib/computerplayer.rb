class ComputerPlayer
  attr_reader :color, :board

  def initialize(board, color)
    @color = color
    @board = board
  end

  def move
    select_piece
    [@start_pos, @end_pos]
  end

  def select_piece
    pieces = moveable_pieces
    attack_pieces = []
    next_best_pieces = []

    pieces.each do |piece|
      attack_piece = check_if_can_attack(piece)
      if attack_piece != false
        attack_pieces << piece
      end
    end

    if attack_pieces.empty?
      new_pieces = select_best_piece(pieces)

      if new_pieces.empty?
        piece = pieces[rand(pieces.length)]
        @start_pos = piece.pos
        @end_pos = piece.valid_moves[rand(piece.valid_moves.length)]
      else

        new_pieces.each do |piece|
          attack_piece = attack_lesser_enemy(piece)
          if attack_piece != false
            next_best_pieces << piece
          end
        end
        if next_best_pieces.empty?
          piece = new_pieces[rand(new_pieces.length)]
          @start_pos = piece.pos
          @end_pos = piece.safe_moves[rand(piece.safe_moves.length)]
        else
          piece = next_best_pieces[rand(next_best_pieces.length)]
          @start_pos = piece.pos
          @end_pos = attack_lesser_enemy(piece).pos
        end
      end
    else
      piece = attack_pieces[rand(attack_pieces.length)]
      @start_pos = piece.pos
      @end_pos = check_if_can_attack(piece).pos
    end
  end

  # select pieces where potential moves will not lead to capture
  def select_best_piece(pieces)
    best_pieces = []
    pieces.each do |piece|
      best_pieces << piece unless check_if_can_be_beaten?(piece)
    end
    best_pieces
  end

  def check_if_can_be_beaten?(piece)
    enemy_pieces = @board.grid.flatten.select{|piece| !piece.nil? && piece.color != color}

    bad_moves = []
    enemy_pieces.each do |enemy|
      enemy_moves = enemy.valid_attack_moves(piece.valid_moves)
      piece.valid_moves.each do |move|
        if enemy_moves.include?(move)
          bad_moves << move
        end
      end
    end
    own_moves = piece.valid_moves - bad_moves.uniq

    if own_moves.empty?
      return true
    else
      piece.safe_moves = own_moves
      return false
    end
  end

  # attack pieces with higher value
  def check_if_can_attack(piece)
    enemy_pieces = @board.grid.flatten.select{|piece| !piece.nil? && piece.color != color}
    enemy_pieces.each do |enemy|
      piece.valid_moves.each do |move|
        if enemy.pos == move && enemy.point >= piece.point
          return enemy
        end
      end
    end
    false
  end

  # attack pieces with lesser value if safe to do so
  def attack_lesser_enemy(piece)
    enemy_pieces = @board.grid.flatten.select{|piece| !piece.nil? && piece.color != color}
    enemy_pieces.each do |enemy|
      piece.safe_moves.each do |move|
        if enemy.pos == move
          return enemy
        end
      end
    end
    false
  end

  def moveable_pieces
    pieces = all_pieces
    pieces.select{|piece| piece.valid_moves.size > 0}
  end

  def all_pieces
    @board.grid.flatten.select{ |piece| !piece.nil? && piece.color == color }
  end
end
