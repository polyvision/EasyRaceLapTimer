class Api::V1::RaceEventController < Api::V1Controller
  before_action :filter_current_race_event

  def next_heat
    @current_race_event.next_heat
    render status: 200, plain: 'next heat done'
  end

  def start_next_race

    adapter = RaceEventRaceSessionBuilderAdapter.new(race_event)
    if adapter.perform
      render status: 200, plain: 'next heat done'
    else
      render status: 404, plain: "starting a new race failed: #{adapter.error}"
    end
  end

  private

  def filter_current_race_event
    @current_race_event = RaceEvent.where(active: true).first

    if !@current_race_event
      render stastus: 404, plain: 'found no active race event'
      return
    end
  end

end
