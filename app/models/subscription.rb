class Subscription < ApplicationRecord
  #TODO validate

  # A subscription is not necessarily linked to a user on creation
  belongs_to :user, optional: true
  scope :active, -> { where("payed_at > ?", 1.year.ago) }
  scope :userless, -> { where("user_id is null") }

  after_save :try_associate_user

  def until
    (payed_at + 1.year).to_date
  end

  def try_associate_user
    unless user_id.blank?
      return
    end
    # Try first by WCA ID
    unless wca_id.blank?
      user = User.find_by(wca_id: wca_id)
      if user
        self.user_id = user.id
        self.save
        return
      end
    end
    matchs = User.where("lower(name) = ?", "#{firstname.downcase} #{name.downcase}")
    if matchs.size == 1
      self.user_id = matchs.first.id
      self.save
    end
  end

  private :try_associate_user
end
