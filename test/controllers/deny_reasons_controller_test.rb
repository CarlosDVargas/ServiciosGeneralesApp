require "test_helper"

class DenyReasonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deny_reason = deny_reasons(:one)
  end

  test "should get index" do
    get deny_reasons_url
    assert_response :success
  end

  test "should get new" do
    get new_deny_reason_url
    assert_response :success
  end

  test "should create deny_reason" do
    assert_difference("DenyReason.count") do
      post deny_reasons_url, params: { deny_reason: { description: @deny_reason.description, request_id: @deny_reason.request_id, user_id: @deny_reason.user_id } }
    end

    assert_redirected_to deny_reason_url(DenyReason.last)
  end

  test "should show deny_reason" do
    get deny_reason_url(@deny_reason)
    assert_response :success
  end

  test "should get edit" do
    get edit_deny_reason_url(@deny_reason)
    assert_response :success
  end

  test "should update deny_reason" do
    patch deny_reason_url(@deny_reason), params: { deny_reason: { description: @deny_reason.description, request_id: @deny_reason.request_id, user_id: @deny_reason.user_id } }
    assert_redirected_to deny_reason_url(@deny_reason)
  end

  test "should destroy deny_reason" do
    assert_difference("DenyReason.count", -1) do
      delete deny_reason_url(@deny_reason)
    end

    assert_redirected_to deny_reasons_url
  end
end
