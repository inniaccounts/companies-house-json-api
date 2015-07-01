require "ch_json_api/version"
require 'curb'
require 'json'
require_relative 'ch_json_api/company'

class CHJsonAPI
  # curl -XGET -u ***REMOVED***: https://api.companieshouse.gov.uk/company/00000006


  def self.init key
    @key = key
  end


  def self.api_call(handler, type)
    raise "Uninitialised API. Call ChJsonApi.init(key) with your Companies House API key before running any requests" if @key == nil || @key.empty?

    c = Curl::Easy.new("https://api.companieshouse.gov.uk/#{handler}")

    c.username = "#{@key}:"
    c.http_auth_types = :basic

    #p "curl -#{type} -u #{c.username} #{c.url}"
    c.perform

    json = JSON.parse(c.body_str)
    if json['errors']
      {}
    else
      json
    end
  end



end
