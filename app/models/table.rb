class Table

  attr_reader :entries, :table

  def initialize(games)
    @games = games
    @teams = []
    games.each do |game|
      @teams << game.home_team unless @teams.include?(game.home_team)
      @teams << game.away_team unless @teams.include?(game.away_team)
    end
    @entries = {}
    @teams.each do |team|
      @entries[team.id] = TableEntry.new(team)
    end
    @table = []
    regenerate
  end

  def regenerate
    @games.each do |game|
      if game.game_result and game.game_result.finished
        entry = @entries[game.home_team_id]
        entry.games += 1
        entry.points += game.game_result.home_team_points
        entry.goals_scored += game.game_result.home_team_score
        entry.goals_lost += game.game_result.away_team_score
        entry = @entries[game.away_team_id]
        entry.games += 1
        entry.points += game.game_result.away_team_points
        entry.goals_scored += game.game_result.away_team_score
        entry.goals_lost += game.game_result.home_team_score
      end
    end
    @table = @entries.values.sort_by do |e|
      [ -e.points, -e.goals_scored + e.goals_lost, -e.goals_scored ]
    end
  end

end
