require "chjsonapi/version"
require 'curb'
require 'json'
require_relative 'chjsonapi/company'

# Base class for the CH Json Api
# Can be used to make direct API calls to Companies House domain
# The extended classes should implement specific methods to interface with api_call by providing the appropriate
# URL handles, querystrings and request types
class ChJsonApi

  #Call this before using any other method
  def self.init key
    @key = key
  end


  #Calls the Companies House API at the service specified by handler and with the optional parameters provided in query
  def self.api_call(handler, query)

    raise 'Uninitialised API. Call ChJsonApi.init(key) with your Companies House API key before running any requests' if !@key || @key.empty?

    query = normalise_query(query)

    result = execute_call(handler, query)

    return extract_response(result.body_str)

  end

  def self.execute_call(handler, query)
    result = Curl::Easy.new("https://api.companieshouse.gov.uk/#{handler}#{query}")

    result.username        = "#{@key}:"
    result.http_auth_types = :basic

    result.perform

    raise 'Too Many Requests' if result.response_code == 429

    result
  end

  def self.extract_response(response)
    return {} if response.empty?
    json       = JSON.parse(response)

    return json unless json['errors']

    raise json['errors'][0].map { |key, value| "#{key}=>#{value}" }.join(' ')

  end

  #TODO accept a key => value hash
  def self.normalise_query(query)
    if !query
      query = ''
    elsif query.kind_of? Array
      query = "?#{query.join '&'}"
    elsif !query.kind_of? String
      raise 'Query must be a string or an array with each element being a "key=value" string'
    end
    query
  end


end
