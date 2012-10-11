Puppet::Parser::Functions::newfunction(:noah_get, :type => :rvalue, :doc => "
Returns values from Noah. Takes a Noah URL, request type and data and returns data from a running Noah instance:

    noah_get($noah_url, $type, $data)

Where `$noah_url` is the URL of a valid Noah server, `$type` is one of application, host, configuration or service and `$data` is the name of the data type to return.

    noah_get('http://localhost:9292', host, $hostname)

This will retrieve the host information for the `$hostname` variable from the Noah server at `http://localhost:9292`.  
") do |args|

  request_types = ["host", "service", "application", "configuration"]
  begin
    require 'rest-client'
    require 'uri'
  rescue LoadError => detail
    Puppet.info "noah_get(): You need to install the rest-client gem to use the noah_get function"
  end

  raise ArgumentError, ("noah_get(): Wrong number of arguments (#{args.length}; must be 3)") if args.length != 3

  noah_url, type, data = URI.parse(args[0]), args[1], args[2]

  raise ArgumentError, ("noah_get(): Request type #{type} invalid. Valid request types are #{request_types.join(',')}") unless request_types.include?(type)

  case type
  when "host"
    resource = "/hosts/#{data}"
  when "application"
    resource = "/applications/#{data}"
  when "service"
    resource = "/services/#{data}"
  when "configuration"
    resource = "/configurations/#{data}"
  end

  RestClient.get("#{noah_url}#{resource}"){ |response, request, result, &block|
    case response.code
    when 200
      Puppet.debug "noah_get(): Returned #{type} #{data} from Noah server #{noah_url}"
      output = JSON.parse(response)
      if type == "service"
        output.values.each do |hosts|
          hosts.values.each do |host|
            begin
              host['data'] = JSON.parse(host['data'])
            rescue JSON::ParserError => e
              # Leave non-json data as is
            end
          end
        end
      end
      output
    when 404
      Puppet.info "noah_get(): No #{type} #{data} available on Noah server #{noah_url}"
    when 500
      Puppet.info "noah_get(): Noah server #{noah_url} returned error"
    else
      Puppet.err "noah_get(): Query failed #{request}, #{result}"
    end
  }
end
