require "./rrule_iterator"
require "./string_rrule"
require "./rrule_string"
require "./frequency"
require "./weekday"

module RRule
  class RRule
    include Iterable(Time)

    property dtstart : Time
    # TODO: Consider removing tzid in favour of dtstart.location
    property tzid : Time::Location?
    property freq : Frequency
    property interval : Int64?
    property wkst : Weekday?
    property count : Int64?
    property til : Time?
    property by_week_day : Array(Weekday)
    property by_month : Array(Int8)
    property by_set_pos : Array(Int32)
    property by_month_day : Array(Int32)
    property by_year_day : Array(Int32)
    property by_week_no : Array(Int32)
    property by_hour : Array(Int32)
    property by_minute : Array(Int32)
    property by_second : Array(Int32)

    def initialize(
      @dtstart,
      @freq,
      @tzid = nil,
      @interval = nil,
      @wkst = nil,
      @count = nil,
      @til = nil,
      @by_month = [] of Int8,
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

    def tzid
      @tzid || Time::Location::UTC
    end

    def tzid?
      @tzid
    end

    def each
      RRuleIterator.new(self)
    end

    def to_s
      RRuleString.new(self).build
    end

    def to_a
      each.to_a
    end

    def self.from_string(string : String)
      StringRRule.new(string).parse
    end
  end
end
