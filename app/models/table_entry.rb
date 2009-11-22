class TableEntry

  attr_accessor :team, :games, :points, :goals_scored, :goals_lost

  def initialize(team)
    @team = team
    @games = 0
    @points = 0
    @goals_scored = 0
    @goals_lost = 0
  end

end
