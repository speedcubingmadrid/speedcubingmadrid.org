class CalendarEvent < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :start_time
  validates_presence_of :end_time

  KINDS = {
    "other_ams" => "Actividad AMS",
    "planned_competition" => "Competición siendo planeada",
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
    when "other_ams"
      "#3639ed"
    when "planned_competition"
      "#ffa00e"
    else
      "#000000"
    end
  end

  def text_color
    "white"
  end

  def last_day
    # For fullcalendar an event on day d goes up to day d+1 at midnight, so the last day is actually end_time-1
    end_time - 1.day
  end

  def start_date
    start_time.to_date
  end

  def end_date
    end_time.to_date
  end

  def inclusive_end_date
    (end_date - 1.day)
  end
end
