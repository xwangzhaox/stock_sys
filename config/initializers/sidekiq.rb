sidekiq_config = { url: ENV['REDIS_URL']||Rails.configuration.database_configuration[Rails.env]['redis_url'] }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
  config.error_handlers << Proc.new {|exception,context_hash| SyncWrongLog.create({platform: "sidekiq",message: exception, backtrace: context_hash.to_s[0..60000],state: 'unsolved'})}
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end