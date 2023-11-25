require "./dtstart"

module RRule
  class RRuleSet
    # include Iterable(Time)

    class InvalidRRuleSet < Exception end

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

    # def each
    #   RRuleIterator.new(self)
    # end

    # def to_a
    #   each.to_a
    # end

    def to_s
      String.build do |str|
        str << dtstart.to_s

        if rrules.size > 0
          str << "\n"

          rrules.each_with_index  do |rrule, index|
            str << rrule.to_s(dtstart)
            str << "\n" unless index == rrules.size - 1
          end
        end
      end
    end

    def self.from_string(str : String)
      dtstart = nil

      str.split('\n') do |str|
        if dtstart.nil?
          dtstart = DtStart.from_string(str)
        end
      end

      raise InvalidRRuleSet.new("Property DTSTART is not provided") if dtstart.nil?

      RRuleSet.new(
        dtstart: dtstart
      )
    end
  end
end
