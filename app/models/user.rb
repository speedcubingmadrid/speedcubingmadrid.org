class User < ApplicationRecord
  include WCAModel
  # List of fields we accept in the db
  @@obj_info = %w(id name email wca_id country_iso2 avatar_url avatar_thumb_url gender birthdate delegate_status)

  has_many :subscriptions, -> { order(:created_at) }

  scope :subscription_notification_enabled, -> { where(notify_subscription: true).where.not(email: nil) }

  validate :cannot_demote_themselves
  def cannot_demote_themselves
    if admin_was == true && admin == false
      errors.add(:admin, "no puedes eliminar tu propia condición de administrador,  debes pedirle a otro administrador que lo haga.")
    end
  end

  def subscriptions_join
    Subscription.where("(wca_id <> '' and wca_id = ?) or lower(name)) = ?", wca_id, name.downcase)
  end


  def can_edit_user?(user)
    admin? || user.id == self.id
  end

  def can_manage_delegate_matters?
    admin? || spanish_delegate?
  end

  def can_manage_communication_matters?
    admin? || comm?
  end

  def can_manage_calendar?
    can_manage_delegate_matters? || can_manage_communication_matters?
  end

  def last_subscription
    subscriptions.last
  end

  def admin?
    admin
  end

  def comm?
    communication
  end

  def delegate?
    !delegate_status.blank?
  end

  def spanish_delegate?
    delegate? && spanish_delegate
  end

  def country_name
    Country.find_by_iso2(country_iso2).name
  end

  def friendly_delegate_status
    case delegate_status
    when "candidate_delegate"
      "Delegado Candidato WCA"
    when "senior_delegate"
      "Delegado Senior WCA"
    when "delegate"
      "Delegado WCA"
    else
      ""
    end
  end

  def friendly_birthdate
    birthdate&.strftime("%d-%m-%Y")
  end

  def self.process_json(json_user)
    # if such field exists, we are importing the WCIF,
    # else it's just a regular user login
    if json_user.include?("wcaUserId")
      json_user["id"] = json_user.delete("wcaUserId")
    end

    if json_user.include?("avatar")
      json_user["avatar_url"] = json_user["avatar"]["url"]
      json_user["avatar_thumb_url"] = json_user["avatar"]["thumbUrl"] || json_user["avatar"]["thumb_url"]
      json_user.delete("avatar")
    end
    %w(delegatesCompetition organizesCompetition registration personalBests).each do |k|
      json_user.delete(k)
    end
    if json_user.include?("birthdate")
      json_user["birthdate"] = json_user["birthdate"].to_date
    elsif json_user.include?("dob")
      json_user["birthdate"] = json_user["dob"].to_date
    end
    json_user
  end

  def self.create_or_update(json_user)
    json_user = process_json(json_user)
    wca_create_or_update(json_user)
  end

  def add_subscription(stripe_charge_id, amount)
    new_subscription = Subscription.new(user_id: id, name: name, wca_id: wca_id, email: email, stripe_charge_id: stripe_charge_id, amount: amount)
    new_subscription.save!
  end
end
