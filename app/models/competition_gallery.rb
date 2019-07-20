class CompetitionGallery < ApplicationRecord
  belongs_to :competition
  belongs_to :user

  has_many_attached :photos

  validates_presence_of :competition_id, allow_blank: false
  validates_presence_of :user_id, allow_blank: false
  validates :photos, presence: true, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 0..25.megabytes }

  scope :visible, -> { where(draft: false) }
  scope :featured, -> { where(feature: true) }
  scope :not_featured, -> { where(feature: false) }
end
