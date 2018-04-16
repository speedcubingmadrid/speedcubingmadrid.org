# frozen_string_literal: true

class Country
  WCA_STATES_JSON_PATH = Rails.root.to_s + "/config/wca-states.json"

  MULTIPLE_COUNTRIES = [
    { id: 'XA', name: 'Multiple Countries (Asia)', continentId: '_Asia', iso2: 'XA' },
    { id: 'XE', name: 'Multiple Countries (Europe)', continentId: '_Europe', iso2: 'XE' },
    { id: 'XS', name: 'Multiple Countries (South America)', continentId: '_South America', iso2: 'XS' },
    { id: 'XM', name: 'Multiple Countries (Americas)', continentId: '_Multiple Continents', iso2: 'XM' },
  ].freeze

  MULTIPLE_COUNTRIES_IDS = MULTIPLE_COUNTRIES.map { |c| c[:id] }.freeze

  WCA_STATES = JSON.parse(File.read(WCA_STATES_JSON_PATH)).freeze

  def initialize(attrs)
    @id = attrs[:id]
    @iso2 = attrs[:iso2]
    @name = attrs[:name]
    @continentId = attrs[:continentId]
  end

  ALL_STATES = [
    WCA_STATES["states_lists"].map do |list|
      list["states"].map do |state|
        state_id = state["id"] || I18n.transliterate(state["name"]).tr("'", "_")
        { id: state_id, continentId: state["continent_id"],
          iso2: state["iso2"], name: state["name"] }
      end
    end,
    MULTIPLE_COUNTRIES,
  ].flatten.map { |c| Country.new(c) }.freeze

  attr_reader :id, :iso2, :real

  def name
    I18n.t(iso2, scope: :countries)
  end

  def real?
    !MULTIPLE_COUNTRIES_IDS.include?(id)
  end


  def self.real
    ALL_STATES.select { |c| c.real? }
  end

  def self.find_by_iso2(iso2)
    ALL_STATES.select { |c| c.iso2 == iso2 }.first
  end
end
