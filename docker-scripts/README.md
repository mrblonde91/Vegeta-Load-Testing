# Vegeta Presentation Top Level idea
## Background of how we utilise it
* We primarily use it for seeing our top throughput and preparing for seasonal traffic during black friday.
* It also tends to surface infrastructural issues. Eg being throttled on things like dynamo when under load
* Can monitor behaviour via things like splunk or datadog.

## The Setup 
* Initially used locally in a docker container, a shell script runs and alternates the traffic. We run slow and fast phases to allow containers to scale out and to try simulate fast and slow phases.
[Some sort of graph will be used to just demonstrate how we scale out]
* Locally, we tend to max out at a 1000rps. 
* To truly push the load, we started to distribute the requests via kubernetes. Introducing more pods and splitting out the traffic across them.

## Dynamic traffic
* Vegeta is built in golang, some groups tend to develop it at that level.
* My chosen approach to develop more dynamic requests was to generate them via a dotnet tool. Vegeta will allow you to continously read via lazy mode or it can be a large json file containing the requersts.

## Metrics
* Little bit on the metrics that we can gather from vegeta 