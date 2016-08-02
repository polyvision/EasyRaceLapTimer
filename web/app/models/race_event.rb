class RaceEvent < ApplicationRecord
  has_many :race_event_groups
  enum next_heat_grouping_mode: {stay: 0, shuffle: 1, combine_fastest_pilots_via_pos: 2,combine_fastest_pilots_via_fastest_lap: 3}

  def num_groups_per_heat
    self.race_event_groups.where(heat_no: 1).count
  end

  def get_next_group_in_heat
    self.race_event_groups.where(heat_no: 1).count
  end

  def next_heat
    # marking the current groups as done
    self.race_event_groups.where(heat_no: self.current_heat).each do |group|
      group.heat_done = true
      group.save
    end

    if self.current_heat + 1 > self.number_of_heats
      return false
    end

    self.current_heat += 1
    self.save

    builder = RaceEventBuilderAdapter.new(self)
    builder.build

    return true
  end
end
