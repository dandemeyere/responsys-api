# ResponsysApi

A gem to help you communicate to the Responsys Interact SOAP API.

## Installation

Add this line to your application's Gemfile:

    gem 'responsys-api'

Or install it yourself as:

    $ gem install responsys-api

## Usage

```ruby
# Configure ResponsysApi in your initializers (config/initializers/responsys_api.rb):
ResponsysApi.configure do |config|
  config.settings = {
    username: 'your_responsys_username',
    password: 'your_responsys_password',
    wsdl: 'https://ws2.responsys.net/webservices/wsdl/ResponsysWS_Level1.wsdl'
  }
end

# Example usage
ResponsysApi.new.api_method("list_folders")
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## To Do
* Add thorough tests with properly mocked out API responses
* Build out API functionality
  * Member subscribe/unsubscribe
  * Member profiles
  * Transactional email firing
  * List management
  * Folder management
  * Batch member profile updates
  
