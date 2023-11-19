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

    private def build_wkst
      "WKST=#{@rrule.wkst.to_s}"
    end

    private def build_freq
      "FREQ=#{@rrule.freq.to_s}"
    end

    private def build_count
      raise Exception.new("@rrule.count is nil") if @rrule.count.nil?

      "COUNT=#{@rrule.count}"
    end


    def build
      params = [] of String

      params << build_freq
      params << build_count unless @rrule.count.nil?
      params << build_wkst


      "RRULE:#{params.join(";")}"
    end
  end
end
