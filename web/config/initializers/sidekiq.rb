require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'ERLT' }
end

Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'ERLT' }
end
