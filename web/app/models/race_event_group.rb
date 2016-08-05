class RaceEventGroup < ApplicationRecord
  belongs_to :race_event
  belongs_to :race_session
  has_many :race_event_group_entries

  def calculate_race_data
    race_session_adapter = RaceSessionAdapter.new(self.race_session)

    listing = race_session_adapter.listing
    listing.each do |listing_entry|
      #puts "---------------------"
      #puts listing_entry.inspect
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
