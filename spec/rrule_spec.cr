require "./spec_helper"

describe RRule::RRule do
  describe "initialize" do
    it "should initialize" do
      dtstart = Time.utc(2004, 1, 10, 11, 0, 0)
      freq = RRule::Frequency::DAILY

      rrule = RRule::RRule.new(
        dtstart: dtstart,
        freq: freq,
      )

      rrule.freq.should eq(freq)
      rrule.interval.should eq(nil)
      rrule.wkst.should eq(RRule::Weekday::MO)
      rrule.count.should eq(nil)
      rrule.til.should eq(nil)
      rrule.by_month.should eq([] of Int8)
      rrule.by_set_pos.should eq([] of Int32)
      rrule.by_week_day.should eq([] of RRule::Weekday)
      rrule.by_month_day.should eq([] of Int32)
      rrule.by_year_day.should eq([] of Int32)
      rrule.by_week_no.should eq([] of Int32)
      rrule.by_hour.should eq([] of Int32)
      rrule.by_minute.should eq([] of Int32)
      rrule.by_second.should eq([] of Int32)
    end
  end

  describe "to_a" do
    it "should iterate DTSTART:20040110T110000Z\nRRULE:FREQ=DAILY;UNTIL=20040112T050000Z" do
      dtstart = Time.utc(2004, 1, 10, 11, 0, 0)
      til = Time.utc(2004, 1, 12, 5, 0, 0)
      freq = RRule::Frequency::DAILY

      rrule = RRule::RRule.new(
        dtstart: dtstart,
        freq: freq,
        til: til,
      )

      rrule.to_a.should eq([Time.utc(2004, 1, 10, 11, 0, 0), Time.utc(2004, 1, 11, 11, 0, 0)])
    end
  end
end
