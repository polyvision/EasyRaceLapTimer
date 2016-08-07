# responsible for assigning the pilots to groups etc for a race event
class RaceEventBuilderAdapter
  attr_accessor :race_event

  def initialize(race_event)
    self.race_event = race_event
  end

  def build
    # initial building
    if(race_event.current_heat == 1)
      build_mode_shuffle
      return
    end

    if(self.race_event.next_heat_grouping_mode == "stay")
      self.build_mode_stay
    end

    if(self.race_event.next_heat_grouping_mode == "shuffle")
      self.build_mode_shuffle
    end

    if(self.race_event.next_heat_grouping_mode == "combine_fastest_pilots_via_pos")
      self.build_mode_mode_combine_fastest_pilots_via_pos
    end
  end

  def build_mode_shuffle
    # get the pilots ordered randomly
    pilots_to_assign = Pilot.order("RAND()")

    current_race_group = RaceEventGroup.create(race_event_id: self.race_event.id,group_no: 1, heat_no: self.race_event.current_heat)

    pilots_to_assign.each do |pilot|
      current_race_group = self.assign_pilot_to_race_group(pilot,current_race_group)
    end # end of each pilot
  end

  def build_mode_stay
    # get the pilots ordered randomly
    pilots_to_assign = Pilot.order("RAND()")


    self.race_event.race_event_groups.where(heat_no: self.race_event.current_heat-1).each do |old_group|
      new_group = RaceEventGroup.new(race_event_id: old_group.race_event_id)
      new_group.heat_no = self.race_event.current_heat
      new_group.group_no = old_group.group_no
      new_group.save

      old_group.race_event_group_entries.each do |entry|
        self.assign_pilot_to_race_group(entry.pilot,new_group,false)
      end
    end
  end

  def build_mode_mode_combine_fastest_pilots_via_pos
    pos_data = Array.new
    # getting all the placements
    self.race_event.race_event_groups.where(heat_no: self.race_event.current_heat-1).each do |group|
      group.race_event_group_entries.each do |entry|
      pos_data << {pos: entry.placement,pilot: entry.pilot}
      end
    end

    # sorting
    pos_data = pos_data.sort_by do |item|
      item[:pos]
    end

    current_race_group = RaceEventGroup.create(race_event_id: self.race_event.id,group_no: 1, heat_no: self.race_event.current_heat)

    pos_data.each do |pos_entry|
      #puts "pos: #{pos_entry[:pos]} pilot: #{pos_entry[:pilot].id}"
      current_race_group = self.assign_pilot_to_race_group(pos_entry[:pilot],current_race_group)
    end # end of each pilot
  end

  def assign_pilot_to_race_group(pilot,current_race_group,create_new_group = true)
    race_event_group_entry = RaceEventGroupEntry.new
    race_event_group_entry.pilot_id = pilot.id
    race_event_group_entry.race_event_group_id = current_race_group.id
    race_event_group_entry.token = pilot.transponder_token
    race_event_group_entry.save

    if(ConfigValue::get_value("vtx_enabled") && ConfigValue::get_value("vtx_enabled").value.to_i == 1)
      current_race_group.reload
      race_event_group_entry.token = "VTX_#{current_race_group.race_event_group_entries.count}"
      race_event_group_entry.save
    end

    #puts "added pilot #{pilot.id} token: #{pilot.transponder_token} to group: #{current_race_group.group_no}"


    if(create_new_group == false)
      return false
    end

    if(current_race_group.race_event_group_entries.count >= self.race_event.number_of_pilots_per_group)
      #puts "adding new current group via assign_pilot_to_race_group heat: #{self.race_event.current_heat}"
      group_no = current_race_group.group_no + 1

      current_race_group = RaceEventGroup.create(race_event_id: self.race_event.id)
      current_race_group.group_no = group_no
      current_race_group.heat_no = self.race_event.current_heat
      current_race_group.save
    end
    return current_race_group
  end
end
