namespace :person do

	desc 'Creates available roles'
	task :create_roles => :environment do
		role = PersonRole.new
		role.name = "Trener"
		role.description = "Pierwszy trener drużyny"
		role.save
		role = PersonRole.new
		role.name = "Menedżer"
		role.description = "Menedżer drużyny"
		role.save
	end

end
