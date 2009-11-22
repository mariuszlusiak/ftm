class Goals < ActiveRecord::Base

  belongs_to :game_result

  named_scope :team, lambda { |team_id| :conditions => ['team_id = ?', team_id] }

end
