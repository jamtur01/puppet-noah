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
or override by settng the `NOAH_URL` environmental variable.

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

### The noah_put function

### Noah facts

The `noah_data` fact connects to the a Noah server and returns all of
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
