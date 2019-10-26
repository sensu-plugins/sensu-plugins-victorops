## Sensu-Plugins-victorops

[ ![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-victorops.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-victorops)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-victorops.svg)](http://badge.fury.io/rb/sensu-plugins-victorops)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-victorops/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-victorops)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-victorops/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-victorops)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-victorops.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-victorops)
[![Sensu Bonsai Asset](https://img.shields.io/badge/Bonsai-Download%20Me-brightgreen.svg?colorB=89C967&logo=sensu)](https://bonsai.sensu.io/assets/sensu-plugins/sensu-plugins-victorops)

## Functionality

## Files
 * bin/handler-victorops.rb

## Usage

```
{
  "victorops": {
    "api_url": "YOUR_API_URL_WHITOUT_ROUTING_KEY",
    "routing_key": "everyone"
  },
  "handlers": {
    "victorops": {
      "type": "pipe",
      "command": "handler-victorops.rb"
    }
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

### Sensu Go Enabled

This plugin is also Sensu Go enabled. You can map events into ruby by using the flag `--map_go_event_into_ruby` as part of your command. Practically, this might look like:

```
---
type: Handler
spec:
  metadata:
    name: victorops
    namespace: default
    labels: 
    annotations: 
  type: pipe
  command: handler-victorops.rb --map_go_event_into_ruby
  timeout: 0
  handlers: []
  filters:
  - is_incident
  env_vars:
  - KEEPALIVE_SLACK_WEBHOOK=https://alert.victorops.com/integrations/generic/01234567/alert/0123456789101112
  - VICTOROPS_ROUTING_KEY=testing
  runtime_assets:
  - sensu-plugins-victorops
  - sensu-ruby-runtime
```

You'll also note that the plugin also supports environment variables. You can use these without having to have a file locally to load in those values. 
