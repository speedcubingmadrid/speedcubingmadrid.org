require 'test_helper'

class HardwaresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hardware = hardwares(:one)
  end

  test "should get index" do
    get hardwares_url
    assert_response :success
  end

  test "should get new" do
    get new_hardware_url
    assert_response :success
  end

  test "should create hardware" do
    assert_difference('Hardware.count') do
      post hardwares_url, params: { hardware: { comment: @hardware.comment, name: @hardware.name, type: @hardware.type } }
    end

    assert_redirected_to hardware_url(Hardware.last)
  end

  test "should show hardware" do
    get hardware_url(@hardware)
    assert_response :success
  end

  test "should get edit" do
    get edit_hardware_url(@hardware)
    assert_response :success
  end

  test "should update hardware" do
    patch hardware_url(@hardware), params: { hardware: { comment: @hardware.comment, name: @hardware.name, type: @hardware.type } }
    assert_redirected_to hardware_url(@hardware)
  end

  test "should destroy hardware" do
    assert_difference('Hardware.count', -1) do
      delete hardware_url(@hardware)
    end

    assert_redirected_to hardwares_url
  end
end
