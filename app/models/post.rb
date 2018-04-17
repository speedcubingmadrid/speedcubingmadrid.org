class Post < ApplicationRecord
  belongs_to :user

  validates_presence_of :title, allow_blank: false
  validates_presence_of :body, allow_blank: false
  validates_presence_of :slug, allow_blank: false
  validates_presence_of :user, allow_blank: false
  validates_inclusion_of :draft, in: [true, false]
  validates_inclusion_of :competition_page, in: [true, false]
end
