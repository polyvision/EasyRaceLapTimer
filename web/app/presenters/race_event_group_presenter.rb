class RaceEventGroupPresenter
  attr_accessor :race_event

  def initialize(race_event)
    self.race_event = race_event
  end

  def groups_for_heat(heat_no)
    self.race_event.race_event_groups.where(heat_no: heat_no).order("id ASC")
  end

  def group_of_heat(heat_no,group_no)
    self.race_event.race_event_groups.where(heat_no: heat_no).order("id ASC").offset(group_no).limit(1).first
  end
end
