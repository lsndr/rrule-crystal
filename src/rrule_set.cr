require "./rrule_set_iterator"
require "./dtstart"

module RRule
  class RRuleSet
    include Enumerable(Time)

    class InvalidRRuleSet < Exception
    end

    property dtstart : DtStart
    getter rrules = [] of RRule

    def initialize(
      @dtstart,
      rrules = [] of RRule
    )
      add_rrules(rrules)
    end

    def add_rrule(rrule : RRule)
      @rrules.push(rrule)
    end

    def add_rrules(rrules : Array(RRule))
      @rrules.concat(rrules)
    end

    def each(&)
      iterator = RRuleSetIterator.new(self)

      iterator.each do |time|
        yield time
      end
    end

    def to_s
      String.build do |str|
        str << dtstart.to_s

        if rrules.size > 0
          str << "\n"

          rrules.each_with_index do |rrule, index|
            str << rrule.to_s(dtstart)
            str << "\n" unless index == rrules.size - 1
          end
        end
      end
    end

    def ==(rrule_set : RRuleSet)
      dtstart == rrule_set.dtstart && rrules == rrule_set.rrules
    end

    def self.from_string(str : String)
      dtstart = nil
      rrules = [] of RRule

      str.split('\n') do |str|
        prop = Parser::Property.from_string(str.strip)

        if dtstart.nil?
          dtstart = DtStart.from_property(prop)
        elsif prop.name == "RRULE"
          rrules << RRule.from_property(prop, dtstart.tzid)
        else
          raise InvalidRRuleSet.new("Unsupported property: #{prop.name}")
        end
      end

      raise InvalidRRuleSet.new("Property DTSTART is not provided") if dtstart.nil?

      RRuleSet.new(
        dtstart: dtstart,
        rrules: rrules
      )
    end
  end
end
