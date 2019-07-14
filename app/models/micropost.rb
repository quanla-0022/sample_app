class Micropost < ApplicationRecord
  belongs_to :user
  scope :ordered_by_create_at, ->{order(created_at: :desc)}
  scope :load_user_micropost_by_id, ->(id){where "user_id = ?", id}
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.maximum_length_content}
  mount_uploader :picture, PictureUploader
  validate :picture_size

  private

  def picture_size
    return unless picture.size > Settings.picture_max_size.megabytes
    errors.add :picture, t("over_size")
  end
end
