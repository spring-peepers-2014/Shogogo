require 'open-uri'

class Event < ActiveRecord::Base
	belongs_to :artist
	has_many :notifications
	has_many :users, through: :artist
	reverse_geocoded_by :latitude, :longitude
	after_validation :geocode
	validates :name, :datetime_local, :latitude, :longitude, presence: true
	validates :ticket_url, :seatgeek_id, presence: true, uniqueness: true

	def self.fetch_all_events
		artist_ids = Favorite.pluck(:artist_id).uniq
		artist_ids.map! do |artist_id|
      Artist.find(artist_id).seatgeek_id
    end
		artist_ids.each do |artist_id|
			results = fetch_artist_events(artist_id)
			insert_events(artist_id, results)
		end
	end

	def self.update_tickets_left
		events = Event.all
		events.each do |event|
			results = fetch_event(event.seatgeek_id)
			update_ticket_count(event.id, results)
		end
	end

	private
	
	def self.fetch_artist_events(artist_id)
		response = Net::HTTP.get(URI.parse("http://api.seatgeek.com/2/events?performers.id=#{artist_id}"))
		JSON.parse(response)
	end

	def self.insert_events(artist_id, results)
		results['events'].each do |event|
			Event.where(seatgeek_id: event['id'])
					 .first_or_create(name: event['title'],
													  ticket_url: "#{event['url']}?aid=10879",
													  datetime_local: event['datetime_local'],
													  latitude: event['venue']['location']['lat'],
													  longitude: event['venue']['location']['lon'],
													  seatgeek_id: event['id'],
													  tickets_left: event['stats']['listing_count'],
													  artist_id: artist_id)
		end
	end

	def self.fetch_event(event_id)
		response = Net::HTTP.get(URI.parse("http://api.seatgeek.com/2/events/#{event_id}"))
		JSON.parse(response) 
	end

	def self.update_ticket_count(event_id, results)
		event = Event.find(event_id)
		event.update_attributes(tickets_left: results['stats']['listing_count'])
	end
end