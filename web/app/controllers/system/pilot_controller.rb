class System::PilotController < SystemController
  def index
    @pilot_prototype = Pilot.new

    @pilots = Pilot.order("name ASC")
  end

  def edit
    @pilot = Pilot.find(params[:id])
  end

  def update
    @pilot = Pilot.find(params[:id])
    if !@pilot.update_attributes(strong_params_pilot)
      flash[:error] = @pilot.errors.full_messages.to_sentence
    end
    redirect_to action: 'index'
  end

  def deactivate_token
    @pilot = Pilot.find(params[:id])
    @pilot.update_attribute(:transponder_token, "")
    redirect_to action: 'index'
  end

  def delete
    @pilot = Pilot.find(params[:id])
    @pilot.transponder_token = nil
    @pilot.save(validate: false)
    @pilot.delete
    redirect_to action: 'index'
  end

  def create
    @pilot = Pilot.new(strong_params_pilot)
    if !@pilot.save
      @pilot_prototype = @pilot
      render action :'index'
    else
      redirect_to action: 'index'
    end
  end

  def prepare_import
    @adapter = FpvSportsApiAdapter.new()
    @racing_event_lists = @adapter.list_racing_events
  end

  def import
    if params[:racing_event_id].blank?
      redirect_to action: 'prepare_import'
      return
    end

    Pilot.all.each do |pilot|
      pilot.destroy
    end

    @adapter = FpvSportsApiAdapter.new()
    @pilot_list = @adapter.list_pilots_of_racing_event(params[:racing_event_id])

    @pilot_list.each do |pilot|
      Pilot.create(name: pilot['pilot_name'],transponder_token: "fpv_pilot_#{pilot['id']}",fpvsports_race_event_pilot_id: pilot['id'])
    end

    ConfigValue::set_value("fpvsports_racing_event_id",params[:racing_event_id])
    redirect_to action: 'index'
  end

  def strong_params_pilot
    params.require(:pilot).permit(:name,:transponder_token,:image,:quad,:team)
  end

end
