require_relative 'pieces'

class Board
  attr_accessor :grid, :error_message

  def initialize(populate = true)
    @grid = Array.new(8) { Array.new(8) }
    populate_board if populate
  end

  def in_check?(color)
    flattened_grid = @grid.flatten.reject{|x| x.nil?}
    king_piece = flattened_grid.select{|piece| piece.color == color && piece.value == '♚'}[0]
    flattened_grid.each do |piece|
      if king_piece != piece
        if piece.moves.include?(king_piece.pos)
          king_piece.has_moved = true
          return true
        end
      end
    end
    false
  end

  def checkmate?(color)
    if in_check?(color)
      return true if grid.flatten.select{|piece| piece.color == color}
      .all?{|piece| piece.valid_moves.empty?}
    end
    false
  end

  def stalemate?(color)
    unless checkmate?(color)
      return true if grid.flatten.select{|piece| piece.color == color}
      .all?{|piece| piece.valid_moves.empty?}
    end
    false
  end

  def move_piece(start_pos, end_pos, player_color)
    piece = self[*start_pos]
    if piece.nil?
      raise "Cannot move an empty position"
    elsif self[*end_pos].color == piece.color
      raise "Cannot take your own piece"
    elsif piece.color != player_color
      raise "Cannot move your opponent's pieces"
    elsif !piece.moves.include?(end_pos)
      raise "Invalid move"
    elsif !piece.valid_moves.include?(end_pos)
      raise "You cannot move into check"
    end

    if piece.instance_of?(Pawn)
      if (end_pos[0] - start_pos[0]).abs == 2
        piece.double_step = true
      end
    end

    if piece.instance_of?(King) || piece.instance_of?(Rook)
      piece.has_moved = true
    end

    if piece.instance_of?(Pawn) && check_if_diagonal_and_piece(start_pos, end_pos)
      # en passant
      self[start_pos[0], end_pos[1]] = nil
    end

    if piece.instance_of?(King) && (start_pos[1] - end_pos[1]).abs == 2
      # castling
      if end_pos[1] == 6
        move_rook_during_castle([start_pos[0], 7], [start_pos[0], end_pos[1] - 1])
      else
        move_rook_during_castle([start_pos[0], 0], [start_pos[0], end_pos[1] + 1])
      end
    end

    if piece.instance_of?(Pawn) && end_pos[0] == piece.ending_row
      # promote to queen
      self[*end_pos] = Queen.new(end_pos, piece.color, self)
    else
      self[*end_pos] = piece
      piece.pos = end_pos
    end
    self[*start_pos] = nil

    update_pawn_adjacents
  end

  def move_piece!(start_pos, end_pos, player_color)
    piece = self[*start_pos]
    # raise "Piece cannot move like that" unless piece.moves.include?(end_pos)

        if piece.instance_of?(Pawn)
          if (end_pos[0] - start_pos[0]).abs == 2
            piece.double_step = true
          end
        end

        if piece.instance_of?(King) || piece.instance_of?(Rook)
          piece.has_moved = true
        end

        if piece.instance_of?(Pawn) && check_if_diagonal_and_piece(start_pos, end_pos)
          # en passant
          self[start_pos[0], end_pos[1]] = nil
        end

        if piece.instance_of?(King) && (start_pos[1] - end_pos[1]).abs == 2
          # castling
          if end_pos[1] == 6
            move_rook_during_castle([start_pos[0], 7], [start_pos[0], end_pos[1] - 1])
          else
            move_rook_during_castle([start_pos[0], 0], [start_pos[0], end_pos[1] + 1])
          end
        end

        if piece.instance_of?(Pawn) && end_pos[0] == piece.ending_row
          # promote to queen
          self[*end_pos] = Queen.new(end_pos, piece.color, self)
        else
          self[*end_pos] = piece
          piece.pos = end_pos
        end
        self[*start_pos] = nil

        update_pawn_adjacents
  end

  def move_rook_during_castle(old_rook_pos, new_rook_pos)
    rook = self[*old_rook_pos]
    self[*new_rook_pos] = rook
    rook.pos = [*new_rook_pos]
    self[*old_rook_pos] = nil
  end

  def populate_board
    @grid.each.with_index do |row, i|
      row.each.with_index do |col, j|
        case
        when i == 0
          populate_rows_first_and_last(i, j, :black)
        when i == 1
          @grid[i][j] = Pawn.new([i, j], :black, self)
        when i == 6
          @grid[i][j] = Pawn.new([i, j], :white, self)
        when i == 7
          populate_rows_first_and_last(i, j, :white)
        end
      end
    end

  end

  def populate_rows_first_and_last(i, j, color)
    case
    when j == 0 || j == 7
      @grid[i][j] = Rook.new([i, j], color, self)
    when j == 1 || j == 6
      @grid[i][j] = Knight.new([i, j], color, self)
    when j == 2 || j == 5
      @grid[i][j] = Bishop.new([i, j], color, self)
    when j == 3
      @grid[i][j] = Queen.new([i, j], color, self)
    when j == 4
      @grid[i][j] = King.new([i, j], color, self)
    end
  end

  def update_pawn_adjacents
    (0..7).each do |x_pos|
      black_piece = self[4, x_pos]
      white_piece = self[3, x_pos]
      if black_piece.color == :black && black_piece.instance_of?(Pawn)
        left_pos = [4, x_pos - 1]
        right_pos = [4, x_pos + 1]
        add_adjacent_piece_to_pawn(black_piece, left_pos, 'left')
        add_adjacent_piece_to_pawn(black_piece, right_pos, 'right')
      elsif white_piece.color == :white && white_piece.instance_of?(Pawn)
        left_pos = [3, x_pos - 1]
        right_pos = [3, x_pos + 1]
        add_adjacent_piece_to_pawn(white_piece, left_pos, 'left')
        add_adjacent_piece_to_pawn(white_piece, right_pos, 'right')
      end
    end
  end

  def add_adjacent_piece_to_pawn(pawn, pos, adjacent_pos)
    if adjacent_pos == 'left'
      if in_bounds?(pos) && self[*pos].instance_of?(Pawn)
        pawn.adjacent_left = self[*pos]
      end
    elsif adjacent_pos == 'right'
      if in_bounds?(pos) && self[*pos].instance_of?(Pawn)
        pawn.adjacent_right = self[*pos]
      end
    end
  end

  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, value)
    @grid[row][col] = value
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def check_if_diagonal_and_piece(start_pos, end_pos)
    return false unless self[*end_pos].nil?

    if end_pos[1] - start_pos[1] != 0
      return true
    end
    false
  end

  def dup
    board_dup = Board.new(false)
    @grid.each_with_index do |row, i|
      row.each_with_index do |col, j|
        if @grid[i][j].nil? == false
          piece = @grid[i][j]
          case piece.value
          when '♜'
            board_dup.grid[i][j] = Rook.new([i, j], piece.color, board_dup)
          when '♞'
            board_dup.grid[i][j] = Knight.new([i, j], piece.color, board_dup)
          when '♝'
            board_dup.grid[i][j] = Bishop.new([i, j], piece.color, board_dup)
          when '♛'
            board_dup.grid[i][j] = Queen.new([i, j], piece.color, board_dup)
          when '♚'
            board_dup.grid[i][j] = King.new([i, j], piece.color, board_dup)
          when '♟'
            board_dup.grid[i][j] = Pawn.new([i, j], piece.color, board_dup)
          end
        end
      end
    end
    board_dup
  end

  def pieces
    @rows.flatten.reject { |piece| piece.empty? }
  end
end
