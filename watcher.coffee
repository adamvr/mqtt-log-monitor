mqtt = require 'mqtt'
fs = require 'fs'
path = require 'path'
optimist = require 'optimist'
crypto = require 'crypto'
{spawn} = require 'child_process'

argv = require('optimist')
  .usage("""
    mqtt-log-monitor: monitor a log file for changes
    Usage: mqtt-log-monitor -t <topic> -f <file>
    """)
  .options "h",
    describe: "broker host name"
    default: "localhost"
  .options "p",
    describe: "broker port"
    default: 1883
  .options "f",
    describe: "file to monitor"
    demand: true
  .options "t",
    describe: "topic to publish messages on"
    demand: true
  .options "r",
    describe: "retain last message in broker"
    default: false
    boolean: true
  .argv

file = argv.f
topic = argv.t
port = argv.p
host = argv.h
retain = argv.r

unless fs.existsSync file
  console.error "mqtt-log-monitor: File #{file} does not exist"
  process.exit -1

fileWatcher = (filename) ->
  stdout = (spawn 'tail', ['-f', filename]).stdout
  stdout.setEncoding 'utf8'
  stdout

mqtt.createClient port, host, (err, client) ->
  timeout = 5000
  client.connect
    keepalive: timeout

  setTimeout =>
    client.pingreq()
  , timeout

  publishLines = (data) ->
    for line in data.split('\n') when line isnt ""
      client.publish
        topic: topic
        payload: line
        retain: retain

  client.on 'connack', (packet) ->
    if packet.returnCode isnt 0
      client.disconnect()
      return

    fileWatcher(file).on 'data', (data) ->
      publishLines data
