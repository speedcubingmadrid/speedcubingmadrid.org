class Hardware < ApplicationRecord
  TYPES = {
    "g2_mat" => "Tapis (Gen2)",
    "g2_stackmat" => "Timer+Tapis (Gen2)",
    "g2_display" => "Display (Gen2)",
    "g2_fullset" => "Timer+Tapis+Display (Gen2)",
    "g3_mat" => "Tapis (Gen3 Pro)",
    "g3_stackmat" => "Timer+Tapis (Gen3 Pro)",
    "g3_fullset" => "Timer+Tapis+Display (Gen3 Pro)",
    "g3_display" => "Display (Gen3 Pro)",
    "g4_stackmat" => "Timer+Tapis (Gen4)",
    "battery_cr2032" => "Pile CR2032",
    "battery_aa" => "Pile AA",
    "battery_aaa" => "Pile AAA",
    "big_battery" => "Grosse pile reloue",
    "harmonica_holder" => "Porte harmonica",
    "cube_cover" => "Cache cube",
    "stopwatch" => "Chrono à main",
    "blindfold_sheets" => "Feuilles blind",
  }.freeze

  STATES = {
    "ok" => "Fonctionne",
    "ko" => "Cassé",
  }.freeze

  belongs_to :bag, optional: true
  has_many :hardware_owners, -> { order(:start) }, dependent: :destroy, inverse_of: :hardware

  validates_presence_of :name
  validates_inclusion_of :hardware_type, in: TYPES.keys
  validates_inclusion_of :state, in: STATES.keys

  accepts_nested_attributes_for :hardware_owners, allow_destroy: true

  def hardware_type_string
    TYPES[hardware_type]
  end

  def state_string
    STATES[state]
  end

  def current_owner
    last_current_owner = nil
    today = Date.today
    hardware_owners.select do |owner|
      if owner.start <= today and owner.end > today
        last_current_owner = owner.user
      end
    end
    last_current_owner
  end
end
