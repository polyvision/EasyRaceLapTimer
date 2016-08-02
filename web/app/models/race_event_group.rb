class RaceEventGroup < ApplicationRecord
  belongs_to :race_event
  has_many :race_event_group_entries
end
