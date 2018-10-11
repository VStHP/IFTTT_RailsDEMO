require 'test_helper'

class IftttControllerTest < ActionDispatch::IntegrationTest
  test "should get status" do
    get ifttt_status_url
    assert_response :success
  end

end
