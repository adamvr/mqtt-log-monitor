mqtt = require 'mqttjs'
fs = require 'fs'
path = require 'path'
optimist = require 'optimist'
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
  .argv

file = argv.f
topic = argv.t
port = argv.p
host = argv.h

unless fs.existsSync file
  console.error "mqtt-log-monitor: File #{file} does not exist"
  process.exit -1

fileWatcher = (filename) ->
  stdout = (spawn 'tail', ['-f', filename]).stdout
  stdout.setEncoding 'utf8'
  stdout

mqtt.createClient port, host, (err, client) ->
  timeout = 5000
  console.log err if err
  client.connect
    clientId: "watcher_#{Math.floor(Math.random * 65535)}"
    keepalive: timeout

  setTimeout =>
    client.pingreq()
  , timeout


  client.on 'connack', (packet) ->
    if packet.returnCode isnt 0
      console.log 'Connect failed'
      client.disconnect()
      return
    console.log 'Client connected'

    fileWatcher(file).on 'data', (data) ->
      console.log "Publishing: #{data}"
      console.log client.publish
        topic: topic
        payload: data
