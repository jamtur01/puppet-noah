puppet-noah
===========

Description
-----------

A collection of Puppet bits and pieces for working with Noah (https://github.com/lusis/noah)

Requirements
------------

* `Noah`
* `puppet`

Installation
------------

Install `puppet-noah` as a module in your Puppet master's module
path.

Usage
-----

### ENC

The module contains an ENC (External Node Classifier) for Noah in
`bin/noah_enc`.  The ENC connecs to a Noah server and returns node
classification data.  It connects either to a hard-coded Noah URL
(defaulting to `http://localhost:9292`) which you can change in the ENC
or override by setting the `NOAH_URL` environmental variable.

The ENC queries the hosts defined on a Noah server via the [Host
API](https://github.com/lusis/Noah/wiki/Host-API) and returns a list of
classes based on services defined on that host, for example if the host
has the services `mysql` and `redis` then the ENC will return the
classes:

- mysql
- redis

See information on ENC's
[here](http://docs.puppetlabs.com/guides/external_nodes.html)

### The noah_get function

The `noah_get` function returns data from a Noah instance.  It can use
the Host, Service, Configuration and Application APIs to do this. It
requires the `rest-client` gem to work correctly:

    $ gem install rest-client

You can call the function like so by specifying the URL, the type of data,
and the name of the data item being returned:

    $foo = noah_get("http://localhost:9292", host, bar)

This will return data about the `bar` host in the form of a hash
and assign it to the variable `$foo`. The function accepts the following 
data types:

- host
- application
- service
- configuration

You can see the full list of applicable APIs
[here](https://github.com/lusis/Noah/wiki/Final-API-1.0).

### The noah_put function

The `noah_put` function sends data to a Noah server. It can use the
Host, Service, Configuration and Application APIs to do this (although
its use of the Service and Configuration API is currently somewhat limited). It
requires the `rest-client` gem to work correctly:

    $ gem install rest-client

You can call the function like so by specifying the URL, the type of data,
and the data being sent:

    noah_put("http://localhost:9292", host, up)

This will create a host named using the value of the `fqdn` fact with a 
status of `up` (valid statuses are `up` or `down`).  

You can also create a new application:

    noah_put("http://localhost:9292", application, foo)

This will create a new application called `foo` on the Noah server.

You can create a new service:

    noah_put("http://localhost:9292", service, mysql)

This will create a new service called `mysql` with a status of `up`. As
yet you can't control the service or host status of the service being
created.

Or you can create configuration items:

    noah_put("http://localhost:9292", configuration, bar)

This creates a configuration item called `bar` with a format of `string`
and a value of `bar`.  Further work is needed to extend this to support
the full set of naming and data types avaialble. Consider this an MVP.

### Noah facts

The `noah_data` fact connects to the Noah server and returns all of
the configurations items via the [Configuration
API](https://github.com/lusis/Noah/wiki/Configuration-API) as fact
values.  As Facter currently only supports strings as fact values this
means some data isn't yet in an ideal format.

Author
------

James Turnbull <james@lovedthanlost.net>

License
-------

    Author:: James Turnbull (<james@lovedthanlost.net>)
    Copyright:: Copyright (c) 2011 James Turnbull
    License:: Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
