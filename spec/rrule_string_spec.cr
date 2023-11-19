require "./spec_helper"

describe RRule do
  describe RRule::RRuleString do
    it "builds string RRULE:FREQ=WEEKLY;WKST=MO" do
      rrule = RRule::RRule.new(
        freq: RRule::Frequency::WEEKLY
      )

      rrule_string = RRule::RRuleString.new(rrule)

      rrule_string.build.should eq("RRULE:FREQ=WEEKLY;WKST=MO")
    end

    it "builds string RRULE:FREQ=HOURLY;COUNT=1;WKST=MO" do
      rrule = RRule::RRule.new(
        freq: RRule::Frequency::HOURLY,
        count: 1
      )

      rrule_string = RRule::RRuleString.new(rrule)

      rrule_string.build.should eq("RRULE:FREQ=HOURLY;COUNT=1;WKST=MO")
    end

    it "builds string RRULE:FREQ=HOURLY;UNTIL=20040110T110000Z;WKST=SA" do
      rrule = RRule::RRule.new(
        freq: RRule::Frequency::HOURLY,
        wkst: RRule::Weekday::SA,
        til: Time.utc(2004, 1, 10, 11, 0 , 0)
      )

      rrule_string = RRule::RRuleString.new(rrule)

      rrule_string.build.should eq("RRULE:FREQ=HOURLY;UNTIL=20040110T110000Z;WKST=SA")
    end

    it "builds string RRULE:FREQ=SECONDLY;UNTIL=20040110T110000;WKST=WE" do
      tzid = Time::Location.load("America/Santiago")

      rrule = RRule::RRule.new(
        freq: RRule::Frequency::SECONDLY,
        wkst: RRule::Weekday::WE,
        til: Time.local(2004, 1, 10, 11, 0 , 0, location: tzid)
      )

      rrule_string = RRule::RRuleString.new(rrule, tzid)

      rrule_string.build.should eq("RRULE:FREQ=SECONDLY;UNTIL=20040110T110000;WKST=WE")
    end

    it "builds string RRULE:FREQ=YEARLY;UNTIL=20040110T140000Z;WKST=TU" do
      tzid = Time::Location.load("America/Santiago")

      rrule = RRule::RRule.new(
        freq: RRule::Frequency::YEARLY,
        wkst: RRule::Weekday::TU,
        til: Time.local(2004, 1, 10, 11, 0 , 0, location: tzid)
      )

      rrule_string = RRule::RRuleString.new(rrule)

      rrule_string.build.should eq("RRULE:FREQ=YEARLY;UNTIL=20040110T140000Z;WKST=TU")
    end
  end
end
