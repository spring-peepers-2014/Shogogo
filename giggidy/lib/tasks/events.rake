namespace :events do

desc "Fetch events by artist ID"

	task :fetch_by_artist => :environment do
		#search through the interest database and fetch the events.
		Interest.fetch_by_artists
	end

end
