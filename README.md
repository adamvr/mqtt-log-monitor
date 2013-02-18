# mqtt-log-monitor

## introduction

A super simple tool for publishing changes in log files to mqtt.  
Equivalent to `tail -f | sed '/^\W*$/d' | mosquitto_pub -l -t <topic>`  
Written in coffeescript with javascript scaffolding.  

## installation

    npm install -g mqtt-log-monitor

## usage

    mqtt-log-monitor [-r] [-p port] [-h host] -f file -t topic

where:

* -p (--port) is the port of the broker to be published to
* -h (--host) is the hostname of the broker
* -f (--file) is the file to monitor
* -t (--topic) is the MQTT topic to publish changes to
* -r (--retain) retain published messages

## caveats

mqtt-log-monitor uses `tail -f` and has all the attendant requirements and quirks.

## dependencies

* [mqtt.js](http://github.com/adamvr/MQTT.js)
* [optimist](http://github.com/substack/node-optimist)
* [coffee-script](http://github.com/jashkenas/coffee-script)
