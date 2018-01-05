## Sensu-Plugins-victorops

[ ![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-victorops.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-victorops)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-victorops.svg)](http://badge.fury.io/rb/sensu-plugins-victorops)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-victorops/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-victorops)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-victorops/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-victorops)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-victorops.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-victorops)

## Functionality

## Files
 * bin/handler-victorops.rb

## Usage

```
{
  "victorops": {
    "api_url": "YOUR_API_URL_WHITOUT_ROUTING_KEY",
    "routing_key": "everyone"
  }
}
```
## Installation

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)


## Notes
If you have multiple VictorOps accounts and need to route alerts to different endpoints, specifying the handler name in the config is necessary otherwise, the handler will attempt to route to the default `victorops`.  You will therefore need to use the `-name` switch to specify the API endpoint as noted below.

```
"victorops_enpoint1": {
      "type": "pipe",
      "command": "/opt/sensu/embedded/bin/handler-victorops.rb -name victorops_endpoint1"
    },
```
  
