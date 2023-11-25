require "./spec_helper"

describe RRule::RRuleSet do
  describe "initialize" do
    it "should initialize" do
      dtstart = RRule::DtStart.new(
        time: Time.utc(2004, 1, 10, 11, 0, 0)
      )

      rrule = RRule::RRule.new(
        freq: RRule::Frequency::DAILY
      )

      rrule_set = RRule::RRuleSet.new(
        dtstart: dtstart,
        rrules: [rrule]
      )

      rrule_set.dtstart.should eq(dtstart)
      rrule_set.dtstart.tzid.should eq(Time::Location::UTC)
      rrule_set.dtstart.tzid?.should eq(nil)
      rrule_set.rrules.size.should eq(1)
      rrule_set.rrules[0].freq.should eq(RRule::Frequency::DAILY)
      rrule_set.rrules[0].interval.should eq(nil)
      rrule_set.rrules[0].wkst.should eq(RRule::Weekday::MO)
      rrule_set.rrules[0].wkst?.should eq(nil)
      rrule_set.rrules[0].count.should eq(nil)
      rrule_set.rrules[0].til.should eq(nil)
      rrule_set.rrules[0].by_month.should eq([] of Int8)
      rrule_set.rrules[0].by_set_pos.should eq([] of Int32)
      rrule_set.rrules[0].by_week_day.should eq([] of RRule::Weekday)
      rrule_set.rrules[0].by_month_day.should eq([] of Int32)
      rrule_set.rrules[0].by_year_day.should eq([] of Int32)
      rrule_set.rrules[0].by_week_no.should eq([] of Int32)
      rrule_set.rrules[0].by_hour.should eq([] of Int32)
      rrule_set.rrules[0].by_minute.should eq([] of Int32)
      rrule_set.rrules[0].by_second.should eq([] of Int32)
    end
  end

  describe "build" do
    cases = {
      RRule::RRuleSet.new(
        dtstart: RRule::DtStart.new(Time.utc(2004, 1, 10, 11, 0, 0)),
        rrules: [
          RRule::RRule.new(
            freq: RRule::Frequency::WEEKLY
          ),
        ]
      ) => "DTSTART:20040110T110000Z\nRRULE:FREQ=WEEKLY",
      RRule::RRuleSet.new(
        dtstart: RRule::DtStart.new(Time.utc(2004, 1, 10, 11, 0, 0)),
        rrules: [
          RRule::RRule.new(
            freq: RRule::Frequency::HOURLY,
            count: 1
          ),
        ]
      ) => "DTSTART:20040110T110000Z\nRRULE:FREQ=HOURLY;COUNT=1",
      RRule::RRuleSet.new(
        dtstart: RRule::DtStart.new(Time.utc(2003, 1, 10, 11, 0, 0)),
        rrules: [
          RRule::RRule.new(
            freq: RRule::Frequency::HOURLY,
            wkst: RRule::Weekday::SA,
            til: Time.utc(2004, 1, 10, 11, 0, 0)
          ),
        ]
      ) => "DTSTART:20030110T110000Z\nRRULE:FREQ=HOURLY;UNTIL=20040110T110000Z;WKST=SA",
      RRule::RRuleSet.new(
        dtstart: RRule::DtStart.new(Time.local(2003, 1, 10, 11, 0, 0, location: Time::Location.load("America/Santiago")), Time::Location.load("America/Santiago")),
        rrules: [
          RRule::RRule.new(
            freq: RRule::Frequency::SECONDLY,
            wkst: RRule::Weekday::WE,
            til: Time.local(2004, 1, 10, 11, 0, 0, location: Time::Location.load("America/Santiago"))
          ),
        ]
      ) => "DTSTART;TZID=America/Santiago:20030110T110000\nRRULE:FREQ=SECONDLY;UNTIL=20040110T110000;WKST=WE",
      RRule::RRuleSet.new(
        dtstart: RRule::DtStart.new(Time.local(2003, 1, 10, 11, 0, 0, location: Time::Location.load("America/Santiago"))),
        rrules: [
          RRule::RRule.new(
            freq: RRule::Frequency::YEARLY,
            wkst: RRule::Weekday::TU,
            til: Time.local(2004, 1, 10, 11, 0, 0, location: Time::Location.load("America/Santiago"))
          ),
        ]
      ) => "DTSTART:20030110T140000Z\nRRULE:FREQ=YEARLY;UNTIL=20040110T140000Z;WKST=TU",
      RRule::RRuleSet.new(
        dtstart: RRule::DtStart.new(Time.utc(2003, 1, 10, 11, 0, 0)),
        rrules: [
          RRule::RRule.new(
            freq: RRule::Frequency::MONTHLY,
            wkst: RRule::Weekday::SU,
            by_week_day: [RRule::Weekday::MO, RRule::Weekday::SU]
          ),
        ]
      ) => "DTSTART:20030110T110000Z\nRRULE:FREQ=MONTHLY;WKST=SU;BYWEEKDAY=MO,SU",
      RRule::RRuleSet.new(
        dtstart: RRule::DtStart.new(Time.utc(2003, 1, 10, 11, 0, 0)),
        rrules: [
          RRule::RRule.new(
            freq: RRule::Frequency::MONTHLY,
            wkst: RRule::Weekday::FR,
            by_month: [1, 3, 4, 12]
          ),
        ]
      ) => "DTSTART:20030110T110000Z\nRRULE:FREQ=MONTHLY;WKST=FR;BYMONTH=1,3,4,12",
      RRule::RRuleSet.new(
        dtstart: RRule::DtStart.new(Time.utc(2003, 1, 10, 11, 0, 0)),
        rrules: [
          RRule::RRule.new(
            freq: RRule::Frequency::MONTHLY,
            wkst: RRule::Weekday::FR,
            by_month: [10, 1],
            by_set_pos: [3, 14]
          ),
        ]
      ) => "DTSTART:20030110T110000Z\nRRULE:FREQ=MONTHLY;WKST=FR;BYMONTH=10,1;BYSETPOS=3,14",
      RRule::RRuleSet.new(
        dtstart: RRule::DtStart.new(Time.utc(2003, 1, 10, 11, 0, 0)),
        rrules: [
          RRule::RRule.new(
            freq: RRule::Frequency::MINUTELY,
            wkst: RRule::Weekday::MO,
            by_month_day: [10, 15, 30]
          ),
        ]
      ) => "DTSTART:20030110T110000Z\nRRULE:FREQ=MINUTELY;WKST=MO;BYMONTHDAY=10,15,30",
      RRule::RRuleSet.new(
        dtstart: RRule::DtStart.new(Time.utc(2003, 1, 10, 11, 0, 0)),
        rrules: [
          RRule::RRule.new(
            freq: RRule::Frequency::SECONDLY,
            by_year_day: [100, 300]
          ),
        ]
      ) => "DTSTART:20030110T110000Z\nRRULE:FREQ=SECONDLY;BYYEARDAY=100,300",
      RRule::RRuleSet.new(
        dtstart: RRule::DtStart.new(Time.utc(2003, 1, 10, 11, 0, 0)),
        rrules: [
          RRule::RRule.new(
            freq: RRule::Frequency::WEEKLY,
            by_week_no: [4, 40, 30]
          ),
        ]
      ) => "DTSTART:20030110T110000Z\nRRULE:FREQ=WEEKLY;BYWEEKNO=4,40,30",
      RRule::RRuleSet.new(
        dtstart: RRule::DtStart.new(Time.utc(2003, 1, 10, 11, 0, 0)),
        rrules: [
          RRule::RRule.new(
            freq: RRule::Frequency::WEEKLY,
            by_hour: [2, 12],
            by_minute: [30, 59],
            by_second: [10, 30]
          ),
        ]
      ) => "DTSTART:20030110T110000Z\nRRULE:FREQ=WEEKLY;BYHOUR=2,12;BYMINUTE=30,59;BYSECOND=10,30",
    }

    cases.each do |(rrule_set, expected_string)|
      it "builds string #{expected_string}" do
        rrule_set_string = rrule_set.to_s

        rrule_set_string.should eq(expected_string)
      end
    end
  end

  # describe "to_a" do
  #   it "should represent DTSTART:20040110T110000Z\nRRULE:FREQ=DAILY;UNTIL=20040112T050000Z" do
  #     dtstart = Time.utc(2004, 1, 10, 11, 0, 0)
  #     til = Time.utc(2004, 1, 12, 5, 0, 0)
  #     freq = RRule::Frequency::DAILY

  #     rrule = RRule::RRule.new(
  #       dtstart: dtstart,
  #       freq: freq,
  #       til: til,
  #     )

  #     rrule.to_a.should eq([Time.utc(2004, 1, 10, 11, 0, 0), Time.utc(2004, 1, 11, 11, 0, 0)])
  #   end

  #   it "should represent DTSTART:20040110T110000Z\nRRULE:FREQ=WEEKLY;UNTIL=20040201T050000Z" do
  #     dtstart = Time.utc(2004, 1, 10, 11, 0, 0)
  #     til = Time.utc(2004, 2, 1, 5, 0, 0)
  #     freq = RRule::Frequency::WEEKLY

  #     rrule = RRule::RRule.new(
  #       dtstart: dtstart,
  #       freq: freq,
  #       til: til,
  #     )

  #     rrule.to_a.should eq([Time.utc(2004, 1, 10, 11, 0, 0), Time.utc(2004, 1, 17, 11, 0, 0), Time.utc(2004, 1, 24, 11, 0, 0), Time.utc(2004, 1, 31, 11, 0, 0)])
  #   end

  #   it "should represent DTSTART:20040131T110000Z\nRRULE:FREQ=MONTHLY;UNTIL=20040602T050000Z" do
  #     dtstart = Time.utc(2004, 1, 31, 11, 0, 0)
  #     til = Time.utc(2004, 6, 2, 5, 0, 0)
  #     freq = RRule::Frequency::MONTHLY

  #     rrule = RRule::RRule.new(
  #       dtstart: dtstart,
  #       freq: freq,
  #       til: til,
  #     )

  #     rrule.to_a.should eq([Time.utc(2004, 1, 31, 11, 0, 0), Time.utc(2004, 3, 31, 11, 0, 0), Time.utc(2004, 5, 31, 11, 0, 0)])
  #   end
  # end

  describe "==" do
    # TODO: Write tests
  end

  describe "self.from_string" do
    cases = {
      "DTSTART:20040110T110000Z\nRRULE:FREQ=DAILY;UNTIL=20040112T050000Z" => RRule::RRuleSet.new(
        dtstart: RRule::DtStart.new(
          time: Time.utc(2004, 1, 10, 11, 0, 0)
        ),
        rrules: [
          RRule::RRule.new(
            til: Time.utc(2004, 1, 12, 5, 0, 0),
            freq: RRule::Frequency::DAILY
          ),
        ]
      ),
    }

    cases.each do |(input_string, expected_rrule)|
      it "should convert #{input_string} to RRule" do
        rrule_set = RRule::RRuleSet.from_string(input_string)

        rrule_set.dtstart.should eq(expected_rrule.dtstart)
      end
    end
  end
end