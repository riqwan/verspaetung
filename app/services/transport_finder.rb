class TransportFinder
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def find_transport_at_time(time)
    return if time.blank?

    transport_stop.transport_times.find_by(time: time)
  end

  private

  def transport_stop
    @transport_stop ||= TransportStop.find_by!(x: x, y: y)
  end
end
