# ResponsysApi

A gem to help you communicate to the Responsys Interact SOAP API.

## Installation

Add this line to your application"s Gemfile:

    gem "responsys-api"

Or install it yourself as:

    $ gem install responsys-api

## Usage
### Configuration 

```ruby
# Configure ResponsysApi in your initializers (config/initializers/responsys_api.rb):
Responsys.configure do |config|
  config.settings = {
    :username => "your_responsys_username",
    :password => "your_responsys_password",
    :wsdl => "https://ws2.responsys.net/webservices/wsdl/ResponsysWS_Level1.wsdl"
  }
end
```
### Example
```ruby
## Scenario : subscribe a user to a newsletter
## Details : the user exists in the list of your users in Responsys @ "the_folder_containing_the_list/my_customers_list". He just decided to subscribe so let's update his status !

#!/usr/bin/env ruby

## Scenario : subscribe a user to a newsletter
## Details : the user exists in the list of your users in Responsys @ "the_folder_containing_the_list/my_customers_list". He just decided to subscribe so let's update his status !

# Require the gem
require 'responsys_api'

Responsys.configure do |config|
  config.settings = {
    :username => "your_responsys_username",
    :password => "your_responsys_password",
    :wsdl => "https://ws2.responsys.net/webservices/wsdl/ResponsysWS_Level1.wsdl"
  }
end

# A list is an "InteractObject" according to the official API documentation
list = Responsys::Api::Object::InteractObject.new("demo_folder2", "my_customers")

# The Member (or "user" for the example) record to update
member = Responsys::Member.new('user@email.com')

# Subscribe the user if he hasn't subscribed yet
unless member.subscribed?(list)
  member.subscribe(list)
else
  puts "The user already subscribed"
end

# Check the member has a subscribed status
puts member.subscribed?(list) ? "#{member.email} has subscribed to #{list.objectName}" : "An error happened"
```
### Session
The API client used by the gem logs in as soon as a the first method is called. The same session is used as it is valid. If you want to close the API session you can manually call the log out action :

```ruby
Responsys::Api::Client.instance.logout
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## To Do
* Add thorough tests with properly mocked out API responses
* Build out API functionality
  * Member profiles
  * Transactional email firing
  * List management
  * Folder management
  * Batch member profile updates
