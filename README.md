# CHJsonAPI - Companies House JSON Api Gem

Ruby Gem to help make requests to <a href="https://developer.companieshouse.gov.uk/api/docs/" title="Companies House">Companies House</a> public API.

Version 0.1.0:
 - Created Company profile API call
 - Created Company registered office API call
 - Created Company officers API call


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ch_json_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ch_json_api

## Usage

###Require

Add

```ruby
    require 'ch_json_api'
```

To files where the Gem will be used.

###Companies House API Key

To use Companies House API, you need to configure an API Key, which you can obtain from <a href="https://developer.companieshouse.gov.uk/api/docs/index/gettingStarted/apikey_authorisation.html" title="Companies House Authentication API key"> their website</a>.

Before making any requests, you need to initialise the Gem by calling

```ruby
    CHJsonAPI.init "YOUR_API_KEY"
```

###Querying for <a href="https://developer.companieshouse.gov.uk/api/docs/company/company_number/company_number.html" title="Company Profile">Company profile</a>

```ruby
    json = CHJsonAPI::Company.profile 'COMPANY_NUMBER'
    puts json['company_number']
```

###Querying for <a href="https://developer.companieshouse.gov.uk/api/docs/company/company_number/registered-office-address/registered-office-address.html" title="Company Registered Office Address">Company Registered Office Address</a>

```ruby
    json = CHJsonAPI::Company.registered_office 'COMPANY_NUMBER'
    puts json['locality']
```

###Querying for <a href="https://developer.companieshouse.gov.uk/api/docs/company/company_number/officers/officers.html" title="Company Officers List">Company Officers List</a>

```ruby
    json = CHJsonAPI::Company.officers 'COMPANY_NUMBER'
    puts json['items'][0]['address']['premises']
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

