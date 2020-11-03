require 'test_helper'

class AcsControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get acs_login_url
    assert_response :success
  end

  test "should get logout" do
    get acs_logout_url
    assert_response :success
  end

end
