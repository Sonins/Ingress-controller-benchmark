# !/bin/bash
# ingress gateway가 설치된 채로 사용하는 shell

APP=${1:-nginx}
VUS=${2:-1000}
DURATION=${3:-3m}

BENCHMARK_PATH=.
MANIFESTS_PATH=${BENCHMARK_PATH}/deploy/manifests

BENCHMARK_SCRIPT=scripts/${APP}.js
SCRIPT_BASENAME=${BENCHMARK_SCRIPT##*/}
SCRIPT_BASENAME=${SCRIPT_BASENAME%.js}

PWD=`pwd`


echo "Starting benchmark using ${BENCHMARK_SCRIPT} with vus ${VUS}, duration ${DURATION}."

setup() {    
    kubectl apply -f ${MANIFESTS_PATH}/workload/${APP}/ -n benchmark > /dev/null
    echo "Waiting for deployment ready.."
    kubectl wait -f ${MANIFESTS_PATH}/workload/${APP}/deployment.yaml --for condition=available --timeout=3m > /dev/null
    sleep 3
}

nginx_bench() {
    setup
    echo "--- nginx Benchmark"
    HOST=nginx.k8s.com
    docker-compose run -v ${PWD}/scripts:/scripts \
        k6 run /scripts/${APP}.js \
        --vus $VUS --duration $DURATION \
        -e HOST=$HOST -e ING_CTRL=nginx \
        --insecure-skip-tls-verify

    kubectl delete -f ${MANIFESTS_PATH}/workload/${APP}/deployment.yaml --grace-period=20
}

haproxy_bench() {
    setup
    echo "--- HAproxy Benchmark"
    HOST=haproxy.k8s.com
    docker-compose run -v ${PWD}/scripts:/scripts \
        k6 run /scripts/${APP}.js \
        --vus $VUS --duration $DURATION \
        -e HOST=$HOST -e ING_CTRL=haproxy \
        --insecure-skip-tls-verify

    kubectl delete -f ${MANIFESTS_PATH}/workload/${APP}/deployment.yaml --grace-period=20
}

istio_bench() {
    setup
    echo "--- istio Benchmark"
    HOST=istio.k8s.com
    docker-compose run -v ${PWD}/scripts:/scripts \
        k6 run /scripts/${APP}.js \
        --vus $VUS --duration $DURATION \
        -e HOST=$HOST -e ING_CTRL=istio \
        --insecure-skip-tls-verify

    kubectl delete -f ${MANIFESTS_PATH}/workload/${APP}/deployment.yaml --grace-period=20
}

case $4 in
    'nginx')
    nginx_bench
    ;;
    'haproxy')
    haproxy_bench
    ;;
    'istio')
    istio_bench
    ;;
    *)
    nginx_bench
    sleep 60
    haproxy_bench
    sleep 60
    istio_bench
    ;;
esac

kubectl delete -f ${MANIFESTS_PATH}/workload/${APP} -n benchmark >> /dev/null
