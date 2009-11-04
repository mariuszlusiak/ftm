namespace :tournament do

  desc 'Creates available tournament types'
  task :create_tournament_types => :environment do
    tt = TournamentType.new
    tt.name = 'Liga'
    tt.save
    tt = TournamentType.new
    tt.name = 'Puchar'
    tt.save
  end

  desc 'Creates available scheduling algorithm types'
  task :create_scheduling_algorithm_types => :environment do
    tt = TournamentType.find_by_name('Liga')
    if tt
      sat = SchedulingAlgorithmType.new
      sat.name = 'Round Robin'
      sat.tournament_type = tt
      sat.save
      sat = SchedulingAlgorithmType.new
      sat.name = 'ETSA (Elk Tournament Scheduling Algorithm)'
      sat.tournament_type = tt
      sat.save
    end
  end

end
