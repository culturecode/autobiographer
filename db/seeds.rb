# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

auth = Authentication.first
raise "You must log in and create a user first" unless auth
user = auth.user

PLACES = ['Hilton Riverside', 'Hilton Garden Inn', 'The Frenchman', 'Molly\'s', 'Watermelonadrea\'s', 'The Cemetery', 'Big Boi Concert', 'Nick\'s Birthday']
COMMENTS = ['Great food here!', 'YAGD (Yet another Girly Drink) for Ryan', 'Sucky music', 'Was great until the cops showed up.']

PLACES.each do |place_name|
  Event.create! do |e|
    e.place = place_name
    e.timestamp = Time.now - (rand(400).minutes)
    e.authentication_id = auth.id
    e.identifier = rand(1000)
    e.comment = COMMENTS[rand(COMMENTS.length)]
  end
end

Chapter.create!(:title => 'New Orleans', :subtitle => 'A tale of indulgence', :timestamp => Time.now - 400.minutes, :user_id => user.id)

PLACES.each do |place_name|
  Event.create! do |e|
    e.place = place_name
    e.timestamp = Time.now - 1.month + (rand(400).minutes)
    e.authentication_id = auth.id
    e.identifier = rand(1000)
    e.comment = COMMENTS[rand(COMMENTS.length)]
  end
end

Chapter.create!(:title => 'Baltimore', :subtitle => 'Stringer\'s Revenge', :timestamp => Time.now - 1.month, :user_id => user.id)