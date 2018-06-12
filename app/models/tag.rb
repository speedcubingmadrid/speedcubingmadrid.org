class Tag < ApplicationRecord

  TAG_NAME_REGEX = /\A[- [:alpha:][:digit:]]+\z/
  TAG_NAME_REGEX_MESSAGE = "accepte uniquement des lettres, chiffres, espaces et tirets."

  validates :name, format: { with: Taggable::TAG_REGEX, message: Taggable::TAG_REGEX_MESSAGE }
  validates :fullname, format: { with: TAG_NAME_REGEX, message: TAG_NAME_REGEX_MESSAGE }

  before_validation do
    self.name = self.name.strip
    if self.fullname.blank?
      self.fullname = self.name
    end
    true
  end
end
