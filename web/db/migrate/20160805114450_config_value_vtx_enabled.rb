class ConfigValueVtxEnabled < ActiveRecord::Migration[5.0]
  def change
  ConfigValue::set_value("vtx_enabled","1")
  end
end
