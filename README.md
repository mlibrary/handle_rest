# Handle 

Ruby interface to the [CNRI Handle System](http://handle.net/) REST API.  The
CNRI Handle Server provides a DNS-like method of providing persistent URLs to
resources.  The REST API is available from Handle Server 8.0 onwards. The
[HANDLE.NET Technical Manual](http://www.handle.net/tech_manual/HN_Tech_Manual_8.pdf) 
documents the REST API.

## Installation

Add this line to your application's Gemfile:

    gem 'handle_rest'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install handle_rest

## Usage

```ruby
require 'handle_rest'

# Set up the connection
service = HandleService.new(url: 'https://hdl.example.com:8000/api/handles',
                            user: '300:0.NA/admin.handle', 
                            password: 'secret')

# Create a simple URL handle
handle = Handle.new('9999/myhandle', url: 'http://example.com/')
service.create(handle)

# Get a handle
handle = service.get('9999/myhandle')
puts handle.url

# Delete a handle
service.delete('9999/myhandle')
```

## Running the integration tests

By default rspec will not run the integration tests, because they require a test handle server.
If you have a test handle server available, set the following environment variables:

```bash
# Set this environment variable to run the integration tests
INTEGRATION=1
# Set to the URL for the test handle server
HS_REST_URL=https://localhost:8000/api/handles/
# Set to a homed prefix for the test handle server (including the trailing '/')
HS_PREFIX=9999/
# Set to appropriate credentials for a user that can create handles in the 
# given prefix. Currently, the API only supports password ('secret key')
# authentication.
HS_USER=300:9999/ADMIN
HS_SECKEY=password
# Set to 0 if the test handle server has a self-signed or otherwise invalid SSL
# certificate
HS_SSL_VERIFY=0

export INTEGRATION HS_REST_URL HS_USER HS_SECKEY HS_SSL_VERIFY
```

### Setting up a test handle server

* Ensure java is installed
* Download and unpack [the handle server](http://handle.net/download_hnr.html)
* Follow the installation instructions from Section 3 "Installing and Running a Handle Server" from [the technical manual](http://www.handle.net/tech_manual/HN_Tech_Manual_8.pdf) up through section 3.4 "Running the Setup Program". Do NOT try to home a prefix with the handle admin tool (section 3.5), since this is only a test server.

Next, manually home a test prefix and add an administrative user. This example
uses `9999` as the prefix and `9999/ADMIN` as the administrative user, but you
can use whatever you want so long as it's consistent.

* Set `server_admins` and `replication_admins` in `config.dct` to `300:9999/ADMIN`
* Set `auto_homed_prefixes` in `config.dct` to `0.NA/9999`
* Run `hdl-dbtool $HS_HOME` 
* Add a homed test prefix, `0.NA/9999`
* Create a handle for an administrative user, `9999/ADMIN`, with values as follows:
  * index 100, type `HS_ADMIN`, data type admin info, with admin ID handle `9999/ADMIN`, admin ID index 200, and all permissions selected
  * index 200, type `HS_VLIST`, data type reference list, and one value: handle `9999/ADMIN`, index `300`
  * index 300, type `HS_SECKEY`, data type string, set to the password you want to use for the administrative user (warning: this is stored in plain text in the database)
* Start the handle server: `hdl-server $HS_HOME`


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
