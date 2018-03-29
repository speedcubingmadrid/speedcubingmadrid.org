class User < ApplicationRecord
  include WCAModel
  # List of fields we accept in the db
  @@obj_info = %w(id name email wca_id country_iso2 avatar_url avatar_thumb_url gender birthdate delegate_status)

  def can_edit_user?(user)
    #FIXME
    #admin?
    true
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
    end
    json_user
  end

  def self.create_or_update(json_user)
    json_user = process_json(json_user)
    wca_create_or_update(json_user)
  end
end
