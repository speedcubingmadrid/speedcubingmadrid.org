class MajorComp < ApplicationRecord
  include ApplicationHelper

  ALLOWED_ROLES = %w(french euro world).freeze

  belongs_to :competition, optional: true, primary_key: :id

  before_validation :get_competition_from_api

  validates_inclusion_of :role, in: ALLOWED_ROLES

  validate :id_and_name_not_null

  def id_and_name_not_null
    if competition_id.blank?
      if name.blank?
        errors.add(:name, "ne doit pas être vide si l'id est vide")
      end
    else
      errors.add(:competition_id, "n'est pas dans la base") unless competition
    end
  end

  def get_competition_from_api
    if !competition_id.blank? and competition.nil?
      success = RestClient.get(wca_api_competitions_url(competition_id)) do |response, request, result, &block|
        case response.code
        when 200
          competition_data = JSON.parse(response.body)
          update, comp = Competition.create_or_update(competition_data)
          self.competition = comp
          true
        else
          false
        end
      end
      unless success
        errors.add(:competition_id, "Impossible de récupérer la compétition sur le site de la WCA")
      end
    end
  end
end
