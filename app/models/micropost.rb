class Micropost < ActiveRecord::Base
  default_scope -> { order(created_at: :desc) }
  validate :picture_size
  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  belongs_to :user

  # ----------------------- MODEL METHODS ----------------------------------------------

  private

  def picture_size
    if self.picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5mb")
    end
  end
end
