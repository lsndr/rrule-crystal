require "./frequency"
require "./weekday"

module RRule
  class StringRRule
    @string : String

    getter string

    class InvalidFirstProperty < Exception
    end

    class InvalidProperty < Exception
    end

    class InvalidParameter < Exception
    end

    class InvalidParameters < Exception
    end

    class InvalidString < Exception
    end

    class InvalidTime < Exception
    end

    private struct Prop
      getter name, params, value
    
      def initialize(@name : String, @params : Hash(String, String), @value : String | Hash(String, String))
      end
    end

    def initialize(@string)
    end

    def parse_prop_key(str : String)
      name_params = str.split(';', 2)

      name = name_params[0].upcase.strip
      params = parse_params((name_params[1]? || "").strip)

      return {name, params}
    end

    def parse_param(str : String)
      key_value = str.split('=')

      if key_value.size == 1
        return {nil, key_value[0].strip}
      else
        raise InvalidParameter.new("Invalid parameter string: '#{str}'") if key_value.size > 2

        return {key_value[0].strip, key_value[1].strip}
      end
    end

    def parse_params(str : String)
      params = Hash(String, String).new

      str.split(';') do |param|
        key, value = parse_param(param.strip)

        if key.nil?
          if params.size == 0
            break if param.size == 0
            return value 
          else
            raise InvalidParameters.new("Invalid parameters string #{str}")
          end
        end

        params[key.upcase] = value
      end

      params
    end

    private def parse_prop(str : String)
      key_value = str.split(':')

      raise InvalidProperty.new("Invalid property string: '#{str}'") unless key_value.size == 2

      name, params = parse_prop_key(key_value[0].strip)
      value = parse_params(key_value[1].strip)

      raise InvalidProperty.new("Invalid property key params: '#{key_value[0]}'") if params.is_a?(String)

      Prop.new(
        name:   name,
        params: params,
        value:  value,
      )
    end

    def parse_time?(time_str : String, location_str : String?)
      location = Time::Location.load(location_str || "UTC")

      if match = /^([0-9]{4})([0-9]{2})([0-9]{2})T([0-9]{2})([0-9]{2})([0-9]{2})(Z?)$/i.match(time_str)
        year = (match[1].lstrip('0').presence || "0").to_i
        month = (match[2].lstrip('0').presence || "0").to_i
        day = (match[3].lstrip('0').presence || "0").to_i
        hour = (match[4].lstrip('0').presence || "0").to_i
        minute = (match[5].lstrip('0').presence || "0").to_i
        second = (match[6].lstrip('0').presence || "0").to_i

        utc = (match[6].try &.upcase) == "Z"

        return Time.local(year, month, day, hour, minute, second, location: location)
      end
    end

    private def parse_prop_strings(str : String, &)
      str.split('\n') do |str|
        yield str.strip
      end
    end

    private def parse_dtstart (prop : Prop)
      dtstart = prop.value
      tzid = prop.params["TZID"]?

      raise InvalidProperty.new("Invalid DTSTART prop name") unless prop.name == "DTSTART"
      raise InvalidProperty.new("Invalid DTSTART prop value") unless dtstart.is_a?(String)

      time = parse_time?(dtstart, tzid)

      raise InvalidProperty.new("Invalid DTSTART time") if time.nil?

      time
    end

    def parse
      dtstart = nil

      parse_prop_strings(@string) do |str|
        prop = parse_prop(str)

        if dtstart.nil?
          raise InvalidFirstProperty.new("Fist property must be DTSTART, but '#{prop.name}' provided") if prop.name != "DTSTART"

          dtstart = parse_dtstart(prop)
        end
      end

      raise InvalidString.new("Property DTSTART is not provided") if dtstart.nil?

      RRule.new(
        dtstart: dtstart,
        tzid: dtstart.location,
        freq: Frequency::DAILY
      )
    end
  end
end
