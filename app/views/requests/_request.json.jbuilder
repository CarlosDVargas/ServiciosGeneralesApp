json.extract! request, :id, :requester_name, :requester_extension, :requester_phone, :requester_id, :requester_mail, :requester_type, :student_id, :student_assosiation, :work_location, :work_building, :work_type, :work_description, :created_at, :updated_at
json.url request_url(request, format: :json)
