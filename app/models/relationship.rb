class Relationship < ActiveRecord::Base
	# References the foreign key for active_relationships
	belongs_to :follower, class_name: "User"
	# References the foreign key for passive_relationships
	belongs_to :followed, class_name: "User"
	validates :follower_id, presence: true
	validates :followed_id, presence: true
end
