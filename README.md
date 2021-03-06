# Ingress Controller benchmark

## Prerequisite
`Docker` `Kubernetes Cluster`
## setup
```
sudo sh setup.sh
```
## Why sudo?    
Because setup.sh modified /etc/hosts file, to register hostname and IP of ingress gateway.
## benchmark
Need to run in repo root.
### load test
```
sh shell/benchmark.sh 
```
### load test - with custom app

```
#                      APP  VU   Duration
sh shell/benchmark.sh nginx 3000 3m
```
---
## Uninstall
```
sh uninstall.sh
```
## Result
```
# Benchmark with nginx server, 3000 VUs, 3m duration.
# All ingress controller has 1 pod. No HPA.
# Pod memory is 2Gi. CPU is 200m, 500m, each.

# Command:
sh shell/benchmark.sh nginx 3000 3m
```
### CPU 200m
![ex 200m](./result/img/200m.png)
high resolution
![RPS 200m](./result/img/RPS_200m.png)
![Duration 200m](./result/img/Duration_200m.png)

### CPU 500m
![ex 500m](./result/img/500m.png)
high resolution
![RPS 200m](./result/img/RPS_500m.png)
![Duration 200m](./result/img/Duration_500m.png)

Istio has high cpu usage.  
Nginx has a long tail latency with 400m+ cpu.
