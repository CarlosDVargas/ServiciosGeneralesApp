require "test_helper"

class RequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @request = requests(:one)
  end

  test "should get index" do
    get requests_url
    assert_response :success
  end

  test "should get new" do
    get new_request_url
    assert_response :success
  end

  test "should create request" do
    assert_difference("Request.count") do
      post requests_url, params: { request: { requester_extension: @request.requester_extension, requester_id: @request.requester_id, requester_mail: @request.requester_mail, requester_name: @request.requester_name, requester_phone: @request.requester_phone, requester_type: @request.requester_type, student_assosiation: @request.student_assosiation, student_id: @request.student_id, work_building: @request.work_building, work_description: @request.work_description, work_location: @request.work_location, work_type: @request.work_type } }
    end

    assert_redirected_to request_url(Request.last)
  end

  test "should show request" do
    get request_url(@request)
    assert_response :success
  end

  test "should get edit" do
    get edit_request_url(@request)
    assert_response :success
  end

  test "should update request" do
    patch request_url(@request), params: { request: { requester_extension: @request.requester_extension, requester_id: @request.requester_id, requester_mail: @request.requester_mail, requester_name: @request.requester_name, requester_phone: @request.requester_phone, requester_type: @request.requester_type, student_assosiation: @request.student_assosiation, student_id: @request.student_id, work_building: @request.work_building, work_description: @request.work_description, work_location: @request.work_location, work_type: @request.work_type } }
    assert_redirected_to request_url(@request)
  end

  test "should destroy request" do
    assert_difference("Request.count", -1) do
      delete request_url(@request)
    end

    assert_redirected_to requests_url
  end
end
