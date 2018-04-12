class Subscription < ApplicationRecord
  #TODO validate
  # A subscription is not necessarily linked to a user on creation
  belongs_to :user, optional: true
  scope :active, -> { where("payed_at > ?", 1.year.ago) }

  def until
    (payed_at + 1.year).to_date
  end
end
