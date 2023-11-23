require "./frequency"
require "./weekday"

module RRule
  class StringRRule
    @string : String

    getter string

    class InvalidString < Exception
    end

    class InvalidDtstartString < Exception
    end

    def initialize(@string)
    end

    private def parse_dtstart(str : String)
      begin
        if dtstart = /^DTSTART:([0-9]{4})([0-9]{2})([0-9]{2})T([0-9]{2})([0-9]{2})([0-9]{2})Z$/.match(str)
          year = (dtstart[1].lstrip('0').presence || "0").to_i
          month = (dtstart[2].lstrip('0').presence || "0").to_i
          day = (dtstart[3].lstrip('0').presence || "0").to_i
          hour = (dtstart[4].lstrip('0').presence || "0").to_i
          minute = (dtstart[5].lstrip('0').presence || "0").to_i
          second = (dtstart[6].lstrip('0').presence || "0").to_i

          {Time.utc(year, month, day, hour, minute, second), Time::Location::UTC}
        elsif dtstart = /^DTSTART;TZID=([^:]+):([0-9]{4})([0-9]{2})([0-9]{2})T([0-9]{2})([0-9]{2})([0-9]{2})$/.match(str)
          tzid = Time::Location.load(dtstart[1])
          year = (dtstart[2].lstrip('0').presence || "0").to_i
          month = (dtstart[3].lstrip('0').presence || "0").to_i
          day = (dtstart[4].lstrip('0').presence || "0").to_i
          hour = (dtstart[5].lstrip('0').presence || "0").to_i
          minute = (dtstart[6].lstrip('0').presence || "0").to_i
          second = (dtstart[7].lstrip('0').presence || "0").to_i

          {Time.utc(year, month, day, hour, minute, second), tzid}
        else
          raise InvalidDtstartString.new
        end
      rescue ex : InvalidDtstartString
        raise ex
      rescue ex
        raise InvalidDtstartString.new(cause: ex)
      end
    end

    def parse
      dtstart = nil
      tzid = nil

      @string.split("\n") do |str|
        if dtstart.nil?
          dtstart, tzid = parse_dtstart(str.strip)
        end
      end

      raise InvalidString.new if dtstart.nil? || tzid.nil?

      RRule.new(
        dtstart: dtstart,
        tzid: tzid,
        freq: Frequency::DAILY
      )
    end
  end
end
