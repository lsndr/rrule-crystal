require "./frequency"
require "./weekday"

module RRule
  VERSION = "0.1.0"

  class RRule
    getter freq : Frequency
    getter dtstart : Time
    getter interval : Int64?
    getter wkst : Weekday
    getter count : Int64?
    # until
    getter til : Time?
    getter tzid : Time::Location?
    getter by_set_pos : Array(Int64)
    getter by_month_day : Array(Int64)
    getter by_year_day : Array(Int64)
    getter by_week_no : Array(Int64)
    getter by_hour : Array(Int64)
    getter by_minute : Array(Int64)
    getter by_second : Array(Int64)

    def initialize(
      @freq,
      @dtstart,
      @interval = nil,
      @wkst = Weekday::MO,
      @count = nil,
      @til = nil, 
      @tzid = nil, 
      @by_set_pos = [] of Int64, 
      @by_month_day = [] of Int64, 
      @by_year_day = [] of Int64, 
      @by_week_no = [] of Int64,
      @by_hour = [] of Int64,
      @by_minute = [] of Int64,
      @by_second = [] of Int64
    )
    end
  end
end
