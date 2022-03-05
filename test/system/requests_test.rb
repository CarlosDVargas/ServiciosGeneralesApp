require "application_system_test_case"

class RequestsTest < ApplicationSystemTestCase
  setup do
    @request = requests(:one)
  end

  test "visiting the index" do
    visit requests_url
    assert_selector "h1", text: "Requests"
  end

  test "should create request" do
    visit requests_url
    click_on "New request"

    fill_in "Requester extension", with: @request.requester_extension
    fill_in "Requester", with: @request.requester_id
    fill_in "Requester mail", with: @request.requester_mail
    fill_in "Requester name", with: @request.requester_name
    fill_in "Requester phone", with: @request.requester_phone
    fill_in "Requester type", with: @request.requester_type
    fill_in "Student assosiation", with: @request.student_assosiation
    fill_in "Student", with: @request.student_id
    fill_in "Work building", with: @request.work_building
    fill_in "Work description", with: @request.work_description
    fill_in "Work location", with: @request.work_location
    fill_in "Work type", with: @request.work_type
    click_on "Create Request"

    assert_text "Request was successfully created"
    click_on "Back"
  end

  test "should update Request" do
    visit request_url(@request)
    click_on "Edit this request", match: :first

    fill_in "Requester extension", with: @request.requester_extension
    fill_in "Requester", with: @request.requester_id
    fill_in "Requester mail", with: @request.requester_mail
    fill_in "Requester name", with: @request.requester_name
    fill_in "Requester phone", with: @request.requester_phone
    fill_in "Requester type", with: @request.requester_type
    fill_in "Student assosiation", with: @request.student_assosiation
    fill_in "Student", with: @request.student_id
    fill_in "Work building", with: @request.work_building
    fill_in "Work description", with: @request.work_description
    fill_in "Work location", with: @request.work_location
    fill_in "Work type", with: @request.work_type
    click_on "Update Request"

    assert_text "Request was successfully updated"
    click_on "Back"
  end

  test "should destroy Request" do
    visit request_url(@request)
    click_on "Destroy this request", match: :first

    assert_text "Request was successfully destroyed"
  end
end
