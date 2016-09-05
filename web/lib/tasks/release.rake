namespace :release do
  desc "cleans up the database for a release"
  task :cleanup => :environment do
    RaceSession.find_each do |t|
      t.destroy
    end

    Pilot.find_each do |t|
      t.destroy
    end
  end
end
