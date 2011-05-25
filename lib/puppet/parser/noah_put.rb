Puppet::Parser::Functions::newfunction(:noah_put, :type => :rvalue, :doc => "
Puts values into Noah. Takes a Noah URL, request type and data and puts data into a running Noah instance:

    noah_put($noah_url, $type, $data)

Where `$noah_url` is the URL of a valid Noah server, `$type` is one of application, host, configuration or service and `$data` is the data to send to the 
server.

    noah_put('http://localhost:9292', host, 'up')

This will create a host using the `fqdn` fact as the hostname with a status of `up` (valid statuses are `up` or `down`) to the Noah server 
at `http://localhost:9292`.  You can similarly create applications, services and configuration items.
") do |args|

  request_types = ["host", "service", "application", "configuration"]
  begin
    require 'rest-client'
    require 'uri'
  rescue LoadError => detail
    Puppet.info "noah_put(): You need to install the rest-client gem to use the noah_put function"
  end

  raise ArgumentError, ("noah_put(): Wrong number of arguments (#{args.length}; must be 3)") if args.length != 3

  noah_url, type, data = URI.parse(args[0]), args[1], args[2]

  raise ArgumentError, ("noah_put(): Request type #{type} invalid. Valid request types are #{request_types.join(',')}") unless request_types.include?(type)

  case type
  when "host"
    resource = "/hosts/#{lookupvar('fqdn')}"
    status = [ "up", "down"]
    raise ArgumentError, ("noah_put(): Host status must be 'up' or 'down'") unless status.include?(data)
    payload = { "status" => "#{data}" }
  when "application"
    resource = "/applications/#{data}"
    payload = { "name" => "#{data}" }
  when "service"
    resource = "/services/#{data}/#{lookupvar('fqdn')}"
    payload = { "status" => "up", "host_status" => "up" }
  when "configuration"
    resource = "/configurations/#{data}"
    payload = { "format" => "string", "body" => "#{data}" }
  end

  RestClient.put("#{noah_url}#{resource}", payload.to_json){ |response, request, result, &block|
    case response.code
    when 200
      Puppet.info "noah_put(): Posted #{type} #{data} to Noah server #{noah_url}"
    when 404
      Puppet.info "noah_put(): No #{type} #{data} available on Noah server #{noah_url}"
    else
      Puppet.err "noah_put(): Query failed #{request}, #{result}"
    end
  }
end
