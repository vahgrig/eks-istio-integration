# Optimizing GPU Costs on Amazon EKS with GPU Slicing

## Introduction

This docs focuses on optimizing GPU costs for AI workloads running on Amazon EKS by enabling **GPU slicing**. GPU slicing allows multiple containers or pods to share a single GPU by dividing its resources. This is particularly beneficial for workloads that don’t require an entire GPU, leading to significant cost savings. We will also cover how to integrate this with the **Karpenter autoscaler** for efficient resource scaling based on demand.

## What is GPU Slicing?

**GPU slicing** enables sharing of a single GPU across multiple containers or pods. This ensures that GPU resources are used efficiently by allowing workloads that don't fully utilize a GPU to share it. With GPU slicing, you can significantly reduce GPU-related costs, especially in environments where multiple AI or ML models run simultaneously but don’t require full GPU capacity.

## Steps to Enable GPU Slicing on EKS

### 1. **Install the NVIDIA Device Plugin**

The first step in enabling GPU slicing on Amazon EKS is to install the **NVIDIA Device Plugin**. This plugin is responsible for managing GPU resources and enabling time-slicing, allowing multiple containers to share a single GPU.

Run the following commands to install the plugin:

```bash
helm repo add nvdp https://nvidia.github.io/k8s-device-plugin
helm repo update
helm install --generate-name nvdp/nvidia-device-plugin
```

This installs the NVIDIA device plugin, which is necessary for exposing GPUs and managing GPU resources.



## 2. Configure GPU Time-Slicing

To enable GPU slicing, you need to configure time-slicing for GPUs. This is done through a ConfigMap. The following configuration splits the GPU resources into multiple slices:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nvidia-device-plugin-config
data:
  shared_gpu: |
    version: v1
    sharing:
      timeSlicing:
        resources:
        - name: nvidia.com/gpu
          replicas: 10  # Adjust this value to define the number of virtual GPUs
```

This configuration allows up to 10 virtual GPUs (or slices) to be created from a single GPU. Adjust the number of replicas based on your workload requirements.

## 3. Integrate GPU Slicing with Karpenter Autoscaler

If you're using the **Karpenter autoscaler** to dynamically scale your EKS nodes, you can configure Karpenter to support GPU slicing. Here's how you can set up a Karpenter provisioner that provisions nodes with GPU slicing enabled:

```yaml
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: gpu-shared
spec:
  requirements:
    - key: node.kubernetes.io/instance-type
      operator: In
      values: ["g4dn.xlarge", "g4dn.2xlarge"]  # GPU-enabled instance types
  labels:
    nvidia.com/device-plugin.config: shared_gpu
  limits:
    resources:
      nvidia.com/gpu: 10
```

This setup dynamically provisions GPU-enabled nodes and configures them for GPU slicing. Karpenter will ensure that only GPU nodes are provisioned when needed and will de-provision them when they are no longer required, optimizing GPU usage and reducing costs.

## 4. Deploy GPU-Enabled Applications

When deploying applications that require GPUs, you can specify the **resource limits** and **node selector** to ensure that the application uses GPU slicing. Here’s an example of how to deploy a GPU-enabled application:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gpu-app
spec:
  replicas: 1
  template:
    spec:
      containers:
      - name: app
        image: tensorflow/tensorflow:latest-gpu
        resources:
          limits:
            nvidia.com/gpu: 1  # Request one virtual GPU (a slice)
      nodeSelector:
        nvidia.com/device-plugin.config: shared_gpu
```


This configuration ensures that the application is scheduled on nodes where GPU slicing is enabled, using only a fraction of a GPU for its workload.

## Benefits of GPU Slicing and Karpenter Integration

- **Cost Efficiency**: By allowing multiple pods to share a single GPU, GPU slicing minimizes idle GPU capacity and optimizes cost-efficiency.
- **Dynamic Scaling**: With **Karpenter** integration, GPU nodes are dynamically provisioned based on workload demand and are automatically de-provisioned when no longer needed, further reducing costs.
- **Resource Flexibility**: GPU slicing allows multiple smaller workloads to efficiently share GPU resources, avoiding the need to allocate full GPUs to workloads that don’t need them.

## References

- [NVIDIA Kubernetes Device Plugin](https://github.com/NVIDIA/k8s-device-plugin)

