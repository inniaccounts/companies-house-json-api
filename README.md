# ChJsonApi <br> Companies House JSON API Gem

Ruby Gem to help make requests to <a href="https://developer.companieshouse.gov.uk/api/docs/" title="Companies House">Companies House</a> public API.

Version 0.2.2:
 - Refactoring
 - Changing gem name

Version 0.2.1:
 - Removing CH Api key
 - Changing version on Gemspec file

Version 0.2.0:
 - Changed basic API. No longer accepts a single String as parameter. A named hash must always be provided to the functions.
 - Added optional parameters to the officers request.
 - Created Company Filing
 

Version 0.1.0:
 - Created Company profile API call
 - Created Company registered office API call
 - Created Company officers API call


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

