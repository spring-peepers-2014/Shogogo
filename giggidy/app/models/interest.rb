require 'open-uri'
require 'json'
require 'redis'

class Interest < ActiveRecord::Base
	@redis = Redis.new(:host => "127.0.0.1", :port => 6379)

	belongs_to :user

	def self.fetch_by_artists
		artist_ids = Interest.pluck(:geekseat_artist_id).uniq 
		artist_ids.map do |artist_id|
				@redis.sadd("artist_ids", artist_id) #keep it unique, suckah
				@redis.set(artist_id, fetch_artists_events_json(artist_id))
		end
	end

	def self.notify_users
		user_ids = Interest.where(:seatgeek_id => $redis.smembers("artist_ids")).pluck(:user_id)
    users = User.find(user_ids)
	# 	$redis.smembers("artist_ids").each do |x|

	end

	#returns bool
	def self.artist_has_events?(id)
		fetch_artist_json(id)["has_upcoming_events"]
	end

	def self.fetch_artist_json(id)
		JSON.parse(open("http://api.seatgeek.com/2/performers/#{id}").read)				
	end

	def self.fetch_artists_events_json(id) 
		JSON.parse(open("http://api.seatgeek.com/2/events?performers.id=#{id}").read)
	end

	# def pp
	# 	puts JSON.pretty_generate(@url)
	# end

	# def self.pp_redis_get
	# 	$redis.smembers("artist_ids").each do |x|
	# 		pp($redis.get(x))
	# 	end
	# end

end

