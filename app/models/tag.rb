class Tag < ApplicationRecord
  before_save do
    self.name = self.name.strip
    if self.fullname.blank?
      self.fullname = self.name
    end
    true
  end
end
