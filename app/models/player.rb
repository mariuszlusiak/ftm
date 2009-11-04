class Player < ActiveRecord::Base

	belongs_to :user
	belongs_to :position
	belongs_to :team

	has_one :avatar, :as => :obj, :dependent => :destroy

	named_scope :free, :conditions => ['team_id is null']
	named_scope :not_free_nor_in_team,
		lambda { |team| { :conditions => ['team_id <> ?', team.id] } }

	def full_name
		self.first_name + ' ' + self.name
	end

end
