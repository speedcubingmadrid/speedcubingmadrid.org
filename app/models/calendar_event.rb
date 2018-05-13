class CalendarEvent < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :public
  validates_presence_of :start_time
  validates_presence_of :end_time

  KINDS = {
    "other_afs" => "Activité AFS",
    "planned_competition" => "Compétition en projet",
  }.freeze

  validates_inclusion_of :kind, in: KINDS.keys

  validate :valid_dates
  def valid_dates
    return unless errors.blank?

    unless start_time <= end_time
      errors.add(:end_time, "should be after start_time")
    end
  end
end
