require "./frequency"
require "./weekday"

module RRule
  class RRuleString
    def initialize(@rrule : RRule, @tzid : Time::Location? = nil)
    end

    private def build_prop (name : String, value : Object)
      "#{name}=#{value}"
    end


    private def build_until (til : Time, tzid : Time::Location)
      "UNTIL=#{format_time(til, tzid)}"
    end

    private def build_time (name : String, local_time : Time)
      tzid = @tzid || Time::Location::UTC
      time = local_time.in(tzid)

      year = time.year.to_s.rjust(4, '0')
      month = time.month.to_s.rjust(2, '0')
      day = time.day.to_s.rjust(2, '0')
      hour = time.hour.to_s.rjust(2, '0')
      minute = time.minute.to_s.rjust(2, '0')
      second = time.second.to_s.rjust(2, '0')

      "#{name}=#{year}#{month}#{day}T#{hour}#{minute}#{second}#{("Z" if tzid.utc?)}"
    end

    def build
      params = [] of String

      til = @rrule.til
      count = @rrule.count

      params << build_prop("FREQ", @rrule.freq)
      params << build_time("UNTIL", til) unless til.nil?
      params << build_prop("COUNT", count) unless count.nil?
      params << build_prop("WKST", @rrule.wkst)

      "RRULE:#{params.join(";")}"
    end
  end
end
