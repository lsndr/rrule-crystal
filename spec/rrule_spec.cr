require "./spec_helper"

describe RRule do
  describe RRule::RRule do
    it "be initialized" do
      freq = RRule::Frequency::DAILY

      rrule = RRule::RRule.new(
        freq: freq,
      )

      rrule.freq.should eq(freq)
      rrule.interval.should eq(nil)
      rrule.wkst.should eq(RRule::Weekday::MO)
      rrule.count.should eq(nil)
      rrule.til.should eq(nil)
      rrule.by_set_pos.should eq([] of Int64)
      rrule.by_month_day.should eq([] of Int64)
      rrule.by_year_day.should eq([] of Int64)
      rrule.by_week_no.should eq([] of Int64)
      rrule.by_hour.should eq([] of Int64)
      rrule.by_minute.should eq([] of Int64)
      rrule.by_second.should eq([] of Int64)
    end
  end
end
