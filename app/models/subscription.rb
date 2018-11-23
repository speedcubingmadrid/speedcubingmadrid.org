class Subscription < ApplicationRecord
  belongs_to :user
  scope :active, -> { where("created_at > ?", 1.year.ago) }

  def wca_id
    self.user&.wca_id || self[:wca_id]
  end

  def until
    (created_at + 1.year).to_date
  end

  def over?
    created_at < 1.year.ago
  end

  def active?
    !over?
  end
end
