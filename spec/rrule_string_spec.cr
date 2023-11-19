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
  end
end
