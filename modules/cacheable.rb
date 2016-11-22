module Cacheable
  EXPIRY = 86400 # 1 day

  def set_cache key, val
    return if blank?( key ) || blank?( val )

    connection.set key, val
    connection.expire key, EXPIRY
  end

  def get_cache key
    connection.get( key ) if present?( key )
  end


  private

  def connection
    @conn ||= Redis.new( url:ENV[ 'REDIS_URI' ])
  end

  def blank? str
    str.to_s.strip == ''
  end

  def present? str
    ! blank?( str )
  end
end
