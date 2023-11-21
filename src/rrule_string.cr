require "./frequency"
require "./weekday"

module RRule
  class RRuleString
    def initialize(@rrule : RRule)
    end

    private def build_prop(name : String, value : Object)
      value = value.join(",") if value.is_a?(Array)

      "#{name}=#{value}"
    end

    private def build_time(name : String, local_time : Time)
      "#{name}=#{format_time(local_time)}"
    end

    private def build_dtstart
      tzid = @rrule.tzid
      dtstart = @rrule.dtstart
      
      if tzid.utc?
        "DTSTART:#{format_time(dtstart)}"
      else
        "DTSTART;TZID=#{tzid.name}:#{format_time(dtstart)}"
      end
    end

    private def format_time(local_time)
      tzid = @rrule.tzid
      time = local_time.in(tzid)

      year = time.year.to_s.rjust(4, '0')
      month = time.month.to_s.rjust(2, '0')
      day = time.day.to_s.rjust(2, '0')
      hour = time.hour.to_s.rjust(2, '0')
      minute = time.minute.to_s.rjust(2, '0')
      second = time.second.to_s.rjust(2, '0')

      "#{year}#{month}#{day}T#{hour}#{minute}#{second}#{("Z" if tzid.utc?)}"
    end

    def build
      rrule_params = [] of String

      til = @rrule.til
      count = @rrule.count
      by_week_day = @rrule.by_week_day
      by_month = @rrule.by_month
      by_set_pos = @rrule.by_set_pos
      by_month_day = @rrule.by_month_day
      by_year_day = @rrule.by_year_day
      by_week_no = @rrule.by_week_no
      by_hour = @rrule.by_hour
      by_minute = @rrule.by_minute
      by_second = @rrule.by_second

      rrule_params << build_prop("FREQ", @rrule.freq)
      rrule_params << build_time("UNTIL", til) unless til.nil?
      rrule_params << build_prop("COUNT", count) unless count.nil?
      rrule_params << build_prop("WKST", @rrule.wkst)
      rrule_params << build_prop("BYWEEKDAY", by_week_day) unless by_week_day.empty?
      rrule_params << build_prop("BYMONTH", by_month) unless by_month.empty?
      rrule_params << build_prop("BYSETPOS", by_set_pos) unless by_set_pos.empty?
      rrule_params << build_prop("BYMONTHDAY", by_month_day) unless by_month_day.empty?
      rrule_params << build_prop("BYYEARDAY", by_year_day) unless by_year_day.empty?
      rrule_params << build_prop("BYWEEKNO", by_week_no) unless by_week_no.empty?
      rrule_params << build_prop("BYHOUR", by_hour) unless by_hour.empty?
      rrule_params << build_prop("BYMINUTE", by_minute) unless by_minute.empty?
      rrule_params << build_prop("BYSECOND", by_second) unless by_second.empty?

      "#{build_dtstart}\nRRULE:#{rrule_params.join(";")}"
    end
  end
end
