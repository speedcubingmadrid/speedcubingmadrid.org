class Post < ApplicationRecord
  belongs_to :user

  validates_presence_of :title, allow_blank: false
  validates_presence_of :body, allow_blank: false
  validates :slug, presence: true, uniqueness: true, allow_blank: false
  validates_presence_of :user, allow_blank: false
  validates_inclusion_of :draft, in: [true, false]
  validates_inclusion_of :competition_page, in: [true, false]

  BREAK_TAG_RE = /{{post_excerpt}}/

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
end
