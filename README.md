# Ingress Controller benchmark

## Prerequiste
```Docker```
## setup
```
sudo sh setup.sh
```
---
## benchmark
benchmark 폴더에서 돌려야 합니다.  
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
