Sidekiq.configure_server do |config|
  config.redis = {
    url: "redis://#{ENV['REDIS_HOST'] || 'redis'}:#{ENV['REDIS_PORT'] || 6379}"
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: "redis://#{ENV['REDIS_HOST'] || 'redis'}:#{ENV['REDIS_PORT'] || 6379}"
  }
end
