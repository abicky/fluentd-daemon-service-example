# fluentd-daemon-service-example

This is a sample application to send docker container logs to fluentd aggregators via NLB or fluentd forwarders.


## How to use

### Create fluentd services and task definition for application to send logs

```
./deploy.sh
```

### Send container logs

With the following command, you can send docker container logs via NLB for about 3 minutes:

```
./run.sh aggregator
```

You can also send logs via fluentd forwarders with the following command:

```
./run.sh forwarder
```


## Example result

### Send logs via NLB

The following are the logs of the fluentd aggregators after `./run.sh aggregator` was executed:

```
fluentd/fluentd/e21167dd1ed144d5909b2e4adb5b5dc3 2021-03-21 21:46:00.895331357 +0000 flowcount: {"count":2624,"count_rate":43.37,"tag":"docker.application-using-aggregator"}
fluentd/fluentd/e68726eff1da443f84948d8525ab148c 2021-03-21 21:46:03.873949662 +0000 flowcount: {"count":1160,"count_rate":19.17,"tag":"docker.application-using-aggregator"}
fluentd/fluentd/a55d1d27fbd9469c81dc2b25a79e984a 2021-03-21 21:46:04.160516079 +0000 flowcount: {"count":5828,"count_rate":96.33,"tag":"docker.application-using-aggregator"}
fluentd/fluentd/777cb168dd3e4f8eb2dc8cd4c517be8b 2021-03-21 21:46:05.556735127 +0000 flowcount: {"count":1306,"count_rate":21.58,"tag":"docker.application-using-aggregator"}
fluentd/fluentd/e21167dd1ed144d5909b2e4adb5b5dc3 2021-03-21 21:47:00.895819993 +0000 flowcount: {"count":17799,"count_rate":296.64,"tag":"docker.application-using-aggregator"}
fluentd/fluentd/e68726eff1da443f84948d8525ab148c 2021-03-21 21:47:03.874672300 +0000 flowcount: {"count":5932,"count_rate":98.86,"tag":"docker.application-using-aggregator"}
fluentd/fluentd/a55d1d27fbd9469c81dc2b25a79e984a 2021-03-21 21:47:04.660120893 +0000 flowcount: {"count":29910,"count_rate":494.38,"tag":"docker.application-using-aggregator"}
fluentd/fluentd/777cb168dd3e4f8eb2dc8cd4c517be8b 2021-03-21 21:47:06.056316981 +0000 flowcount: {"count":5982,"count_rate":98.87,"tag":"docker.application-using-aggregator"}
fluentd/fluentd/e21167dd1ed144d5909b2e4adb5b5dc3 2021-03-21 21:48:01.395749103 +0000 flowcount: {"count":17950,"count_rate":296.69,"tag":"docker.application-using-aggregator"}
fluentd/fluentd/e68726eff1da443f84948d8525ab148c 2021-03-21 21:48:04.373710915 +0000 flowcount: {"count":5984,"count_rate":98.91,"tag":"docker.application-using-aggregator"}
fluentd/fluentd/a55d1d27fbd9469c81dc2b25a79e984a 2021-03-21 21:48:05.160610260 +0000 flowcount: {"count":29917,"count_rate":494.49,"tag":"docker.application-using-aggregator"}
fluentd/fluentd/777cb168dd3e4f8eb2dc8cd4c517be8b 2021-03-21 21:48:06.556881706 +0000 flowcount: {"count":5983,"count_rate":98.89,"tag":"docker.application-using-aggregator"}
fluentd/fluentd/e21167dd1ed144d5909b2e4adb5b5dc3 2021-03-21 21:49:01.894901215 +0000 flowcount: {"count":15633,"count_rate":258.4,"tag":"docker.application-using-aggregator"}
fluentd/fluentd/e68726eff1da443f84948d8525ab148c 2021-03-21 21:49:04.374282396 +0000 flowcount: {"count":4926,"count_rate":82.09,"tag":"docker.application-using-aggregator"}
fluentd/fluentd/a55d1d27fbd9469c81dc2b25a79e984a 2021-03-21 21:49:05.660895237 +0000 flowcount: {"count":24355,"count_rate":402.56,"tag":"docker.application-using-aggregator"}
fluentd/fluentd/777cb168dd3e4f8eb2dc8cd4c517be8b 2021-03-21 21:49:07.056829769 +0000 flowcount: {"count":4731,"count_rate":78.19,"tag":"docker.application-using-aggregator"}
```

The number of logs each task processed is summarized as follow:

Task ID | Count
----------|----------------
777cb168dd3e4f8eb2dc8cd4c517be8b | 18002
a55d1d27fbd9469c81dc2b25a79e984a | 90010
e21167dd1ed144d5909b2e4adb5b5dc3 | 54006
e68726eff1da443f84948d8525ab148c | 18002


On the other hand, the following are the logs after the command `./run.sh forwarder`:

```
fluentd/fluentd/e21167dd1ed144d5909b2e4adb5b5dc3 2021-03-21 21:39:58.395912823 +0000 flowcount: {"count":2969,"count_rate":49.07,"tag":"docker.application-using-forwarder"}
fluentd/fluentd/e68726eff1da443f84948d8525ab148c 2021-03-21 21:40:00.874669417 +0000 flowcount: {"count":2973,"count_rate":49.54,"tag":"docker.application-using-forwarder"}
fluentd/fluentd/a55d1d27fbd9469c81dc2b25a79e984a 2021-03-21 21:40:01.660638178 +0000 flowcount: {"count":5360,"count_rate":89.33,"tag":"docker.application-using-forwarder"}
fluentd/fluentd/777cb168dd3e4f8eb2dc8cd4c517be8b 2021-03-21 21:40:02.556869094 +0000 flowcount: {"count":4946,"count_rate":81.75,"tag":"docker.application-using-forwarder"}
fluentd/fluentd/e21167dd1ed144d5909b2e4adb5b5dc3 2021-03-21 21:40:58.895504102 +0000 flowcount: {"count":11869,"count_rate":196.18,"tag":"docker.application-using-forwarder"}
fluentd/fluentd/e68726eff1da443f84948d8525ab148c 2021-03-21 21:41:01.374179512 +0000 flowcount: {"count":18801,"count_rate":310.76,"tag":"docker.application-using-forwarder"}
fluentd/fluentd/a55d1d27fbd9469c81dc2b25a79e984a 2021-03-21 21:41:02.160881563 +0000 flowcount: {"count":10889,"count_rate":179.98,"tag":"docker.application-using-forwarder"}
fluentd/fluentd/777cb168dd3e4f8eb2dc8cd4c517be8b 2021-03-21 21:41:03.056295483 +0000 flowcount: {"count":16822,"count_rate":278.05,"tag":"docker.application-using-forwarder"}
fluentd/fluentd/e21167dd1ed144d5909b2e4adb5b5dc3 2021-03-21 21:41:59.395674810 +0000 flowcount: {"count":14827,"count_rate":245.07,"tag":"docker.application-using-forwarder"}
fluentd/fluentd/e68726eff1da443f84948d8525ab148c 2021-03-21 21:42:01.873815546 +0000 flowcount: {"count":13841,"count_rate":228.77,"tag":"docker.application-using-forwarder"}
fluentd/fluentd/a55d1d27fbd9469c81dc2b25a79e984a 2021-03-21 21:42:02.660226027 +0000 flowcount: {"count":19797,"count_rate":327.22,"tag":"docker.application-using-forwarder"}
fluentd/fluentd/777cb168dd3e4f8eb2dc8cd4c517be8b 2021-03-21 21:42:03.556922470 +0000 flowcount: {"count":10880,"count_rate":179.83,"tag":"docker.application-using-forwarder"}
fluentd/fluentd/e21167dd1ed144d5909b2e4adb5b5dc3 2021-03-21 21:42:59.895220205 +0000 flowcount: {"count":10887,"count_rate":179.95,"tag":"docker.application-using-forwarder"}
fluentd/fluentd/e68726eff1da443f84948d8525ab148c 2021-03-21 21:43:02.374503816 +0000 flowcount: {"count":6462,"count_rate":106.8,"tag":"docker.application-using-forwarder"}
fluentd/fluentd/a55d1d27fbd9469c81dc2b25a79e984a 2021-03-21 21:43:02.660722801 +0000 flowcount: {"count":11877,"count_rate":197.94,"tag":"docker.application-using-forwarder"}
fluentd/fluentd/777cb168dd3e4f8eb2dc8cd4c517be8b 2021-03-21 21:43:04.057112091 +0000 flowcount: {"count":16820,"count_rate":278.01,"tag":"docker.application-using-forwarder"}
```

As you can see below, each task processed logs more evenly:

Task ID | Count
----------|----------------
777cb168dd3e4f8eb2dc8cd4c517be8b | 49468
a55d1d27fbd9469c81dc2b25a79e984a | 47923
e21167dd1ed144d5909b2e4adb5b5dc3 | 40552
e68726eff1da443f84948d8525ab148c | 42077
