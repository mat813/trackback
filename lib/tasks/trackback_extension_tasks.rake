namespace :radiant do
  namespace :extensions do
    namespace :trackback do

      desc "Runs the migration of the Trackback extension"
      task :migrate => :environment do
	require 'radiant/extension_migrator'
	if ENV["VERSION"]
	  TrackbackExtension.migrator.migrate(ENV["VERSION"].to_i)
	else
	  TrackbackExtension.migrator.migrate
	end
      end

    end
  end
end
