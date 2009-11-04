namespace :player do

	desc 'Creates available field positions'
	task :create_positions => :environment do
		pos = Position.new
		pos.description = 'Bramkarz'
		pos.save
		pos = Position.new
		pos.description = 'Obrońca'
		pos.save
		pos = Position.new
		pos.description = 'Obrońca/Pomocnik'
		pos.save
		pos = Position.new
		pos.description = 'Pomocnik'
		pos.save
		pos = Position.new
		pos.description = 'Pomocnik/Napastnik'
		pos.save
		pos = Position.new
		pos.description = 'Napastnik'
		pos.save
	end

end
