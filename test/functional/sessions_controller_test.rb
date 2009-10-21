require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase
  def test_should_show_login_form
    get :new
    assert_response :success
    assert_template 'new'
    assert_select 'form p', 4
  end

  def test_should_perform_user_login
    post :create, :login => 'money', :password => 'testmoney'
    assert_redirected_to stories_path
    assert_equal users(:money).id, session[:user_id]
    assert_equal users(:money), assigns(:current_user)
  end

  def test_should_fail_user_login
    post :create, :login => 'no such', :password => 'user'
    assert_response :success
    assert_template 'new'
    assert_nil session[:user_id]
  end

  def test_should_redirect_after_login_with_return_url
    post :create, { :login => 'money', :password => 'testmoney' },
    :return_to => '/stories/new'
    assert_redirected_to '/stories/new'
  end

  def test_should_logout_and_clear_session
    post :create, :login => 'money', :password => 'testmoney'
    assert_not_nil assigns(:current_user)
    assert_not_nil session[:user_id]
    delete :destroy
    assert_response :success
    assert_template 'destroy'
    assert_select 'h2', 'Logout successful'
    assert_nil assigns(:current_user)
    assert_nil session[:user_id]
  end
end
