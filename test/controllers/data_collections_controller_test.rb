require 'test_helper'

class DataCollectionsControllerTest < ActionController::TestCase
  setup do
    @data_collection = data_collections(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:data_collections)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create data_collection" do
    assert_difference('DataCollection.count') do
      post :create, data_collection: {  }
    end

    assert_redirected_to data_collection_path(assigns(:data_collection))
  end

  test "should show data_collection" do
    get :show, id: @data_collection
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @data_collection
    assert_response :success
  end

  test "should update data_collection" do
    patch :update, id: @data_collection, data_collection: {  }
    assert_redirected_to data_collection_path(assigns(:data_collection))
  end

  test "should destroy data_collection" do
    assert_difference('DataCollection.count', -1) do
      delete :destroy, id: @data_collection
    end

    assert_redirected_to data_collections_path
  end
end
