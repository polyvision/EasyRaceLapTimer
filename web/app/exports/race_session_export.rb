class RaceSessionExport
  include ApplicationHelper
  attr_accessor :race_session

  def initialize(race_session)
    self.race_session = race_session
  end

  def export_to_xlsx
    race_session_adapter = RaceSessionAdapter.new(race_session)

    Axlsx::Package.new do |p|
      # the results of the race
      p.workbook.add_worksheet(:name => "Results") do |sheet|
        sheet.add_row [race_session.title,"mode: #{race_session.mode}",race_session.created_at.to_s]
        sheet.add_row ["pos","pilot","quad","team","fasted lap time","last lap time","laps","avg lap time"]

        race_session_adapter.listing.each_with_index do |entry,index|
          sheet.add_row [index + 1,entry['pilot'].name,entry['pilot'].quad,entry['pilot'].team,formated_lap_time(entry['fastest_lap']['lap_time']),formated_lap_time(entry['last_lap']['lap_time']),entry['lap_count'],formated_lap_time(entry['avg_lap_time'])]
        end
      end

      # the pilot detailed results
      race_session_adapter.pilot_ids.each do |pilot_id|
        pilot = Pilot.find(pilot_id)
        p.workbook.add_worksheet(:name => pilot.name) do |sheet|
          sheet.add_row ["lap","time","created at"]
          race_session.pilot_race_laps.where(pilot_id: pilot_id).order("lap_num ASC").each do |lap|
            sheet.add_row [lap.lap_num,formated_lap_time(lap.lap_time),lap.created_at.to_s]
          end
        end
      end

      return p
    end
  end
end
