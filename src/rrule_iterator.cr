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
    @index : Int32?
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
      new_value, new_index = next_value
      @value = new_value
      @index = new_index

      if new_value.nil?
        @stopped = true
        return stop
      end

      new_value
    end

    private def increase_by_frequence(time : Time)
      # Recurrence rules may generate recurrence instances with an invalid date (e.g., February 30)
      # or nonexistent local time (e.g., 1:30 AM on a day where the local time is moved forward by an hour at 1:00 AM).
      # Such recurrence instances MUST be ignored and MUST NOT be counted as part of the recurrence set.
      # https://icalendar.org/iCalendar-RFC-5545/3-3-10-recurrence-rule.html

      new_time = time
      interval = @rrule.interval || 1

      interval.times do
        case @rrule.freq
        when Frequency::DAILY
          new_time = new_time + 1.day
        when Frequency::WEEKLY
          new_time = new_time + 1.week
        when Frequency::MONTHLY
          step = 1

          new_time = loop do
            increased_time = new_time + Time::MonthSpan.new(step)
            break increased_time if increased_time.day == new_time.day

            step += 1
          end
        else
          raise Exception.new("Not implemented")
        end
      end

      Time.local(new_time.year, new_time.month, new_time.day, time.hour, new_time.minute, new_time.second, location: time.location)
    end

    private def next_value
      value = @value
      index = @index
      til = @rrule.til
      count = @rrule.count

      new_value = nil
      new_index = nil

      if !value.nil? && !index.nil?
        new_value = increase_by_frequence(value)
        new_index = index + 1
      else
        new_value = @dtstart.time.in(@dtstart.tzid)
        new_index = 0
      end

      if til.try &.< new_value
        new_value = nil
        new_index = nil
      elsif count.try &.<(new_index + 1)
        new_value = nil
        new_index = nil
      end

      {new_value, new_index}
    end
  end
end
