require "./frequency"
require "./weekday"

module RRule
  class RRuleString
    def initialize(@rrule : RRule, @tzid : Time::Location? = nil)
    end

    private def build_array

    end

    private def build_date (name : String, time : Time)
        location = @rrule.tzid || Time::Location::UTC
        time_string = time.in(location).to_rfc3339

        "#{name}=#{time_string}"
    end

    private def build_wkst (wkst : Weekday)
      "WKST=#{wkst.to_s}"
    end

    private def build_freq(freq : Frequency)
      "FREQ=#{freq.to_s}"
    end

    private def build_count (count : Int64)
      "COUNT=#{count}"
    end

    private def build_until (til : Time, tzid : Time::Location)
      "UNTIL=#{format_time(til, tzid)}"
    end

    private def format_time (local_time : Time, location : Time::Location)
      time = local_time.in(location)


      year = time.year.to_s.rjust(4, '0')
      month = time.month.to_s.rjust(2, '0')
      day = time.day.to_s.rjust(2, '0')
      hour = time.hour.to_s.rjust(2, '0')
      minute = time.minute.to_s.rjust(2, '0')
      second = time.second.to_s.rjust(2, '0')

      "#{year}#{month}#{day}T#{hour}#{minute}#{second}#{("Z" if time.location.utc?)}"
    end

    def build
      params = [] of String

      til = @rrule.til
      count = @rrule.count
      tzid = @tzid || Time::Location::UTC

      params << build_freq(@rrule.freq)
      params << build_until(til, tzid) unless til.nil?
      params << build_count(count) unless count.nil?
      params << build_wkst(@rrule.wkst)

      "RRULE:#{params.join(";")}"
    end
  end
end
