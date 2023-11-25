require "./rrule_set"
require "./frequency"
require "./weekday"

module RRule
  class RRuleIterator
    include Iterator(Time)

    getter value

    @rrule : RRule
    @dtstart : DtStart
    @value : Time?
    @started = false
    @stopped = false

    def initialize(
      @rrule,
      @dtstart
    )
    end

    def started?
      @started
    end

    def stopped?
      @stopped
    end

    def next
      return stop if stopped?

      @started = true
      new_value = next_value
      @value = new_value

      if new_value.nil?
        @stopped = true
        return stop
      end

      new_value
    end

    private def increase_by_frequence(time : Time)
      case @rrule.freq
      when Frequency::DAILY
        time + 1.day
      when Frequency::WEEKLY
        time + 1.week
      when Frequency::MONTHLY
        step = 1
        # Recurrence rules may generate recurrence instances with an invalid date (e.g., February 30)
        # or nonexistent local time (e.g., 1:30 AM on a day where the local time is moved forward by an hour at 1:00 AM).
        # Such recurrence instances MUST be ignored and MUST NOT be counted as part of the recurrence set.
        # https://icalendar.org/iCalendar-RFC-5545/3-3-10-recurrence-rule.html
        loop do
          increased_time = time + Time::MonthSpan.new(step)
          return increased_time if increased_time.day == time.day

          step += 1
        end
      else
        raise Exception.new("Not implemented")
      end
    end

    private def next_value
      value = @value
      til = @rrule.til

      new_value = (value && increase_by_frequence(value)) || @dtstart.time.in(@dtstart.tzid)

      return nil if til.try &.< new_value

      new_value
    end
  end
end
