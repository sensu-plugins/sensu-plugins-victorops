#!/usr/bin/env ruby
# frozen_string_literal: true

# This handler creates and resolves victorops incidents
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.
#
# arguments:
#   - settingsname: Sensu settings name, defaults to victorops
#   - routingkey: VictorOps routing key
#
# NOTE: This plugin is Sensu Go enabled. To use this plugin with Sensu Go, add --map_go_event_into_ruby as part of the command.
#  Example:
#    handler-victorops.rb --map_go_event_into_ruby

require 'sensu-handler'
require 'uri'
require 'net/http'
require 'net/https'
require 'json'

class VictorOps < Sensu::Handler
  option :api_url,
         description: 'VictorOps API URL without routing key. Or use envvar VICTOROPS_API_URL.',
         short: '-a APIURL',
         long: '--api-url APIURL',
         default: nil

  option :settingsname,
         description: 'Sensu settings name',
         short: '-n NAME',
         long: '--name NAME',
         default: 'victorops'

  option :routing_key,
         description: 'Routing key. Or use envvar VICTOROPS_ROUTING_KEY.',
         short: '-r KEY',
         long: '--routingkey KEY',
         default: nil

  option :dryrun,
         description: 'Report settings, and take no action',
         long: '--dryrun',
         boolean: true,
         default: false

  def set_api_url
    # validate that we have an api url - environment variables take precedence
    api_url = ENV['VICTOROPS_API_URL']
    api_url = config[:api_url] if api_url.nil?
    if api_url.nil?
      # validate that we have a settings name
      if defined?(settings[config[:settingsname]]) && !settings[config[:settingsname]].nil?
        api_url = settings[config[:settingsname]]['api_url']
      else
        raise "victorops.rb sensu setting '#{config[:settingsname]}' not found or empty" unless config[:dryrun]
      end
    end
    return api_url if defined?(api_url) && !api_url.nil?

    raise "victorops.rb sensu setting '#{config[:settingsname]}.api_url' not found or empty" unless config[:dryrun]
  end

  def set_routing_key
    # validate that we have a routing key - environment variables take precedence
    routing_key = ENV['VICTOROPS_ROUTING_KEY']
    routing_key = config[:routing_key] if routing_key.nil?
    if routing_key.nil?
      # validate that we have a settings name in the config
      if defined?(settings[config[:settingsname]]) && !settings[config[:settingsname]].nil?
        routing_key = settings[config[:settingsname]]['routing_key']
      else
        raise "victorops.rb sensu setting '#{config[:settingsname]}' not found or empty" unless config[:dryrun]
      end
    end
    return routing_key if defined?(routing_key) && !routing_key.nil?

    raise 'routing key not defined, should be in Sensu settings or passed via command arguments' unless config[:dryrun]
  end

  def dry_run(api_url, routing_key, uri, payload)
    return unless config[:dryrun]

    puts 'Dryrun: reporting settings and exiting'
    puts "  option settingsname set: #{config[:settingsname]}"
    puts 'Determing API_URL to use:'
    if ENV['VICTOROPS_API_URL']
      puts "  envvar VICTOROPS_API_URL set: #{ENV['VICTOROPS_API_URL']}"
    else
      puts '  envvar VICTOROPS_API_URL not set'
    end
    if config[:api_url]
      puts "  option api-url set: #{config[:api_url]}"
    else
      puts '  option api-url not set'
    end
    if settings[config[:settingsname]]
      puts "  settings api_url set: #{settings[config[:settingsname]]['api_url']}" if settings[config[:settingsname]]['api_url']
    else
      puts "  setting name: #{config[:settingsname]} does not exist"
    end
    puts "  using: #{api_url}"
    puts 'Determing ROUTING_KEY to use:'
    if ENV['VICTOROPS_ROUTING_KEY']
      puts "  envvar VICTOROPS_ROUTING_KEY set: #{ENV['VICTOROPS_ROUTING_KEY']}"
    else
      puts '  envvar VICTOROPS_ROUTING_KEY not set'
    end
    if config[:routing_key]
      puts "  option routingkey set: #{config[:routing_key]}"
    else
      puts '  option routingkey not set'
    end
    if settings[config[:settingsname]]
      puts "  settings routing_key set: #{settings[config[:settingsname]]['routing_key']}" if settings[config[:settingsname]]['routing_key']
    else
      puts "  setting name: #{config[:settingsname]} does not exist"
    end
    puts "  using: #{routing_key}"
    puts " #{@event['action']}"
    puts "VictorOps Message URI: #{uri}"
    puts "  Message type: #{payload[:message_type]}"
  end

  def handle
    # validate that we have a client defined
    unless defined?(@event['client']) && !@event['client']['name'].nil?
      raise 'victorops.rb sensu client not found or has no name. If using with Sensu Go please ensure you have enabled event mapping'
    end

    api_url = set_api_url
    routing_key = set_routing_key

    incident_key = @event['client']['name'] + '/' + @event['check']['name']

    description = @event['check']['notification']
    description ||= [@event['client']['name'], @event['check']['name'], @event['check']['output']].join(' : ')
    host = @event['client']['name']
    entity_id = incident_key
    state_message = description
    case @event['action']
    when 'create'
      message_type = case @event['check']['status']
                     when 1
                       'WARNING'
                     else
                       'CRITICAL'
                     end
    when 'resolve'
      message_type = 'RECOVERY'
    end
    payload = {}
    payload[:message_type] = message_type
    payload[:state_message] = state_message.chomp
    payload[:entity_id] = entity_id
    payload[:host_name] = host
    payload[:monitoring_tool] = 'sensu'

    # Add in client data
    payload[:check] = @event['check']
    payload[:client] = @event['client']

    uri   = URI("#{api_url.chomp('/')}/#{routing_key}")
    https = Net::HTTP.new(uri.host, uri.port)

    https.use_ssl = true
    if config[:dryrun]
      dry_run(api_url, routing_key, uri, payload)
      return
    end

    begin
      Timeout.timeout(10) do
        request      = Net::HTTP::Post.new(uri.path)
        request.body = payload.to_json
        response     = https.request(request)

        if response.code == '200'
          puts "victorops -- #{@event['action'].capitalize}'d incident -- #{incident_key}"
        else
          puts "victorops -- failed to #{@event['action']} incident -- #{incident_key}"
          puts "victorops -- response: #{response.inspect}"
        end
      end
    rescue Timeout::Error
      puts 'victorops -- timed out while attempting to ' + @event['action'] + ' a incident -- ' + incident_key
    end
  end
end
