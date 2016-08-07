class System::RaceEventController < SystemController
  def index
    @race_events = RaceEvent.all
  end

  def manage
    @active_race_event = RaceEvent.where(active: true).first
    @race_event_group_presenter = RaceEventGroupPresenter.new(@active_race_event)
  end

  def destroy
    @race_event = RaceEvent.where(id: params[:id]).first
    @race_event.destroy
    redirect_to action: 'index'
  end

  def new
    @race_event = RaceEvent.new
  end

  def create
    @race_event = RaceEvent.new(strong_params_race_event)
    @race_event.save!

    builder = RaceEventBuilderAdapter.new(@race_event)
    builder.build
    redirect_to action: 'manage', id: @race_event.id
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

    redirect_to action: 'manage', id: @race_event.id
  end

  def edit_group
    @race_event_group = RaceEventGroup.where(id: params[:id]).first
    if @race_event_group.current || @race_event_group.heat_done
      redirect_to action: 'manage', id: @race_event_group.race_event_id
      return
    end

    # unassigned pilots
    group_ids = @race_event_group.race_event.race_event_groups.pluck(:id)
    pilot_ids = RaceEventGroupEntry.where(race_event_group_id: group_ids).pluck(:pilot_id)
    @not_assigned_pilots = Pilot.where.not(id: pilot_ids)
  end

  def del_pilot_from_group
    @race_event_group_entry = RaceEventGroupEntry.where(id: params[:id]).first
    if @race_event_group_entry
      @race_event_group_entry.destroy
    end
    redirect_to action: 'edit_group', id: @race_event_group_entry.race_event_group.id
  end

  def add_pilot_to_group
    @race_event_group = RaceEventGroup.where(id: params[:id]).first
    if @race_event_group.current || @race_event_group.heat_done
      redirect_to action: 'manage', id: @race_event_group.race_event_id
      return
    end

    pilot = Pilot.where(id: params[:pilot_id]).first
    race_event_group_entry = RaceEventGroupEntry.new
    race_event_group_entry.pilot_id   = pilot.id
    race_event_group_entry.race_event_group_id = @race_event_group.id
    race_event_group_entry.token = ""
    race_event_group_entry.save

    redirect_to action: 'edit_group', id: @race_event_group.id
  end

  private

  def strong_params_race_event
    params.require(:race_event).permit(:title,:number_of_heats,:number_of_pilots_per_group,:next_heat_grouping_mode)
  end
end
