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
  def self.init(key)
    if key.is_a? Array
      @key = key
    elsif key.is_a? String
      @key = [key]
    else
      raise 'Invalid Key Type. String or Array of Strings accepted only.'
    end

    @index = 0
    @tries = 0
    true
  end


  #Calls the Companies House API at the service specified by handler and with the optional parameters provided in query
  def self.api_call(handler, query)

    raise 'Uninitialised API. Call ChJsonApi.init(key) with your Companies House API key before running any requests' if !@key || @key.empty?

    query = normalise_query(query)

    result = execute_call(handler, query)

    return extract_response(result.body_str)

  end

  def self.execute_call(handler, query)
    @result ||= Curl::Easy.new

    @result.url = "https://api.companieshouse.gov.uk/#{handler}#{query}"

    @result.username        = "#{choose_key}:"
    @result.http_auth_types = :basic

    @result.perform

    code = @result.response_code

    #Detect any errors.
    #If found, treat them and retry the function
    #This will
    if code == 401
      handle_invalid_key(@result)
      @result = execute_call(handler, query)
    end

    if code == 429
      handle_too_many_requests(@result)
      @result = execute_call(handler, query)
    end

    ##All ok, reset the "tries" counter and return the result
    @tries = 0
    @result
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


  private
  def self.choose_key
    if @key.length > 0
      @key[@index % @key.count]
    else
      raise 'No valid keys!'
    end
  end

  def self.try_another_key
    #try next key and increment the number of tries so far
    #Increment to next key
    @index ||= 0
    @index += 1

    #Increase number of tries
    @tries ||= 0
    @tries += 1

    #If we have tried all keys, return false
    continue?
  end

  def self.handle_invalid_key(result)
    #Removes key from the array
    @key.delete @key[@index]
    if continue?
      @tries += 1
      return true
    else
      raise RuntimeError.new({message: 'Unauthorized. Please check your API keys.', request: result})
    end
  end

  def self.continue?
    #Check if we tried all keys.
    @tries <= @key.count
  end

  def self.handle_too_many_requests(result)
    #Too Many Requests, just switch to next key
    unless try_another_key
      raise RuntimeError.new({message: 'Too Many Requests', request: result})
    end
    true
  end

end
