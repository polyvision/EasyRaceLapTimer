class RaceEventGroup < ApplicationRecord
  belongs_to :race_event
  belongs_to :race_session
  has_many :race_event_group_entries

  def invalidate
    self.race_event_group_entries.each do |entry|
      entry.placement = 0
      entry.fastest_lap_time = 0
      entry.total_time = 0
      entry.save
    end

    self.heat_done = false
    self.current = false
    self.save

    rs = self.race_session
    self.race_session_id = nil
    self.save

    rs.destroy
  end

  def calculate_race_data
    race_session_adapter = RaceSessionAdapter.new(self.race_session)

    listing = race_session_adapter.listing
    listing.each do |listing_entry|
      #puts "---------------------"
      puts listing_entry.inspect
      placement = listing_entry['position']
      total_time = listing_entry['race_time_sum_in_ms']
      fastest_lap_time = listing_entry['fastest_lap']['lap_time']

      rege = self.race_event_group_entries.where(pilot_id: listing_entry['pilot'].id).first
      rege.fastest_lap_time = fastest_lap_time
      rege.total_time = total_time
      rege.placement = placement
      rege.save
    end
  end
end
