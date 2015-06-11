# ResponsysApi [![Join the chat at https://gitter.im/dandemeyere/responsys-api](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/dandemeyere/responsys-api?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) ![Master branch build status](https://travis-ci.org/dandemeyere/responsys-api.svg?branch=master) [![Code Climate](https://codeclimate.com/github/dandemeyere/responsys-api/badges/gpa.svg)](https://codeclimate.com/github/dandemeyere/responsys-api)

A gem to help you communicate with the Responsys Interact **REST** APIs.

Tested with Ruby 1.9.3 and 2.1.2.

## Table of Contents

  - [Introduction](#introduction)
  - [Installation](#installation)
  - [Quick start](#quick-start)
    - [Configuration](#configuration)
    - [Example](#example)
  - [Resources](#resources)
    - [Profile List Table](#profile-list-table)
    - [Profile Extension Table](#profile-extension-table)
    - [Supplemental Table](#supplemental-table)
    - [Campaign](#campaign)
    - [Event](#event)
  - [Objects](#objects)
    - [CustomEvent](#customevent)
    - [EmailFormat](#emailformat)
    - [Field](#field)
    - [FieldType](#fieldtype)
    - [InteractObject](#interactobject)
    - [ListMergeRule](#listmergerule)
    - [Optional Data](#optional-data)
    - [QueryColumn](#querycolumn)
    - [Recipient](#recipient)
    - [RecipientData](#recipientdata)
    - [Record](#record)
    - [RecordData](#recorddata)
  - [Contributing](#contributing)

## Introduction
The gem is based on the official API documentation and tries to be as close as possible to the API's data model.

You'll find prototypes of the different methods below sorted by resource type. If you have any questions related to the usage of the GEM please open an [issue](https://github.com/dandemeyere/responsys-api/issues) or shout a message in our [Gitter chatroom](https://gitter.im/dandemeyere/responsys-api).

Another way of getting examples is to have a look at the spec files in `spec/`. All API methods have been tested with a testing scenario, you'll find the recorded calls in VCR cassettes under `spec/fixtures/vcr_cassettes`.

## Installation
Add this line to your application"s Gemfile and run `bundle install`:

    gem "responsys-api", "~> 0.3.0"

Or install it locally with:

    $ gem install responsys-api

## Quick start
### Configuration

```ruby
# Configure the gem (Rails initializer for example)
Responsys.configure do |config|
  config.settings = {
    username: "user@organization",
    password: "secured_password",
    login_endpoint: "https://loginX.responsys.net"
  }
end
```

### Examples
A first one using the `Member` wrapper.

```ruby
#!/usr/bin/env ruby

## Scenario : a new user signed up on your website, you want to register its information and subscribe his account for future emails.
## Details : we're adding a new record in the list @ "the_folder_containing_the_list/my_customers_list".
## We'll use the Member class which abstracts the API complexity by wrapping calls to the native APIs.

# Require the gem
require "responsys_api"

Responsys.configure do |config|
  config.settings = {
    username: "user@organization",
    password: "s3cur3d-p@ssw0rd",
    login_endpoint: "https://loginX.responsys.net"
  }
end

# A list is an "InteractObject": a file name in a folder.
list = Responsys::Api::Object::InteractObject.new("the_folder_containing_the_list", "my_customers_list")

# The Member (or "user" for the example) record to update
member = Responsys::Member.new("user@email.com")

# Add the user to the list if he/she is not already present.
unless member.present_in_list?(list)
  puts "Adding the user to the list."
  member.add_to_list(list)
else
  puts "The user is already in the list."
end

# Subscribe the user if he/she hasn't already subscribed.
unless member.subscribed?(list)
  puts "Subscribing the user to the list."
  member.subscribe(list)
else
  puts "The user already subscribed."
end

# Check the member has a subscribed status
puts member.subscribed?(list) ? "#{member.email} has subscribed to #{list.object_name}" : "An error ocurred"
```

A second example with Resources.
```ruby
#!/usr/bin/env ruby

## Scenario : a user changed his email address. We want to update his Responsys record and send him an email.
## Details : we will do the following steps
### 1. Retrieve the record based on the old email address
### 2. Merge the updated record to the list with the new address
### 3. Trigger an email campaign to confirm the change
## We'll use the Resource objects (List and Campaign).

OLD_EMAIL = "user1@email.com"
NEW_EMAIL = "user2@email.com"

# Require the gem
require "responsys_api"

Responsys.configure do |config|
  config.settings = {
    username: "user@organization",
    password: "s3cur3d-p@ssw0rd",
    login_endpoint: "https://loginX.responsys.net"
  }
end

client = Responsys::Api::Client.new
list = Responsys::Api::Object::InteractObject.new("the_folder_containing_the_list", "my_customers_list")

## 1. Let's retrieve a record given its email.
query_column = Responsys::Api::Object::QueryColumn.new("EMAIL_ADDRESS")
field_list = %w(RIID_ EMAIL_ADDRESS_ MOBILE_NUMBER_)
id_to_retrieve = OLD_EMAIL

retrieve_response = client.lists(list).retrieve_record(query_column, field_list, id_to_retrieve)

### Something went wrong! Find the "response.error_code" in the API doc to get more info.
return puts retrieve_response.error_title if retrieve_response.error?

## 2. We want to update the member's email address.
## Notice that we don't need to reformat the record data we retrieved.
## The data model is the same which makes it easy to reuse in a second call.
## We base the search on the RIID and not the email since we're passing the new one.
## For that the default match column is changed to the RIID column.
member_data = retrieve_response.data[0]
member_data[:EMAIL_ADDRESS_] = NEW_EMAIL
record_data = Responsys::Api::Object::RecordData.new([member_data])
list_merge_rule = Responsys::Api::Object::ListMergeRule.new(matchColumnName1: "RIID_")

merge_response = client.lists(list).merge_records(record_data, list_merge_rule)

### Something went wrong! Find the "merge_response.error_code" in the API doc to get more info.
return puts merge_response.error_title if merge_response.error?

## 3. Now we can send a text message
email_campaign = Responsys::Api::Campaign.new("updated-profile")
recipient = Responsys::Api::Object::Recipient.new(emailAddress: NEW_EMAIL, listName: list)
recipient_data = Responsys::Api::Object::RecipientData.new(recipient)

campaign_response = email_campaign.trigger_email([recipient_data])

### Something went wrong! Find the "campaign_response.error_code" in the API doc to get more info.
return puts campaign_response.error_title if campaign_response.error?
```

### Response object
Every time you make a call, you get a Response object which is a wrapper of a HTTPARTY response.

The different actions available:
```ruby
merge_response = client.lists(list).merge_records(record_data, list_merge_rule)

merge_response.success?
merge_response.data #JSON body with symbolized keys

merge_response.error?
merge_response.error_code
merge_response.error_title
merge_response.error_desc # error_code - error_title
merge_response.error_detail
merge_response.error_details

merge_response.httparty_response
```

## Resources
For the example, let's take the API definition to merge members to a list:
`POST /rest/api/v1/lists/<listName>`

All resources can be called using two ways:
1) The chain of methods defines what type of resource and what action you want to execute from the client object.
```ruby
client.lists(interact_object).retrieve_record(query_column, field_list, id_to_retrieve)
```

**OR**

2) You can use the direct Resource object. It's the same object you get when doing `client.lists(interact_object)`.
```ruby
Responsys::Api::List(interact_object).retrieve_record(query_column, field_list, id_to_retrieve)
```

Below are the method prototypes accessible. The params are explicitly named according to their object type.

**Important note:**
We *tried* to make it easily understandable from somebody reading the source code. If you end up hitting your head against a wall and you think some details here would have saved you time, please write a PR. It will benefit you and probably another person after you.

### Profile List Table
```ruby
# Get one record
client.lists(interact_object).retrieve_record(query_column, field_list, id_to_retrieve)

#Merge one or multiple records
client.lists(interact_object).merge_records(record_data, list_merge_rule = ListMergeRule.new)
```
### Profile Extension Table
Please note that a Profile Extension Table (PET) is always associated to a List. The interact object passed to `.lists` is a Profile List and the one passed to `.extensions` is the Profile Extension.

```ruby
# Create a PET
client.lists(interact_object).extensions(interact_object).create_table(fields)

# Get one record
client.lists(interact_object).extensions(interact_object).retrieve_records(query_column, field_list, id_to_retrieve)

# Merge one or multiple records
client.lists(interact_object).extensions(interact_object).merge_records(record_data, match_column, insert_on_no_match = false, update_on_match = "REPLACE_ALL")

# Delete one record
client.lists(interact_object).extensions(interact_object).delete_record(query_column, id_to_delete)
```

### Supplemental Table
A Table can or cannot be associated to either previous types' data

```ruby
# Create a table
client.tables(interact_object).create_table(fields, primary_keys)

# Merge one or multiple records
client.tables(interact_object).merge_records(record_data, match_column_names)

# Merge one or multiple records. The primary key column is used to match records and needs to be present in the record_data.
client.tables(interact_object).merge_records_with_pk(record_data, insert_on_no_match = true, update_on_match = "REPLACE_ALL")

# Get one record
client.tables(interact_object).retrieve_recod(query_attribute, field_list, id_to_retrieve)

# Delete one record
client.tables(interact_object).delete_record(query_attribute, id_to_retrieve)
```

### Campaign
```ruby
# Trigger an email campaign to a list of recipients.
client.campaigns(name).trigger_email(recipients)

# Merge the recipients to the List associated to the campaign first and then trigger the email campaign.
client.campaigns(name).merge_and_trigger_email(recipients, trigger_data, merge_rule = ListMergeRule.new)

# Merge the recipients to the List associated to the campaign first and then trigger the sms campaign.
client.campaigns(name).merge_and_trigger_sms(recipients, trigger_data, merge_rule = ListMergeRule.new)
```

### Event
```ruby
# Trigger an event given its name and an array of RecipientData.
client.events(custom_event).trigger(recipient_data_array)
```

## Objects
An Object is wrapping up the model representation. They're used by API methods to pass the data in a correct format to assure (as possible) that the params (query params or body content) are compliant to the official documentation.

We recommend going through the code and the objects used if you need to figure out how a method has been built.
On each Object you'll find a method called `.to_api` which serializes the object data to the API format.

### CustomEvent
Presents an event to the API, the name is the most important information here.

```ruby
Responsys::Api::Object::CustomEvent.new(event_name, event_id = nil, options = {})
```

### EmailFormat
Used by the Recipient object. Default is "NO_FORMAT" but the list of accepted values are as defined in the class: `%w(TEXT_FORMAT HTML_FORMAT NO_FORMAT MULTIPART_FORMAT)`

```ruby
Responsys::Api::Object::EmailFormat.new(email_format = "NO_FORMAT")
```

### Field
```ruby
Responsys::Api::Object.new(field_name, field_type, custom = false, data_extraction_key = false)
```
### FieldType
The accepted types are: `%w(STR500 STR4000 NUMBER TIMESTAMP INTEGER)`

```ruby
Responsys::Api::Object::FieldType.new(field_type)
```

### InteractObject
An InteractObject represents an objects stored in Responsys. An object is basically a file in a folder.
```ruby
Responsys::Api::Object::InteractObject.new(folder_name, object_name)
```

### ListMergeRule
With no params an instance will be pre-filled with the default values:
```ruby
insert_on_no_match = false
update_on_match = "REPLACE_ALL"
match_column_name1 = "EMAIL_ADDRESS_"
match_column_name2 = ""
match_column_name3 = ""
match_operator = "AND"
optin_value = "I"
optout_value = "O"
html_value = "H"
text_value = "T"
reject_record_if_channel_empty = ""
default_permission_status = "OPTOUT"
```

These values can be overridden in the options. i.e `options = { insert_on_no_match: true }`

```ruby
Responsys::Api::Object::ListMergeRule.new(options = {})
```

### Optional Data
```ruby
Responsys::Api::Object::OptionalData.new(name = "", value = "")
```

### QueryColumn
The column accepted are: `%w(RIID CUSTOMER_ID EMAIL_ADDRESS MOBILE_NUMBER)`

```ruby
Responsys::Api::Object::QueryColumn.new(query_column)
```

### Recipient
With no params an instance will be pre-filled with the default values:
```ruby
list_name = InteractObject.new("", "")
recipient_id = ""
customer_id = ""
email_address = ""
mobile_number = ""
email_format = EmailFormat.new
```

These values can be overridden in the options. i.e `options = { email_format: EmailFormat.new("HTML_FORMAT") }`

```ruby
Responsys::Api::Object::Recipient.new(options = {})
```

### RecipientData
```ruby
Responsys::Api::Object::RecipientData.new(recipient, optional_data = nil)
```

### Record
```ruby
Responsys::Api::Object::Record.new(field_values)
```

### RecordData
It represents a list of records that is going to be merged to a Table.

The `data` param is expected to be in that specific format:
```ruby
#Array of records
data = [
  #First record
  {
    field1: "value1",
    field2: "value2"
  },
  #Second record
  {
    field3: 123
  }
]
```

```ruby
Responsys::Api::Object::RecordData.new(data)
```

## Contributing
Highly appreciated!

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request