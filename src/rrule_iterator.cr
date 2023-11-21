require "./frequency"
require "./weekday"

module RRule
  class RRuleIterator
    include Iterator(Time)

    @rrule : RRule
    @last_time : Time

    def initialize(
      @rrule
    )
      @last_time = @rrule.dtstart.in(@rrule.tzid)
    end

    private def increase_by_frequence(time : Time)
      case @rrule.freq
      when Frequency::DAILY
        time + 1.day
      else
        raise Exception.new("Not implemented")
      end
    end

    def next
      return stop if @rrule.til.try &.<= @last_time

      last_time = @last_time
      @last_time = increase_by_frequence(@last_time)

      last_time
    end
  end
end
