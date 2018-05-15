json.extract! calendar_event, :id, :public, :kind, :color
json.title calendar_event.name
json.start calendar_event.start_time
json.end calendar_event.end_time
json.allDay true
json.editable current_user&.can_manage_calendar?
json.textColor calendar_event.text_color
json.edit_url edit_calendar_event_url(calendar_event, format: :js)
json.update_url calendar_event_url(calendar_event, format: :js)
