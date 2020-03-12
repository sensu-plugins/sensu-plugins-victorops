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
bin/handler-victorops.rb --help
Usage: bin/handler-victorops.rb (options)
    -a, --api-url APIURL             VictorOps API URL without routing key. Or use envvar VICTOROPS_API_URL.
        --dryrun                     Report settings, and take no action
        --map-go-event-into-ruby     Enable Sensu Go to Sensu Ruby event mapping. Alternatively set envvar SENSU_MAP_GO_EVENT_INTO_RUBY=1.
    -r, --routingkey KEY             Routing key. Or use envvar VICTOROPS_ROUTING_KEY.

```

### Sensu Go Enabled

Plugin versions 2.0 and higher are now Sensu Go enabled. You can map Sensu Go events into Sensu Classic events by using the flag `--map_go_event_into_ruby` as part of your command. Now that Sensu Classic is now EOL, a future version of this plugin will drop support for Sensu Classic and will assume Sensu Go event structuring.

Here is an example Sensu Go handler resource definition for reference.  Please note, this plugin's Sensu Asset should be used in conjunction with the Sensu Ruby runtime asset.

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
  - VICTOROPS_API_URL=https://alert.victorops.com/integrations/generic/01234567/alert/0123456789101112
  - VICTOROPS_ROUTING_KEY=testing
  runtime_assets:
  - sensu-plugins-victorops
  - sensu-ruby-runtime
```

You'll note that the plugin supports environment variables for both routing key and api url. You can define this in the Sensu Go handler resource definition.  You can support multiple VictorOps accounts by having a different handler definition, each with appropriate environment variables defined.


# Sensu Classic Support
Here is an example handlers configuration for Sensu Classic. Please note, Sensu Classic has now reached EOL, and support for Sensu Classic events is planned to be removed in a future version of this plugin. 

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

If you have multiple VictorOps accounts and need to route alerts to different endpoints, specifying the handler name in the config is necessary otherwise, the handler will attempt to route to the default `victorops`.  You will therefore need to use the `-name` switch to specify the API endpoint as noted below.

```
"victorops_enpoint1": {
      "type": "pipe",
      "command": "/opt/sensu/embedded/bin/handler-victorops.rb -name victorops_endpoint1"
    },
```

## Installation

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)
