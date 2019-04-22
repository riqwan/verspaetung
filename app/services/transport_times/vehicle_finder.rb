module TransportTimes
  class VehicleFinder
    include ActiveModel::Validations

    attr_accessor :x, :y, :time

    validates :x, presence: true, numericality: true
    validates :y, presence: true, numericality: true
    validates :time, presence: true
    validate :datetime_format_of_time
    validate :transport_stop_must_exist

    def initialize(params = {})
      @x  = params[:x]
      @y = params[:y]
      @time = params[:time]
    end

    def find
      transport_stop.transport_times.find_by(
        time: parsed_time.beginning_of_minute..parsed_time.end_of_minute
      )
    end

    private

    def parsed_time
      DateTime.parse(time.to_s)
    end

    def transport_stop
      @transport_stop ||= TransportStop.find_by(x: x, y: y)
    end

    def transport_stop_must_exist
      return transport_stop if transport_stop.present?

      errors.add(:x, 'transport stop with (x/y) value must exist') if x.present?
      errors.add(:y, 'transport stop with (x/y) value must exist') if y.present?
    end

    def datetime_format_of_time
      parsed_time if time.present?
    rescue ArgumentError => e
      add_invalid_datetime_error
    end

    def add_invalid_datetime_error
      errors.add(:time, 'must be of valid datetime format')
    end
  end
end
