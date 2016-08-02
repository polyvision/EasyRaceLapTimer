class RaceEventGroupEntry < ApplicationRecord
  belongs_to :race_event_group
  belongs_to :pilot
end
