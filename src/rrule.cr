require "./frequency"
require "./weekday"

module RRule
  VERSION = "0.1.0"

  class RRule
    getter freq : Frequency
    getter interval : Int64?
    getter wkst : Weekday
    getter count : Int64?
    # until
    getter til : Time?
    getter by_week_day : Array(Weekday)
    getter by_month : Array(Int8)
    getter by_set_pos : Array(Int32)
    getter by_month_day : Array(Int32)
    getter by_year_day : Array(Int32)
    getter by_week_no : Array(Int32)
    getter by_hour : Array(Int32)
    getter by_minute : Array(Int32)
    getter by_second : Array(Int32)

    def initialize(
      @freq,
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
