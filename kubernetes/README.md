# Provision alerting resources using YAML files on Kubernetes deployments

This example project shows how to deploy Grafana on Kubernetes using a [`grafana.yaml` manifest file](./grafana.yaml) and provision the alerting resources in the [`../config-files/grafana/provisioning/` folder](../config-files/grafana/provisioning/).

This tutorial provides the basic instructions. For detailed instructions, refer to: 
- [Deploy Grafana on Kubernetes](https://grafana.com/docs/grafana/latest/setup-grafana/installation/kubernetes/).
- [Provision alerting resources using config files](https://grafana.com/docs/grafana/latest/alerting/set-up/provision-alerting-resources/file-provisioning/).


### Deploy and access Grafana

This example uses [minikube](https://minikube.sigs.k8s.io/docs/start/) to start a local Kubernetes cluster:

```bash
minikube start
```

Create the namespace:

```bash
kubectl create namespace my-grafana
```

Deploy the Kubernetes resources defined in the [`grafana.yaml` manifest file](./grafana.yaml):

```bash
kubectl apply -f grafana.yaml --namespace=my-grafana
```

Enable port-forwarding to access Grafana on port `3000`:

```bash
kubectl port-forward service/grafana 3000:3000 --namespace=my-grafana
```

Access grafana at [localhost:3000](http://localhost:3000) and enter `admin/admin` to sign in.

### Copy the YAML config files 

Because provisioning files are located in the `provisioning` directory of the Grafana server, the [`grafana.yaml` manifest file](./grafana.yaml) has defined and mounted a Kubernetes persistent volume under `/etc/grafana/provisioning` as follows.


```yaml
volumeMounts:
  - mountPath: /etc/grafana/provisioning
    name: provisioning-pv
```

Get the `<pod-name>` running the Grafana instance for the subsequent commands:

```bash
kubectl get pods --namespace=my-grafana
```

Note that this example uses the [provisioning directories of the `config-files` example](../config-files/grafana/provisioning/). Copy them in the Grafana pod:

```bash
kubectl cp ../config-files/grafana/provisioning/alerting my-grafana/<pod_name>:/etc/grafana/provisioning/

kubectl cp ../config-files/grafana/provisioning/dashboards my-grafana/<pod_name>:/etc/grafana/provisioning/

kubectl cp ../config-files/grafana/provisioning/datasources my-grafana/<pod_name>:/etc/grafana/provisioning/
```

> For more detailed information about how to provision distinct Grafana resources, consult [Provision Grafana](https://grafana.com/docs/grafana/latest/administration/provisioning/).

Verify the directories are copied in the Grafana pod: 


```bash
kubectl exec -n my-grafana <pod_name> -- ls /etc/grafana/provisioning
```

### Restart Grafana to provision config files

Restart the Grafana pod to provision the resources:

```bash
kubectl rollout restart -n my-grafana deployment --selector=app=grafana
```

The `rollout restart` command kills the previous pod and scales a new pod. When the old pod terminates, you have to enable port-forwarding in the new pod again:

```bash
kubectl port-forward service/grafana 3000:3000 --namespace=my-grafana
```

Access grafana at [localhost:3000](http://localhost:3000) and verify the provisioned resources are now available.
