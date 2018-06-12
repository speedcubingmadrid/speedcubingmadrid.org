class CalendarEventsController < ApplicationController
  before_action :set_calendar_event, only: [:edit, :update, :destroy]
  before_action :redirect_unless_can_manage_calendar!, except: [:index]

  #TODO remove non-json endpoint
  # GET /calendar_events
  # GET /calendar_events.json
  def index
    @calendar_events = if current_user&.can_manage_calendar?
                         CalendarEvent.all
                       else
                         CalendarEvent.visible
                       end
  end

  # GET /calendar_events/new
  def new
    @calendar_event = CalendarEvent.new
    @calendar_event.start_time = params.require(:start)
    @calendar_event.end_time = params.require(:end)
  end

  # GET /calendar_events/1/edit
  def edit
  end

  # POST /calendar_events
  # POST /calendar_events.json
  def create
    @calendar_event = CalendarEvent.new(calendar_event_params)
    if !@calendar_event.save
      render :edit
    end
  end

  # PATCH/PUT /calendar_events/1
  # PATCH/PUT /calendar_events/1.json
  def update
    if !@calendar_event.update(calendar_event_params)
      render :edit
    end
  end

  # DELETE /calendar_events/1
  # DELETE /calendar_events/1.json
  def destroy
    @calendar_event.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendar_event
      @calendar_event = CalendarEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calendar_event_params
      params.require(:calendar_event).permit(:name, :public, :start_time, :end_time, :kind)
    end

    def redirect_unless_can_manage_calendar!
      unless current_user&.can_manage_calendar?
        redirect_to root_url, :alert => 'Vous ne pouvez pas gérer le calendrier.'
      end
    end
end
