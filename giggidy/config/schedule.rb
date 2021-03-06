every 1.day, :at => "12:00am" do
  #query SeakGeek database for all bands' upcoming shows within a month
  rake "events:fetch_all_events"
end

every 1.day, :at => "02:00am" do
  #query events table for all user's favorite artists' events near user
  rake "notifications:populate_notifications"
end

every 1.day, :at => "06:00am" do
  #nightly purge of all guest information
  rake "users:purge_all_guests"
end

every 1.day, :at => "12:00pm" do
  #send out notifications to users about bands' upcoming shows
  rake "notifications:send_sms"
end

every 1.day, :at => "09:00pm" do
  #query SeatGeek and update tickets_left in Database
  rake "events:update_tickets_left"
end

every 1.day, :at => "10:00pm" do
  #go through all events and delete sold out events
  rake "events:purge_sold_out_events"
end

every 1.day, :at => "11:00pm" do
  #go through all events and delete expired events
  rake "events:purge_past_events"
end

