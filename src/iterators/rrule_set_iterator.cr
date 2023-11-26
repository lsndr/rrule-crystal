require "./rrule_iterator"
require "../rrule_set"
require "../frequency"
require "../weekday"

module RRule::Iterators
  class RRuleSetIterator
    include Iterator(Time)

    @rrule_iterators : Array(RRuleIterator)
    @value : Time?
    @started = false
    @stopped = false

    def initialize(
      rrule_set : RRuleSet
    )
      @rrule_iterators = rrule_set.rrules.map do |rrule|
        RRuleIterator.new(rrule, rrule_set.dtstart)
      end
    end

    def started?
      @started
    end

    def stopped?
      @stopped
    end

    def next
      return stop if stopped?

      @started = true
      new_value = next_value
      @value = new_value

      if new_value.nil?
        @stopped = true
        return stop
      end

      new_value
    end

    private def next_value
      new_value = nil

      @rrule_iterators.each do |iterator|
        while !iterator.stopped? && @value == iterator.value
          iterator.next
        end

        value = iterator.value
        new_value = iterator.value if !value.nil? && (new_value.nil? || value > new_value)
      end

      new_value
    end
  end
end
