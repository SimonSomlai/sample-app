# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(
	name: "Simon",
	email: "simon_somlai@hotmail.com",
	password: "password",
	password_confirmation: "password",
	activated: true,
	activated_at: Time.zone.now,
	admin: true)

99.times do |n|
	name = Faker::Name.name
	email = Faker::Internet.email
	password = "password"
	User.create!(
		name: name,
		email: email,
		password: password,
		password_confirmation: password, 
		activated: true,
		activated_at: Time.zone.now,
		admin: false)
end

users = User.order(:created_at).take(6)
50.times do
	content = Faker::Lorem.sentence(5)
	users.each { |user| user.microposts.create(content: content)}
end

# Following relationships
users = User.all
user = User.first
following = users[2..50]
followers = users[3..40]
following.each {|following| user.follow!(following)}
followers.each {|followers| followers.follow!(user)}