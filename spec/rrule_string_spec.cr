require "./spec_helper"

describe RRule::RRuleString do
  describe "build" do
    it "builds string DTSTART:20040110T110000Z\nRRULE:FREQ=WEEKLY;WKST=MO" do
      rrule = RRule::RRule.new(
        dtstart: Time.utc(2004, 1, 10, 11, 0, 0),
        freq: RRule::Frequency::WEEKLY
      )

      rrule_string = RRule::RRuleString.new(rrule)

      rrule_string.build.should eq("DTSTART:20040110T110000Z\nRRULE:FREQ=WEEKLY;WKST=MO")
    end

    it "builds string DTSTART:20040110T110000Z\nRRULE:FREQ=HOURLY;COUNT=1;WKST=MO" do
      rrule = RRule::RRule.new(
        dtstart: Time.utc(2004, 1, 10, 11, 0, 0),
        freq: RRule::Frequency::HOURLY,
        count: 1
      )

      rrule_string = RRule::RRuleString.new(rrule)

      rrule_string.build.should eq("DTSTART:20040110T110000Z\nRRULE:FREQ=HOURLY;COUNT=1;WKST=MO")
    end

    it "builds string DTSTART:20030110T110000Z\nRRULE:FREQ=HOURLY;UNTIL=20040110T110000Z;WKST=SA" do
      rrule = RRule::RRule.new(
        dtstart: Time.utc(2003, 1, 10, 11, 0, 0),
        freq: RRule::Frequency::HOURLY,
        wkst: RRule::Weekday::SA,
        til: Time.utc(2004, 1, 10, 11, 0, 0)
      )

      rrule_string = RRule::RRuleString.new(rrule)

      rrule_string.build.should eq("DTSTART:20030110T110000Z\nRRULE:FREQ=HOURLY;UNTIL=20040110T110000Z;WKST=SA")
    end

    it "builds string DTSTART;TZID=America/Santiago:20030110T110000\nRRULE:FREQ=SECONDLY;UNTIL=20040110T110000;WKST=WE" do
      tzid = Time::Location.load("America/Santiago")

      rrule = RRule::RRule.new(
        dtstart: Time.local(2003, 1, 10, 11, 0, 0, location: tzid),
        tzid: tzid,
        freq: RRule::Frequency::SECONDLY,
        wkst: RRule::Weekday::WE,
        til: Time.local(2004, 1, 10, 11, 0, 0, location: tzid)
      )

      rrule_string = RRule::RRuleString.new(rrule)

      rrule_string.build.should eq("DTSTART;TZID=America/Santiago:20030110T110000\nRRULE:FREQ=SECONDLY;UNTIL=20040110T110000;WKST=WE")
    end

    it "builds string DTSTART:20030110T140000Z\nRRULE:FREQ=YEARLY;UNTIL=20040110T140000Z;WKST=TU" do
      tzid = Time::Location.load("America/Santiago")

      rrule = RRule::RRule.new(
        dtstart: Time.local(2003, 1, 10, 11, 0, 0, location: tzid),
        freq: RRule::Frequency::YEARLY,
        wkst: RRule::Weekday::TU,
        til: Time.local(2004, 1, 10, 11, 0, 0, location: tzid)
      )

      rrule_string = RRule::RRuleString.new(rrule)

      rrule_string.build.should eq("DTSTART:20030110T140000Z\nRRULE:FREQ=YEARLY;UNTIL=20040110T140000Z;WKST=TU")
    end

    it "builds string DTSTART:20030110T110000Z\nRRULE:FREQ=MONTHLY;WKST=SU;BYWEEKDAY=MO,SU" do
      rrule = RRule::RRule.new(
        dtstart: Time.utc(2003, 1, 10, 11, 0, 0),
        freq: RRule::Frequency::MONTHLY,
        wkst: RRule::Weekday::SU,
        by_week_day: [RRule::Weekday::MO, RRule::Weekday::SU]
      )

      rrule_string = RRule::RRuleString.new(rrule)

      rrule_string.build.should eq("DTSTART:20030110T110000Z\nRRULE:FREQ=MONTHLY;WKST=SU;BYWEEKDAY=MO,SU")
    end

    it "builds string DTSTART:20030110T110000Z\nRRULE:FREQ=MONTHLY;WKST=FR;BYMONTH=1,3,4,12" do
      rrule = RRule::RRule.new(
        dtstart: Time.utc(2003, 1, 10, 11, 0, 0),
        freq: RRule::Frequency::MONTHLY,
        wkst: RRule::Weekday::FR,
        by_month: [1_i8, 3_i8, 4_i8, 12_i8]
      )

      rrule_string = RRule::RRuleString.new(rrule)

      rrule_string.build.should eq("DTSTART:20030110T110000Z\nRRULE:FREQ=MONTHLY;WKST=FR;BYMONTH=1,3,4,12")
    end

    it "builds string DTSTART:20030110T110000Z\nRRULE:FREQ=MONTHLY;WKST=FR;BYMONTH=10,1;BYSETPOS=3,14" do
      rrule = RRule::RRule.new(
        dtstart: Time.utc(2003, 1, 10, 11, 0, 0),
        freq: RRule::Frequency::MONTHLY,
        wkst: RRule::Weekday::FR,
        by_month: [10_i8, 1_i8],
        by_set_pos: [3, 14]
      )

      rrule_string = RRule::RRuleString.new(rrule)

      rrule_string.build.should eq("DTSTART:20030110T110000Z\nRRULE:FREQ=MONTHLY;WKST=FR;BYMONTH=10,1;BYSETPOS=3,14")
    end

    it "builds string DTSTART:20030110T110000Z\nRRULE:FREQ=MINUTELY;WKST=MO;BYMONTHDAY=10,15,30" do
      rrule = RRule::RRule.new(
        dtstart: Time.utc(2003, 1, 10, 11, 0, 0),
        freq: RRule::Frequency::MINUTELY,
        wkst: RRule::Weekday::MO,
        by_month_day: [10, 15, 30]
      )

      rrule_string = RRule::RRuleString.new(rrule)

      rrule_string.build.should eq("DTSTART:20030110T110000Z\nRRULE:FREQ=MINUTELY;WKST=MO;BYMONTHDAY=10,15,30")
    end

    it "builds string DTSTART:20030110T110000Z\nRRULE:FREQ=SECONDLY;WKST=MO;BYYEARDAY=100,300" do
      rrule = RRule::RRule.new(
        dtstart: Time.utc(2003, 1, 10, 11, 0, 0),
        freq: RRule::Frequency::SECONDLY,
        by_year_day: [100, 300]
      )

      rrule_string = RRule::RRuleString.new(rrule)

      rrule_string.build.should eq("DTSTART:20030110T110000Z\nRRULE:FREQ=SECONDLY;WKST=MO;BYYEARDAY=100,300")
    end

    it "builds string DTSTART:20030110T110000Z\nRRULE:FREQ=WEEKLY;WKST=MO;BYWEEKNO=4,40,30" do
      rrule = RRule::RRule.new(
        dtstart: Time.utc(2003, 1, 10, 11, 0, 0),
        freq: RRule::Frequency::WEEKLY,
        by_week_no: [4, 40, 30]
      )

      rrule_string = RRule::RRuleString.new(rrule)

      rrule_string.build.should eq("DTSTART:20030110T110000Z\nRRULE:FREQ=WEEKLY;WKST=MO;BYWEEKNO=4,40,30")
    end

    it "builds string DTSTART:20030110T110000Z\nRRULE:FREQ=WEEKLY;WKST=MO;BYHOUR=2,12;BYMINUTE=30,59;BYSECOND=10,30" do
      rrule = RRule::RRule.new(
        dtstart: Time.utc(2003, 1, 10, 11, 0, 0),
        freq: RRule::Frequency::WEEKLY,
        by_hour: [2, 12],
        by_minute: [30, 59],
        by_second: [10, 30]
      )

      rrule_string = RRule::RRuleString.new(rrule)

      rrule_string.build.should eq("DTSTART:20030110T110000Z\nRRULE:FREQ=WEEKLY;WKST=MO;BYHOUR=2,12;BYMINUTE=30,59;BYSECOND=10,30")
    end
  end
end
