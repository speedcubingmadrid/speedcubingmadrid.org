class CalendarEvent < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :start_time
  validates_presence_of :end_time

  KINDS = {
    "other_afs" => "Activité AFS",
    "planned_competition" => "Compétition en projet",
  }.freeze

  validates_inclusion_of :kind, in: KINDS.keys
  validates_inclusion_of :public, in: [true, false].freeze

  validate :valid_dates
  def valid_dates
    return unless errors.blank?

    unless start_time <= end_time
      errors.add(:end_time, "should be after start_time")
    end
  end

  scope :visible, -> { where(public: true) }

  def color
    case kind
    when "other_afs"
      "#3639ed"
    when "planned_competition"
      "#ffa00e"
    else
      "#dddddd"
    end
  end

  def text_color
    case kind
    when "other_afs"
      "white"
    when "planned_competition"
      "black"
    else
      "black"
    end
  end

  def last_day
    # For fullcalendar an event on day d goes up to day d+1 at midnight, so the last day is actually end_time-1
    end_time - 1.day
  end
end
