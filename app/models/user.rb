class User < ActiveRecord::Base
  # Virtual attribute to create remember_digest & activation_digest
  attr_accessor :remember_token, :activation_token, :reset_token

  # Save emails as downcase to the db
  before_save :downcase_email

  # Before creating a user, create a activation digest
  before_create :create_activation_digest

  # Email validation regex
  REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Validations
  validates :name, presence: true, uniqueness: true, length: {maximum: 50}
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: {maximum: 150}, format: { with: REGEX }
  validates :password, length: { minimum: 6 }

  # Adds virtual attributes password & password_confirmation to User and saves them as password_digest using BCrypt
  has_secure_password

  # Relational database
  has_many :microposts, dependent: :destroy

  # ----------------------- ADVANCED ASSOCIATIONS  ----------------------------------------------

  # Search the relationships table for follower_id matching user_id
  # active relationship collection -> see it as a search filter which creates a new collection which
  # has all the followed_id's which correspond to user_id
  has_many :active_relationships,
    class_name: "Relationship",
    foreign_key: "follower_id",
    dependent: :destroy
  # the people that the user follows, collection of user objects, get all the followed_id from the active relationship collection
  has_many :following, through: :active_relationships, source: :followed

  #   active_relationships collection
  # ------------------------------------
  # follower_id followed_id
  # ------------------------------------
  #     1      |   50
  #     1      |   15
  #     1      |   6

  # Search the relationships table for followed_id matching user_id
  # passive relationship collection -> see it as a search filter which creates a new collection which
  # has all the follower_id's which correspond to user_id
  has_many :passive_relationships,
    class_name: "Relationship",
    foreign_key: "followed_id",
    dependent: :destroy
  # the people that follow the user. get all the follower_id from the active relationship collection
  has_many :followers, through: :passive_relationships, source: :follower

  #   passive_relationships collection
  # ------------------------------------
  # followed_id follower_id
  # ------------------------------------
  #     1       |   50  (reciprocal)
  #     1       |   121
  #     1       |   12


  # ----------------------- MODEL METHODS ----------------------------------------------

  # Returns hash digest of given string using BCrypt
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Generates url-safe 16 character string
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # ----------------------- FORGETTING & REMEMBERING ----------------------------------------------

  # Checks if remember_digest (model attribute) matches remember_token (is User.authenticated?("remember_token") true?)
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    # Is the digest a match for the token?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Sets remember_token virtual attribute to a random string,
  # Updates remember_digest for object with a digest of that token
  def remember
    self.remember_token = User.new_token
    self.update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    self.update_attribute(:remember_digest, nil)
  end

  # ----------------------- ACTIVATING ----------------------------------------------

  def activate
    self.update_attribute(:activated, true)
    self.update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # ----------------------- PASSWORD RESET ----------------------------------------------

  def create_reset_digest
    # Sets digest when user submits password reset form (create action)
    self.reset_token = User.new_token
    self.update_attribute(:reset_digest, User.digest(self.reset_token))
    self.update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # ----------------------- FOLLOWING & FEED  ----------------------------------------------
  def feed
    # Find all microposts where user_id equals following_ids or is own id
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

  def follow!(user)
    self.active_relationships.create(followed_id: user.id)
  end

  def following?(user)
    self.following.include?(user)
  end

  def unfollow!(user)
    self.active_relationships.find_by(followed_id: user.id).destroy
  end

  # ----------------------- PRIVATE METHODS ----------------------------------------------

  private

  def create_activation_digest
    # Sets digest when user signs up (create action)
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def downcase_email
    self.email = email.downcase
  end
end
