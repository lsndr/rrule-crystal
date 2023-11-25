require "./rrule_set"
require "./frequency"
require "./weekday"

module RRule
  # class RRuleSetIterator
  #   include Iterator(Time)

  #   @rrule_set : RRuleSet
  #   @last_time : Time

  #   def initialize(
  #     @rrule_set
  #   )
  #     @rrule_set

  #     @last_time = @rrule.dtstart.in(@rrule.tzid)
  #   end

  #   private def increase_by_frequence(time : Time)
  #     case @rrule.freq
  #     when Frequency::DAILY
  #       time + 1.day
  #     when Frequency::WEEKLY
  #       time + 1.week
  #     when Frequency::MONTHLY
  #       step = 1
  #       # Recurrence rules may generate recurrence instances with an invalid date (e.g., February 30)
  #       # or nonexistent local time (e.g., 1:30 AM on a day where the local time is moved forward by an hour at 1:00 AM).
  #       # Such recurrence instances MUST be ignored and MUST NOT be counted as part of the recurrence set.
  #       # https://icalendar.org/iCalendar-RFC-5545/3-3-10-recurrence-rule.html
  #       loop do
  #         increased_time = time + Time::MonthSpan.new(step)
  #         return increased_time if increased_time.day == time.day

  #         step += 1
  #       end
  #     else
  #       raise Exception.new("Not implemented")
  #     end
  #   end

  #   def next
  #     return stop if @rrule.til.try &.<= @last_time

  #     last_time = @last_time
  #     @last_time = increase_by_frequence(@last_time)

  #     last_time
  #   end
  # end
end
