require 'test_helper'

class DataFieldsControllerTest < ActionController::TestCase
  setup do
    @data_field = data_fields(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:data_fields)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create data_field" do
    assert_difference('DataField.count') do
      post :create, data_field: {  }
    end

    assert_redirected_to data_field_path(assigns(:data_field))
  end

  test "should show data_field" do
    get :show, id: @data_field
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @data_field
    assert_response :success
  end

  test "should update data_field" do
    patch :update, id: @data_field, data_field: {  }
    assert_redirected_to data_field_path(assigns(:data_field))
  end

  test "should destroy data_field" do
    assert_difference('DataField.count', -1) do
      delete :destroy, id: @data_field
    end

    assert_redirected_to data_fields_path
  end
end
