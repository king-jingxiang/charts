# Pod GPU Metrics Exporter

A simple go http server serving per pod GPU metrics at localhost:9400/gpu/metrics. The exporter connects to kubelet gRPC server (/var/lib/kubelet/pod-resources) to identify the GPUs running on a pod leveraging Kubernetes [device assignment feature](https://github.com/vikaschoudhary16/community/blob/060a25c441269be476ade624ea0347ebc113e659/keps/sig-node/compute-device-assignment.md) and appends the GPU device's pod information to metrics collected by [dcgm-exporter](https://github.com/NVIDIA/gpu-monitoring-tools/tree/master/exporters/prometheus-dcgm/dcgm-exporter).

The http server allows Prometheus to scrape GPU metrics directly via a separate endpoint without relying on node-exporter. But if you still want to scrape GPU metrics via node-exporter, follow [these instructions](https://github.com/NVIDIA/gpu-monitoring-tools/tree/master/exporters/prometheus-dcgm#node_exporter).

### Prerequisites
* NVIDIA Tesla drivers = R384+ (download from [NVIDIA Driver Downloads page](http://www.nvidia.com/drivers))
* nvidia-docker version > 2.0 (see how to [install](https://github.com/NVIDIA/nvidia-docker) and it's [prerequisites](https://github.com/nvidia/nvidia-docker/wiki/Installation-\(version-2.0\)#prerequisites))
* Set the [default runtime](https://github.com/NVIDIA/nvidia-container-runtime#daemon-configuration-file) to nvidia
* Kubernetes version = 1.13
* Set KubeletPodResources in /etc/default/kubelet: KUBELET_EXTRA_ARGS=--feature-gates=KubeletPodResources=true

#### Deploy on Kubernetes cluster 
```sh
# Deploy nvidia-k8s-device-plugin

# Deploy GPU Pods

# Create the monitoring namespace
$ kubectl create namespace monitoring

# Add gpu metrics endpoint to prometheus
$ kubectl create -f prometheus/prometheus-configmap.yaml

# Deploy prometheus
$ kubectl create -f prometheus/prometheus-deployment.yaml

$ kubectl create -f pod-gpu-metrics-exporter-daemonset.yaml

# Open in browser: localhost:9090
```
#### Build and Run locally
```sh
$ git clone
$ cd src && go build。
$ sudo ./src
```
### For GPUShare
#### Add gpu process memory used metrics
```
add /var/run/docker.sock    # used to get pod container pid
add hostPID: true           # used to check whether the parent porcess of the gpu process is pod container process 
use nvml                    # used to get the gpu process used memory
```
#### metrice sample output
```
# TYPE dcgm_process_mem_used gauge
# HELP dcgm_process_mem_used process memory used (in MiB).
dcgm_process_mem_used{gpu="0",uuid="GPU-ad365448-e6c2-68f2-24e4-517b1e56e937",pod_name="test-pod-01",pod_namespace="default",container_name="nvidia-test",process_name="python",process_pid="617",process_type="C"} 847
dcgm_process_mem_used{gpu="0",uuid="GPU-ad365448-e6c2-68f2-24e4-517b1e56e937",pod_name="test-pod-01",pod_namespace="default",container_name="nvidia-test",process_name="python",process_pid="16187",process_type="C"} 587
# TYPE dcgm_gpu_logic_used gauge
# HELP dcgm_gpu_logic_used gpu used (in 0(unused)/1(used) ).
dcgm_gpu_logic_used{hostname="amax-pcl1",count="1",used="1"} 1
dcgm_gpu_logic_used{hostname="amax-pcl2",count="4",used="1 1 0 0"} 12
```

### deploy
```bash
kubectl apply -f ./prometheus
kubectl apply -f ./grafana
```

### Related Project
[cuda-wrapper](https://github.com/ruanxingbaozi/cuda-wrapper)
[k8s-device-plugin](https://github.com/ruanxingbaozi/k8s-device-plugin)

### Optional Project
[gpushare-device-plugin](https://github.com/AliyunContainerService/gpushare-device-plugin)
[gpushare-scheduler-extender](https://github.com/AliyunContainerService/gpushare-scheduler-extender)