class Post < ApplicationRecord
  belongs_to :user

  validates_presence_of :title, allow_blank: false
  validates_presence_of :body, allow_blank: false
  validates :slug, presence: true, uniqueness: true, allow_blank: false
  validates_presence_of :user, allow_blank: false
  validates_inclusion_of :draft, in: [true, false]
  validates_inclusion_of :competition_page, in: [true, false]

  default_scope { order(created_at: :desc) }
  scope :visible, -> { where(draft: false) }
  scope :featured, -> { where(feature: true) }
  scope :all_posts, -> { where(competition_page: false) }
  scope :competition_pages, -> { where(competition_page: true) }

  BREAK_TAG_RE = /{{post_excerpt}}/

  #TODO posted at, which change when it's created, or when it goes from draft to not draft

  def body_full
    body.sub(BREAK_TAG_RE, "")
  end

  def fullpost?
    body.split(BREAK_TAG_RE).length > 1
  end

  def body_teaser
    split = body.split(BREAK_TAG_RE)
    split.first
  end

  def user_can_view?(user)
    !draft || user&.can_manage_communication_matters?
  end
end
