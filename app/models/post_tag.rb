class PostTag < ApplicationRecord
  has_one :tag, foreign_key: :name, primary_key: :tag_name

  validates :tag_name, format: { with: Taggable::TAG_REGEX, message: Taggable::TAG_REGEX_MESSAGE }

  before_validation do
    self.tag_name = self.tag_name.strip
    Tag.find_or_create_by(name: tag_name)
  end
end
