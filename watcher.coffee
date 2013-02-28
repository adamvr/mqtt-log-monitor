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
  .options "h",
    describe: "broker host name"
    default: "localhost"
  .options "p",
    describe: "broker port"
    default: 1883
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


c = mqtt.createClient port, host
c.on 'connect', ->
  fileWatcher(file).on 'data', (data) ->
    for line in data.split('\n') when line isnt ''
      c.publish topic, line, retain: retain
