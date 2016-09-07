class ConfigValue < ActiveRecord::Base
    validates :name, presence: true
    def self.get_value(identifier)
      config_value = ConfigValue.where(name: identifier).first
      if !config_value
        puts "ConfigValue::get_value: #{identifier} not found"
        return false
      end
      return config_value
    end

    def self.set_value(identifier,value)
      config_value = ConfigValue.where(name: identifier).first_or_create
      config_value.update(value: value.to_s)
    end
end
