require "test_helper"

class DatassistantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @datassistant = datassistants(:one)
  end

  test "should get index" do
    get datassistants_url, as: :json
    assert_response :success
  end

  test "should create datassistant" do
    assert_difference('Datassistant.count') do
      post datassistants_url, params: { datassistant: { title: @datassistant.title, user_id: @datassistant.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show datassistant" do
    get datassistant_url(@datassistant), as: :json
    assert_response :success
  end

  test "should update datassistant" do
    patch datassistant_url(@datassistant), params: { datassistant: { title: @datassistant.title, user_id: @datassistant.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy datassistant" do
    assert_difference('Datassistant.count', -1) do
      delete datassistant_url(@datassistant), as: :json
    end

    assert_response 204
  end
end
