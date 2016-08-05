class System::RaceEventController < SystemController
  def index
    @active_race_event = RaceEvent.where(active: true).first
    if !@active_race_event
      redirect_to action: 'new'
      return
    end

    @race_event_group_presenter = RaceEventGroupPresenter.new(@active_race_event)
  end

  def new
    @race_event = RaceEvent.new
  end

  def create
    @race_event = RaceEvent.new(strong_params_race_event)
    @race_event.save!

    builder = RaceEventBuilderAdapter.new(@race_event)
    builder.build
    redirect_to action: 'index'
  end

  def invalidate_heat_for_group
     @active_race_event = RaceEvent.where(active: true).first
     if !@active_race_event
      redirect_to action: 'index'
      return
    end

    group = @active_race_event.race_event_groups.where(id: params[:id]).first
    if group
      group.invalidate
    end

    redirect_to action: 'index'
  end

  private

  def strong_params_race_event
    params.require(:race_event).permit(:title,:number_of_heats,:number_of_pilots_per_group,:next_heat_grouping_mode)
  end
end
