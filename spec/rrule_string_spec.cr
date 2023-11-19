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
  end
end
