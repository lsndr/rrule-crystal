# require "./string_rrule"
# require "./rrule_string"
require "./frequency"
require "./weekday"

module RRule
  class RRule
    property freq : Frequency
    property interval : Int32?
    property wkst : Weekday?
    property count : Int32?
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

    class InvalidRRuleProperty < Exception
    end

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
      param_interval = interval
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
      value["INTERVAL"] = param_interval.to_s unless param_interval.nil?
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

    def self.from_property(prop : Parser::Property, tzid : Time::Location)
      name = prop.name
      value = prop.value

      raise InvalidRRuleProperty.new("Invalid RRULE property name: #{name}") unless name == "RRULE"
      raise InvalidRRuleProperty.new("Invalid RRULE property value") unless value.is_a?(Hash(String, String))
      raise InvalidRRuleProperty.new("FREQ value parameter is required") if value["FREQ"]?.nil?

      freq = Frequency.parse(value["FREQ"])
      til = value["UNTIL"]? && Parser::Helpers.parse_time(value["UNTIL"], tzid)
      interval = value["INTERVAL"]? && value["INTERVAL"].to_i
      count = value["COUNT"]? && value["COUNT"].to_i
      wkst = value["WKST"]? && Weekday.parse(value["WKST"])
      by_week_day = value["BYWEEKDAY"]? && Parser::Helpers.parse_array_of_weekdays(value["BYWEEKDAY"])
      by_month = value["BYMONTH"]? && Parser::Helpers.parse_array_of_int32(value["BYMONTH"])
      by_set_pos = value["BYSETPOS"]? && Parser::Helpers.parse_array_of_int32(value["BYSETPOS"])
      by_month_day = value["BYMONTHDAY"]? && Parser::Helpers.parse_array_of_int32(value["BYMONTHDAY"])
      by_year_day = value["BYYEARDAY"]? && Parser::Helpers.parse_array_of_int32(value["BYYEARDAY"])
      by_week_no = value["BYWEEKNO"]? && Parser::Helpers.parse_array_of_int32(value["BYWEEKNO"])
      by_hour = value["BYHOUR"]? && Parser::Helpers.parse_array_of_int32(value["BYHOUR"])
      by_minute = value["BYMINUTE"]? && Parser::Helpers.parse_array_of_int32(value["BYMINUTE"])
      by_second = value["BYSECOND"]? && Parser::Helpers.parse_array_of_int32(value["BYSECOND"])

      self.new(
        freq: freq,
        til: til,
        interval: interval,
        count: count,
        wkst: wkst,
        by_week_day: by_week_day || [] of Weekday,
        by_month: by_month || [] of Int32,
        by_set_pos: by_set_pos || [] of Int32,
        by_month_day: by_month_day || [] of Int32,
        by_year_day: by_year_day || [] of Int32,
        by_week_no: by_week_no || [] of Int32,
        by_hour: by_hour || [] of Int32,
        by_minute: by_minute || [] of Int32,
        by_second: by_second || [] of Int32,
      )
    end
  end
end
