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

    private def build_until (til : Time)
      "UNTIL=#{format_time(til)}"
    end

    private def format_time (time : Time)
      Time::Format::ISO_8601_DATE_TIME.format(time).gsub("-", "").gsub(":", "")
    end

    def build
      params = [] of String

      til = @rrule.til
      count = @rrule.count

      params << build_freq(@rrule.freq)
      params << build_until(til) unless til.nil?
      params << build_count(count) unless count.nil?
      params << build_wkst(@rrule.wkst)

      "RRULE:#{params.join(";")}"
    end
  end
end
