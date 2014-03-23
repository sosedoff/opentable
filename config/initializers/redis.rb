# Initialize Redis
redis_url = ENV["REDIS_URL"] || ENV["REDISCLOUD_URL"] || "redis://localhost:6379"
Redis.current = Redis.new(url: redis_url)

# Try to connect to redis
Redis.current.info