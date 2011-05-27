require 'rubygems'
require 'json'
require 'uri'
require 'net/http'

NOAH_URL = "http://localhost:9292"

url = ENV['NOAH_URL'] || NOAH_URL
uri = URI.parse("#{url}/configurations/")

begin
  request = Net::HTTP::Get.new(uri.path, initheader = {'Accept' => 'text/json'})
  http = Net::HTTP.new(uri.host, uri.port)
  result = http.start {|http| http.request(request)}
  case result
  when Net::HTTPSuccess
    res = JSON.parse(result.body)
    res.each { |k,v| Facter.add(k) { setcode { v["body"] } } }
  else
    Facter.debug "Error: #{result.code} #{result.message.strip} for #{url}."
  end
rescue => e
    Facter.debug "Unable to connect to Redis - #{e}"
end
