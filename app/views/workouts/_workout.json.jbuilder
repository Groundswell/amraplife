json.extract! workout, :slug, :title, :workout_type, :description, :created_at, :updated_at
json.url workout_url(workout, format: :json)