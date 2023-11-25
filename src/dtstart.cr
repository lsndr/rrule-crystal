require "./parser/*"

module RRule
  class DtStart
    property time : Time
    # TODO: Consider removing tzid in favour of dtstart.location
    property tzid : Time::Location?

    class InvalidDtstart < Exception
    end

    def initialize(
      @time,
      @tzid = nil
    )
    end

    def tzid
      @tzid || Time::Location::UTC
    end

    def tzid?
      @tzid
    end

    def ==(dtstart : DtStart)
      time == dtstart.time && tzid == dtstart.tzid
    end

    def to_s
      name = "DTSTART"
      params = Hash(String, String).new
      value = Parser::Helpers.format_time(time.in(tzid))

      params["TZID"] = tzid?.to_s unless tzid?.nil?

      prop = Parser::Property.new(
        name: name,
        params: params,
        value: value
      )

      prop.to_s
    end

    def self.from_string(str : String)
      prop = Parser::Property.from_string(str)

      name = prop.name
      value = prop.value
      tzid = prop.params["TZID"]?

      raise InvalidDtstart.new("Invalid DTSTART property name: '#{name}'") unless name == "DTSTART"
      raise InvalidDtstart.new("Invalid DTSTART property value") unless value.is_a?(String)

      time = Parser::Helpers.parse_time?(value, tzid)

      raise InvalidDtstart.new("Invalid DTSTART time") if time.nil?

      self.new(
        time: time,
        tzid: tzid && time.location
      )
    end
  end
end
