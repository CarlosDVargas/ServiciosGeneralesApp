json.extract! employee, :id, :idCard, :fullName, :email, :status, :created_at, :updated_at
json.url employee_url(employee, format: :json)
