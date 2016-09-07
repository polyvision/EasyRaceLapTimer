class SettingFpvsportsHost < ActiveRecord::Migration[5.0]
  def change
    ConfigValue::set_value("fpvsports_api_host","https://www.fpv-sports.io/")
  end
end
