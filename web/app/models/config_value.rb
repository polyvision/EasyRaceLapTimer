class ConfigValue < ActiveRecord::Base
    validates :name, presence: true
    def self.get_value(identifier)
      config_value = ConfigValue.where(name: identifier).first
    end

    def self.set_value(identifier,value)
      config_value = ConfigValue.where(name: identifier).first_or_create
      config_value.update(value: value.to_s)
    end
end
