# ChJsonApi <br> Companies House JSON API Gem

Ruby Gem to help make requests to <a href="https://developer.companieshouse.gov.uk/api/docs/" title="Companies House">Companies House</a> public API.

[![Gem Version](https://badge.fury.io/rb/chjsonapi.svg)](https://badge.fury.io/rb/chjsonapi)

Version 0.3.2
 - Adding support for multiple keys.
 
Version 0.3.1
 - Changing exception thrown on Too Many Requests

Version 0.3.0
 - Handling "Too Many Requests" message (CH says that happens when 600 requests are sent in 5 minutes. Then the next requests have the HTTP status header of 429 Too Many Requests)

## API
Companies House JSON API is still in beta, which means that it might eventually change. Until a stable version is launched, this gem is considered on "version 0." 


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chjsonapi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chjsonapi

## Usage

###Require

Add this line to files where the Gem will be used.

```ruby
require 'chjsonapi'
```

###Companies House API Key

To use Companies House API, you need to configure an API Key, which you can obtain from <a target="_blank" href="https://developer.companieshouse.gov.uk/api/docs/index/gettingStarted/apikey_authorisation.html" title="Companies House Authentication API key"> their website</a>.

Before making any requests, you need to initialise the Gem by calling

```ruby
ChJsonApi.init "YOUR_API_KEY"
```

Or, if you have more than one key available, you can initialise the Gem with an array of keys by calling

```ruby
ChJsonApi.init ["FIRST_KEY", "SECOND_KEY", ... , "LAST_KEY"]
```

###Querying for <a target="_blank" href="https://developer.companieshouse.gov.uk/api/docs/company/company_number/readCompanyProfile.html" title="Company Profile">Company profile</a>

```ruby
json = ChJsonApi::Company.profile company_number:'COMPANY_NUMBER'
puts json['company_number']
```

###Querying for <a target="_blank" href="https://developer.companieshouse.gov.uk/api/docs/company/company_number/registered-office-address/readRegisteredOfficeAddress.html" title="Company Registered Office Address">Company Registered Office Address</a>

```ruby
json = ChJsonApi::Company.registered_office company_number:'COMPANY_NUMBER'
puts json['locality']
```

###Querying for <a target="_blank" href="https://developer.companieshouse.gov.uk/api/docs/company/company_number/officers/officerList.html" title="Company Officers List">Company Officers List</a>

```ruby
json = ChJsonApi::Company.officers company_number:'COMPANY_NUMBER'
puts json['items'][0]['address']['premises']
```

Or any of the optional parameters

```ruby
json = ChJsonApi::Company.officers company_number:'COMPANY_NUMBER',items_per_page:X,start_index:X,order_by:'ORDER_BY'
puts json['items'][0]['address']['premises']
```


###Querying for a specific <a target="_blank" href="https://developer.companieshouse.gov.uk/api/docs/company/company_number/filing-history/transaction_id/getFilingHistoryItem.html" title="Filing History Item">Filing History Item</a>

```ruby
json = ChJsonApi::Company.filing_item company_number:'COMPANY_NUMBER',items_per_page:X,start_index:X,order_by:'ORDER_BY'
puts json['transaction_id']
```


###Querying for <a target="_blank" href="https://developer.companieshouse.gov.uk/api/docs/company/company_number/filing-history/getFilingHistoryList.html" title="Filing History List">Filing History</a>

```ruby
json = ChJsonApi::Company.filing_list company_number:'COMPANY_NUMBER',items_per_page:X,start_index:X,order_by:'ORDER_BY'
puts json['transaction_id']
```

Or any of the optional parameters

```ruby
json = ChJsonApi::Company.officers company_number:'COMPANY_NUMBER',items_per_page:X,start_index:X,category:'ORDER_BY'
puts json['transaction_id']
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

