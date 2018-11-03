class Competition < ApplicationRecord
  include WCAModel
  self.primary_key = :id

  # List of fields we accept in the db
  @@obj_info = %w(id city name country_iso2 start_date end_date country_iso2 website delegates organizers)

  scope :upcoming, -> (n=100) { where("start_date > ?", 2.days.ago).order(:start_date).limit(n) }
  scope :in_spain, -> { where(country_iso2: "ES") }
  scope :in_madrid, -> { where("city like ?", "%Madrid%") }

  def self.process_json(json_competition)
    json_competition["delegates"] = json_competition["delegates"].map do |d|
      User.create_or_update(d)
      d["id"]
    end
    json_competition["organizers"] = json_competition["organizers"].map do |d|
      User.create_or_update(d)
      d["id"]
    end
    json_competition
  end

  def self.create_or_update(json_competition)
    json_competition = process_json(json_competition)
    wca_create_or_update(json_competition)
  end
end
