require "application_system_test_case"

class DenyReasonsTest < ApplicationSystemTestCase
  setup do
    @deny_reason = deny_reasons(:one)
  end

  test "visiting the index" do
    visit deny_reasons_url
    assert_selector "h1", text: "Deny reasons"
  end

  test "should create deny reason" do
    visit deny_reasons_url
    click_on "New deny reason"

    fill_in "Description", with: @deny_reason.description
    fill_in "Request", with: @deny_reason.request_id
    fill_in "User", with: @deny_reason.user_id
    click_on "Create Deny reason"

    assert_text "Deny reason was successfully created"
    click_on "Back"
  end

  test "should update Deny reason" do
    visit deny_reason_url(@deny_reason)
    click_on "Edit this deny reason", match: :first

    fill_in "Description", with: @deny_reason.description
    fill_in "Request", with: @deny_reason.request_id
    fill_in "User", with: @deny_reason.user_id
    click_on "Update Deny reason"

    assert_text "Deny reason was successfully updated"
    click_on "Back"
  end

  test "should destroy Deny reason" do
    visit deny_reason_url(@deny_reason)
    click_on "Destroy this deny reason", match: :first

    assert_text "Deny reason was successfully destroyed"
  end
end
