class Person < ActiveRecord::Base

	belongs_to :user
	belongs_to :team

	#has_many :person_roles, :through => :person_person_roles

	def full_name
		self.first_name + ' ' + self.name
	end

end
