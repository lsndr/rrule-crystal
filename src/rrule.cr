require "./frequency"
require "./weekday"

module RRule
  VERSION = "0.1.0"

  class RRule
    property dtstart : Time
    property tzid : Time::Location
    property freq : Frequency
    property interval : Int64?
    property wkst : Weekday
    property count : Int64?
    # until
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
      @tzid = Time::Location::UTC,
      @interval = nil,
      @wkst = Weekday::MO,
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
  end
end
