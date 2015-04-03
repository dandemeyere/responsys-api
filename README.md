# ResponsysApi [![Join the chat at https://gitter.im/dandemeyere/responsys-api](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/dandemeyere/responsys-api?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) ![Master branch build status](https://travis-ci.org/dandemeyere/responsys-api.svg?branch=master) [![Code Climate](https://codeclimate.com/github/dandemeyere/responsys-api/badges/gpa.svg)](https://codeclimate.com/github/dandemeyere/responsys-api)

A gem to help you communicate to the Responsys Interact SOAP API. Currently working of Responsys Interact version 6.20.

## Documentation

Have a look at our [wiki](https://github.com/dandemeyere/responsys-api/wiki) to understand the functionality this gem offers, how  to use it, and some tips to help you avoid the same mistakes we ran into! If you have any questions or if you want to report a bug please create an [issue](https://github.com/dandemeyere/responsys-api/issues).

## Installation

Add this line to your application"s Gemfile:

    gem "responsys-api", "~> 0.0.8"

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
    debug: false,
    ssl_version: :TLSv1
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

# Add the user to the list if he/she is not already present.
unless member.present_in_list?(list)
  puts "New user add to list functionality."
  member.add_to_list(list)
else
  puts "The user is in the list"
end

# Subscribe the user if he/she hasn't already subscribed.
unless member.subscribed?(list)
  puts "Subscribing the user to the list"
  member.subscribe(list)
else
  puts "The user already subscribed"
end

# Check the member has a subscribed status
puts member.subscribed?(list) ? "#{member.email} has subscribed to #{list.object_name}" : "An error ocurred"
```
### Session
The gem's API client authenticates as soon as the first method is called. The same session is used as it is still valid. If you want to close the API session, you can do so manually with the log out action:

```ruby
Responsys::Api::Client.instance.logout
```

###Notes

####Invalid email format
If you try to call the API on a user that has an invalid email address, the API and Gem will reply with this message:
```ruby
{
	:status=>"ok",
	:result=>{
		:recipient_id=>"-1",
		:error_message=>"Record 0 = BAD EMAIL FORMAT"
	}
}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## To Do
* Supplemental Tables
  * CRUD operations (create new key/value, update value by key, delete key/value by key)
* Batch member profile updates
* CED SFTP File Syncing
