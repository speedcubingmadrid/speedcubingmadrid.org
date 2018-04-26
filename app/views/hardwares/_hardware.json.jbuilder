json.extract! hardware, :id, :name, :hardware_type, :state, :comment, :created_at, :updated_at
json.url hardware_url(hardware, format: :json)
