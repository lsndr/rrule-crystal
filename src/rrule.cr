# require "./string_rrule"
# require "./rrule_string"
require "./frequency"
require "./weekday"

module RRule
  class RRule
    property freq : Frequency
    property interval : Int64?
    property wkst : Weekday?
    property count : Int64?
    property til : Time?
    property by_week_day : Array(Weekday)
    property by_month : Array(Int32)
    property by_set_pos : Array(Int32)
    property by_month_day : Array(Int32)
    property by_year_day : Array(Int32)
    property by_week_no : Array(Int32)
    property by_hour : Array(Int32)
    property by_minute : Array(Int32)
    property by_second : Array(Int32)

    def initialize(
      @freq,
      @interval = nil,
      @wkst = nil,
      @count = nil,
      @til = nil,
      @by_month = [] of Int32,
      @by_week_day = [] of Weekday,
      @by_set_pos = [] of Int32,
      @by_month_day = [] of Int32,
      @by_year_day = [] of Int32,
      @by_week_no = [] of Int32,
      @by_hour = [] of Int32,
      @by_minute = [] of Int32,
      @by_second = [] of Int32
    )
    end

    def wkst
      @wkst || Weekday::MO
    end

    def wkst?
      @wkst
    end

    def to_s(dtstart : DtStart)
      name = "RRULE"
      params = Hash(String, String).new
      value = Hash(String, String).new

      param_freq = freq
      param_til = til
      param_count = count
      param_wkst = wkst?
      param_by_week_day = by_week_day
      param_by_month = by_month
      param_by_set_pos = by_set_pos
      param_by_month_day = by_month_day
      param_by_year_day = by_year_day
      param_by_week_no = by_week_no
      param_by_hour = by_hour
      param_by_minute = by_minute
      param_by_second = by_second

      value["FREQ"] = param_freq.to_s
      value["UNTIL"] = Parser::Helpers.format_time(param_til.in(dtstart.tzid)) unless param_til.nil?
      value["COUNT"] = param_count.to_s unless param_count.nil?
      value["WKST"] = param_wkst.to_s unless param_wkst.nil?
      value["BYWEEKDAY"] = param_by_week_day.join(',') unless param_by_week_day.empty?
      value["BYMONTH"] = param_by_month.join(',') unless param_by_month.empty?
      value["BYSETPOS"] = param_by_set_pos.join(',') unless param_by_set_pos.empty?
      value["BYMONTHDAY"] = by_month_day.join(',') unless by_month_day.empty?
      value["BYYEARDAY"] = param_by_year_day.join(',') unless param_by_year_day.empty?
      value["BYWEEKNO"] = param_by_week_no.join(',') unless param_by_week_no.empty?
      value["BYHOUR"] = param_by_hour.join(',') unless param_by_hour.empty?
      value["BYMINUTE"] = param_by_minute.join(',') unless param_by_minute.empty?
      value["BYSECOND"] = param_by_second.join(',') unless param_by_second.empty?

      prop = Parser::Property.new(
        name: name,
        params: params,
        value: value
      )

      prop.to_s
    end

    def ==(rrule : RRule)
      freq == rrule.freq &&
        interval == rrule.interval &&
        wkst? == rrule.wkst? &&
        count == rrule.count &&
        til == rrule.til &&
        by_week_day == rrule.by_week_day &&
        by_month == rrule.by_month &&
        by_set_pos == rrule.by_set_pos &&
        by_month_day == rrule.by_month_day &&
        by_year_day == rrule.by_year_day &&
        by_week_no == rrule.by_week_no &&
        by_hour == rrule.by_hour &&
        by_minute == rrule.by_minute &&
        by_second == rrule.by_second
    end
  end
end
