class Hardware < ApplicationRecord
  include HasOwners
  TYPES = {
    "g3_display" => "Display (Gen3 Pro)",
    "g4_stackmat" => "StackMat (Gen4)",
    "g4_fullset" => "StackMat (Gen4) + Display (Gen3 Pro)",
    "battery_aa" => "Pila AA",
    "battery_aaa" => "Pila AAA",
    "harmonica_holder" => "Soporte de armónica",
    "cube_cover" => "Tapacubo",
    "stopwatch" => "Cronómetro de mano",
    "blindfold_sheets" => "Cartulinas para blind",
    "cable" => "Cable",
    "other" => "Otro",
  }.freeze

  STATES = {
    "ok" => "Funciona",
    "ko" => "Roto",
  }.freeze

  belongs_to :bag, optional: true

  validates_presence_of :name
  validates_inclusion_of :hardware_type, in: TYPES.keys
  validates_inclusion_of :state, in: STATES.keys

  def hardware_type_string
    TYPES[hardware_type]
  end

  def state_string
    STATES[state]
  end

  def real_owner
    bag&.current_owner || current_owner
  end
end
