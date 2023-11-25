module RRule::Parser::Helpers
  def self.parse_time?(time_str : String, location_str : String? = nil)
    location = Time::Location.load(location_str || "UTC")

    if match = /^([0-9]{4})([0-9]{2})([0-9]{2})T([0-9]{2})([0-9]{2})([0-9]{2})(Z?)$/i.match(time_str)
      year = (match[1].lstrip('0').presence || "0").to_i
      month = (match[2].lstrip('0').presence || "0").to_i
      day = (match[3].lstrip('0').presence || "0").to_i
      hour = (match[4].lstrip('0').presence || "0").to_i
      minute = (match[5].lstrip('0').presence || "0").to_i
      second = (match[6].lstrip('0').presence || "0").to_i
      utc = (match[7].try &.upcase) == "Z"

      # TODO: Think about narrowing exception type
      raise Exception.new("Provided TZID doesn't correlate with provided time format") unless location.utc? == utc

      return Time.local(year, month, day, hour, minute, second, location: location)
    end
  end

  def self.format_time(time : Time)
    year = time.year.to_s.rjust(4, '0')
    month = time.month.to_s.rjust(2, '0')
    day = time.day.to_s.rjust(2, '0')
    hour = time.hour.to_s.rjust(2, '0')
    minute = time.minute.to_s.rjust(2, '0')
    second = time.second.to_s.rjust(2, '0')

    "#{year}#{month}#{day}T#{hour}#{minute}#{second}#{("Z" if time.location.utc?)}"
  end
end
