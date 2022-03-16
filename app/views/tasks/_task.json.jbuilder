json.extract! task, :id, :employee_id, :request_id, :created_at, :updated_at
json.url task_url(task, format: :json)
