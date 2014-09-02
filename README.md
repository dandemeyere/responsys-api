# ResponsysApi

A gem to help you communicate to the Responsys Interact SOAP API.

## Documentation

Have a look at the [wiki](https://github.com/dandemeyere/responsys-api/wiki) to understand how it works as well as special tips specially prepared for you ! If you have any questions or if you want to report a bug please create an [issue](https://github.com/dandemeyere/responsys-api/issues).

## Installation

Add this line to your application"s Gemfile:

    gem "responsys-api", "~> 0.0.4"

Or install it locally with:

    $ gem install responsys-api

## Usage
### Configuration 

```ruby
# Configure ResponsysApi in your initializers (config/initializers/responsys_api.rb):
Responsys.configure do |config|
  config.settings = {
    username: "your_responsys_username",
    password: "your_responsys_password",
    wsdl: "https://wsXXXX.responsys.net/webservices/wsdl/ResponsysWS_Level1.wsdl",
    debug: false
  }
end
```

Note that the debug option is optional and is set to false by default.

### Example
```ruby
#!/usr/bin/env ruby

## Scenario : subscribe a user to a newsletter
## Details : the user exists in the list of your users in Responsys @ "the_folder_containing_the_list/my_customers_list". He just decided to subscribe so let's update his status !

# Require the gem
require 'responsys_api'

Responsys.configure do |config|
  config.settings = {
    username: "your_responsys_username",
    password: "your_responsys_password",
    wsdl: "https://wsXXXX.responsys.net/webservices/wsdl/ResponsysWS_Level1.wsdl"
  }
end

# A list is an "InteractObject" according to the official API documentation
list = Responsys::Api::Object::InteractObject.new("the_folder_containing_the_list", "my_customers_list")

# The Member (or "user" for the example) record to update
member = Responsys::Member.new('user@email.com')

# Add the user to the list if he is not present.
unless member.present_in_list?(list) 
  puts "New user. Let's add it"
  member.add_to_list(list)
else
  puts "The user is in the list"
end

# Subscribe the user if he hasn't subscribed yet
unless member.subscribed?(list)
  puts "Subscribing the user to the list"
  member.subscribe(list)
else
  puts "The user already subscribed"
end

# Check the member has a subscribed status
puts member.subscribed?(list) ? "#{member.email} has subscribed to #{list.object_name}" : "An error happened"
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
  * Member profile extension
    * CRUD operations (create new key/value, update value by key, delete key/value by key)
  * Tables
    * CRUD operations (create new key/value, update value by key, delete key/value by key)
  * Batch member profile updates
