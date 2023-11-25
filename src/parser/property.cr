module RRule::Parser
  class Property
    property name : String
    property params : Hash(String, String)
    property value : String | Hash(String, String)

    class InvalidProperty < Exception
    end

    class InvalidParameter < Exception
    end

    class InvalidParameters < Exception
    end

    def initialize(@name, @params, @value)
    end

    def tzid
      @tzid || Time::Location::UTC
    end

    def tzid?
      @tzid
    end

    private def params_to_string(params : Hash(String, String))
      String.build do |str|
        params.each do |key, value|
          str << "#{key}=#{value}"
          str << ";" unless key == params.last_key?
        end
      end
    end

    def to_s
      prop_name = name
      prop_params = params
      prop_value = value

      String.build do |str|
        str << prop_name

        if prop_params.size > 0
          str << ";#{params_to_string(prop_params)}"
        end

        str << ":"

        if prop_value.is_a?(String)
          str << prop_value
        else
          str << params_to_string(prop_value)
        end
      end
    end

    private def self.parse_param(str : String)
      key_value = str.split('=')

      if key_value.size == 1
        return {nil, key_value[0].strip}
      else
        raise InvalidParameter.new("Invalid parameter string: '#{str}'") if key_value.size > 2

        return {key_value[0].strip, key_value[1].strip}
      end
    end

    private def self.parse_params(str : String)
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

    private def self.parse_name(str : String)
      name_params = str.split(';', 2)

      name = name_params[0].upcase.strip
      params = parse_params((name_params[1]? || "").strip)

      return {name, params}
    end

    def self.from_string(str : String)
      key_value = str.split(':')

      raise InvalidProperty.new("Invalid property string: '#{str}'") unless key_value.size == 2

      name, params = parse_name(key_value[0].strip)
      value = parse_params(key_value[1].strip)

      raise InvalidProperty.new("Invalid property key params: '#{key_value[0]}'") if params.is_a?(String)

      self.new(
        name: name,
        params: params,
        value: value,
      )
    end
  end
end
