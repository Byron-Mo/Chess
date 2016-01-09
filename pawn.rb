#has color, value, pos, board attributes
#has to_s, in_bounds?, same_color?, diff_color? methods
class Pawn < Piece
  attr_accessor :double_step, :adjacent_left, :adjacent_right
  attr_reader :ending_row, :fifth_rank

  def initialize(pos, color = nil, board = nil)
    super
    @starting_row = pos[0]
    @double_step = false
    @adjacent_left = nil
    @adjacent_right = nil
    generate_offsets(color)

    if @starting_row == 1
      @ending_row = 7
      @fifth_rank = 4
    elsif @starting_row = 6
      @ending_row = 0
      @fifth_rank = 3
    end
  end

  def generate_offsets(color)
    mult = (color == :white) ? -1 : 1
    @start_offset = [2*mult, 0]
    @attack_offset = [[mult,-1], [mult, 1]]
    @move_offset = [mult, 0]
  end

  def moves
    moves = []
    move_one_pos = [@pos[0] + @move_offset[0], @pos[1] + @move_offset[1]]
    if in_bounds?(move_one_pos)
      if @board[*move_one_pos].nil?
        moves << move_one_pos
        move_two_pos = [@pos[0] + @start_offset[0], @pos[1] + @start_offset[1]]
        if @starting_row == pos[0] && @board[*move_two_pos].nil?
          moves << move_two_pos
        end
      end
    end
    @attack_offset.each do |offset|
      diagonal_pos = [@pos[0] + offset[0], @pos[1] + offset[1]]
      if in_bounds?(diagonal_pos) && opp_color?(@board[*@pos], @board[*diagonal_pos])
        moves << diagonal_pos
      end
    end

    if @pos[0] == @fifth_rank
      @attack_offset.each_with_index do |offset, idx|
        diagonal_pos = [@pos[0] + offset[0], @pos[1] + offset[1]]
        if @board[*diagonal_pos].nil? && in_bounds?(diagonal_pos)
          if idx == 0
            if @adjacent_left.instance_of?(Pawn) && @adjacent_left.double_step == true
              moves << diagonal_pos
            end
          elsif idx == 1
            if @adjacent_right.instance_of?(Pawn) && @adjacent_left.double_step == true
              moves << diagonal_pos
            end
          end
        end
      end
    end
    moves
  end

end
