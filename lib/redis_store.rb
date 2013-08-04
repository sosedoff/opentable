class RedisStore < ActiveSupport::Cache::Store
  def initialize(redis)
    @redis = redis
  end

  def increment(name, amount = 1, options = nil)
    @redis.incrby(name, amount)
  end

  def write(name, value, options = nil)
    @redis.set(name, value)
  end
end