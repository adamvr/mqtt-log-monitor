## mqtt-log-monitor

A super simple tool for publishing changes in log files to mqtt.
Written in coffeescript with javascript scaffolding.

## caveats

mlm uses `tail -f` and has all the attendant requirements and quirks.

## dependencies

* [mqtt.js](http://github.com/adamvr/MQTT.js)
* [optimist](http://github.com/substack/node-optimist)
* [coffee-script](http://github.com/jashkenas/coffee-script)
