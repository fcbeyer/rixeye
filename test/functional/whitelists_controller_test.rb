require 'test_helper'

class WhitelistsControllerTest < ActionController::TestCase
  setup do
    @whitelist = whitelists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:whitelists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create whitelist" do
    assert_difference('Whitelist.count') do
      post :create, whitelist: { integer: @whitelist.integer, string: @whitelist.string, string: @whitelist.string }
    end

    assert_redirected_to whitelist_path(assigns(:whitelist))
  end

  test "should show whitelist" do
    get :show, id: @whitelist
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @whitelist
    assert_response :success
  end

  test "should update whitelist" do
    put :update, id: @whitelist, whitelist: { integer: @whitelist.integer, string: @whitelist.string, string: @whitelist.string }
    assert_redirected_to whitelist_path(assigns(:whitelist))
  end

  test "should destroy whitelist" do
    assert_difference('Whitelist.count', -1) do
      delete :destroy, id: @whitelist
    end

    assert_redirected_to whitelists_path
  end
end
