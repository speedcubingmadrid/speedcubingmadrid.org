json.extract! calendar_event, :id, :name, :public, :start_time, :end_time, :kind, :created_at, :updated_at
json.title calendar_event.name
json.start calendar_event.start_time
json.end calendar_event.end_time
json.allDay true
json.edit_url edit_calendar_event_url(calendar_event, format: :js)
