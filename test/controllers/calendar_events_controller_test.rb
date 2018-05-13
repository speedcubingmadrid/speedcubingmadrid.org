require 'test_helper'

class CalendarEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @calendar_event = calendar_events(:one)
  end

  test "should get index" do
    get calendar_events_url
    assert_response :success
  end

  test "should get new" do
    get new_calendar_event_url
    assert_response :success
  end

  test "should create calendar_event" do
    assert_difference('CalendarEvent.count') do
      post calendar_events_url, params: { calendar_event: { end_time: @calendar_event.end_time, kind: @calendar_event.kind, name: @calendar_event.name, public: @calendar_event.public, start_time: @calendar_event.start_time } }
    end

    assert_redirected_to calendar_event_url(CalendarEvent.last)
  end

  test "should show calendar_event" do
    get calendar_event_url(@calendar_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_calendar_event_url(@calendar_event)
    assert_response :success
  end

  test "should update calendar_event" do
    patch calendar_event_url(@calendar_event), params: { calendar_event: { end_time: @calendar_event.end_time, kind: @calendar_event.kind, name: @calendar_event.name, public: @calendar_event.public, start_time: @calendar_event.start_time } }
    assert_redirected_to calendar_event_url(@calendar_event)
  end

  test "should destroy calendar_event" do
    assert_difference('CalendarEvent.count', -1) do
      delete calendar_event_url(@calendar_event)
    end

    assert_redirected_to calendar_events_url
  end
end
