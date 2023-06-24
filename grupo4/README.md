# Readme file for grupo4

This group contains information about the grupo4 project. It contains information about the initialization of your application using the `kubectl` command or `helm` charts.

The main idea is that in this group0 the manifests or charts that will serve as the basis for the additional groups to build their manifests or apply the charts are shown.

After having made a review about the servers, processors, infrastructure and coherence protocols in the synchronous class sessions, what will be done is an implementation of an application on the selected Cloud provider, as well as making a presentation showing the relationship that exists between what is seen in the theory part and the implementation of the infrastructure in practice.

Remember that the delivery of the report for this integrating project must be carried out according to the PechaKucha recommendation.

In this `group4` you will find a couple of directories: **k8s** and **Helm**.

In both you will find the information to carry out the deployment of the selected application: *in this case a simple installation of WordPress.*

Please note that the information here is not entirely complete. Part of your job on the Integrating Project is to make adjustments to meet delivery specifications.

---

## General objectives

  Perform WordPress deployment using manifests and charts implementing resource allocation requirements for volumes, cpu and memory. Correlate the deployments made with the monitoring and observability stack.

## Initial requirements

- `kubectl` and `helm` must be installed
- Validation of connectivity and RBAC permissions for the kubernetes cluster for this project
- Adjust in the required cases the values corresponding to the allocation of memory (> 1024MI) and CPU (> 1000m)
- Define or check the sizes of the volumes no larger than 64 GiB in the required cases

## Specific objectives

- Deploy WordPress using the manifest files into the **group0** `namespace` (**NOTE: use your own `namespace` on all applicable files !!!**)
- Deploy WordPress using Helm in the **group0** `namespace`
- Validate both installations
- Verify deployments through the Grafana interface, especially the values specified for **cpu** and **memory** values
- According to your criteria, review the different dashboards in Grafana and indicate which of them could be better used to explain the effects of virtualization in your deployed applications (for example the context switch, I/O operations to disk or network, etc. ), take one of them and use it to develop your PechaKucha presentation.


# How to deploy

## Using manifest files

Inside the k8s directory there is the file `wordpress-deployment.yaml` and `mysql-deployment.yaml`, edit them and specify the values ​​for the **namespace**, **volumes**, **cpu** and **memory**.

Example:

```yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: wp-pv-claim
  namespace: grupo4        <-- HERE YOUR NAMESPACE
  labels:
    app: wordpress
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi          <-- HERE YOUR DISK SIZE
```

For the pod resources

```yaml
        resources:
          limits:
            cpu: 1000m       <-- HERE YOUR CPU LIMIT
            memory: 1024Mi   <-- HERE YOUR MEMORY LIMIT
          requests:
            cpu: 100m
            memory: 256Mi

```

Apply the manifests with

```bash
❯ kubectl apply -f k8s/
service/wordpress-mysql created
persistentvolumeclaim/mysql-pv-claim created
deployment.apps/wordpress-mysql created
service/wordpress created
persistentvolumeclaim/wp-pv-claim created
```

Do a port-forward and finish with the WordPress installation for your group.

To do the port-forward you need to know the ports used, you can check the ports of the WordPress service by checking the applied manifest or asking kubernetes directly

```bash
❯ kubectl -n grupo0 get services
NAME              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
wordpress         ClusterIP   10.245.154.199   <none>        80/TCP     31m
wordpress-mysql   ClusterIP   None             <none>        3306/TCP   31m
```

We create the port-forward with

```bash
❯ kubectl -n grupo0 port-forward service/wordpress 9000:80

Forwarding from 127.0.0.1:9000 -> 80
Forwarding from [::1]:9000 -> 80
Handling connection for 9000
Handling connection for 9000
Handling connection for 9000
Handling connection for 9000
```

Access with your browser to http://localhost:9000

![WordPress Installation](wordpress-manifest-install.png "WordPress Installation")

During the installation of WordPress, use **your group name** as the administrator username, the password specified in the XLSX document and your institutional email as email.

Finish this activity by verifying the resource consumption through the Grafana interface. Review the details to access Grafana in [this file](Grafana.md).

![Grafana login](grafana-login.png "Grafana login")

![Grafana Node Exporter Full](grafana-1.png "Grafana Node Exporter Full")

  **REMEMBER: you must select one of the dashboards available in "General/Node Exporter Full" that allows you to relate the aspects seen in the theory classes related to servers, processors, caches, etc, to be used in your presentation in PechaKucha. You can also add new Dashboards if you wish.**

![Grafana Dashboards List](grafana-dashboards.png "Grafana Dashboards List")

---

## Using Helm

Here we will do the same as in the previous case, only that we will be using Helm charts. Remember that it is a requirement to have Helm installed.

  **NOTE**: everything discussed here is automated within the `Helm/wordpress.sh` script, please take a look at it and make the required changes for your group. You should do the same for your `wordpress-values.yaml` file.

**1.- Add repository to Helm**

You need to have Bitnami in your repository list. If you don't have it, you can add/edit it with

```bash
❯ helm repo add bitnami https://charts.bitnami.com/bitnami;
```

**2.- Search by WordPress**

Now we can search through their repositories

```bash
❯ helm search repo wordpress --max-col-width=0

NAME                   	CHART VERSION	APP VERSION	DESCRIPTION
bitnami/wordpress      	16.1.18      	6.2.2      	WordPress is the world's most popular blogging and content management platform. Powerful yet simple, everyone from students to global corporations use it to build beautiful, functional websites.
bitnami/wordpress-intel	2.1.31       	6.1.1      	DEPRECATED WordPress for Intel is the most popular blogging application combined with cryptography acceleration for 3rd gen Xeon Scalable Processors
```

We will use the APP version **16.1.18**.

**3.- Adjust your custom values**

If this is the first time you are applying this Chart, you can "see" which are its default values ​​with the command:


```bash
❯ helm show values bitnami/wordpress > wordpress-sample.yaml
```

where we are saving the content of the result of such command in the `wordpress-sample.yaml` file that we will use later as a reference to set our own values.

```bash
❯ code wordpress-values.yaml wordpress-sample.yaml
```

for more details check the `wordpress-values.yaml` file and adjust your own settings.

**4.- Apply the Chart**

Finally we can apply the Chart directly with the `wordpress.sh` script


```bash
❯ ./wordpress.sh

Release "grupo0-wordpress" does not exist. Installing it now.
NAME: grupo0-wordpress
LAST DEPLOYED: Sat Jun 24 09:00:58 2023
NAMESPACE: grupo0
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: wordpress
CHART VERSION: 16.1.18
APP VERSION: 6.2.2

** Please be patient while the chart is being deployed **

Your WordPress site can be accessed through the following DNS name from within your cluster:

    grupo0-wordpress.grupo0.svc.cluster.local (port 80)

To access your WordPress site from outside the cluster follow the steps below:

1. Get the WordPress URL by running these commands:

   kubectl port-forward --namespace grupo0 svc/grupo0-wordpress 80:80 &
   echo "WordPress URL: http://127.0.0.1//"
   echo "WordPress Admin URL: http://127.0.0.1//admin"

2. Open a browser and access WordPress using the obtained URL.

3. Login with the following credentials below to see your blog:

  echo Username: user
  echo Password: $(kubectl get secret --namespace grupo0 grupo0-wordpress -o jsonpath="{.data.wordpress-password}" | base64 -d)

```

**5.- Validate the Release**

We must make a port-forward to the newly created WordPress service

```bash
❯ kubectl port-forward --namespace grupo0 svc/grupo0-wordpress 8080:80
```

open browser at **http://localhost:8080**

![WordPress installed using Helm Chart](wordpress-helm.png "WordPress installed using Helm Chart")

Finish this activity by verifying the resource consumption through the Grafana interface. Review the details to access Grafana in [this file](Grafana.md).

![Grafana login](grafana-login.png "Grafana login")

![Grafana Node Exporter Full](grafana-1.png "Grafana Node Exporter Full")

 **REMEMBER: you must select one of the dashboards available in "General/Node Exporter Full" that allows you to relate the aspects seen in the theory classes related to servers, processors, caches, etc, to be used in your presentation in PechaKucha. You can also add new Dashboards if you wish.**

![Grafana Dashboards List](grafana-dashboards.png "Grafana Dashboards List")

All done. Happy Helming!
