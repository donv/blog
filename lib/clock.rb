class Clock
  def self.at( *params )
    Time.at params[0]
  end

  def self.now
    Time.now
  end

  def time=
    raise "Cannot set time on real Clock class"
  end
end