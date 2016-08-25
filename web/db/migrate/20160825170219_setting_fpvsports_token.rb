class SettingFpvsportsToken < ActiveRecord::Migration[5.0]
  def change
    ConfigValue::set_value("fpvsports_api_token","")
  end
end
