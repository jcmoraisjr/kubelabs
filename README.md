#Abstract

Welcome to Kubelabs, home of my [Kubernetes](http://kubernetes.io/docs/whatisk8s/) resources and some Docker images.

#Environment

These resources was built to deploy on a functional Kubernetes installation. A local Docker installation isn't mandatory, but useful to rebuild images changed locally. A NFS server and name resolution are also used.

##Kubernetes

The simplest and fastest way to create a Kubernetes environment is following the instructions from the [CoreOS Kubernetes page](https://coreos.com/kubernetes/docs/latest/kubernetes-on-vagrant-single.html). These steps use [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](https://www.vagrantup.com/downloads.html).

At least Kubernetes 1.3 is mandatory.

##Docker

On a Linux box:

    sudo su -
    wget -O- https://get.docker.com | sh
    usermod -aG docker <some-username>

If for any reason installing Docker isn't an option, it's possible to run the Docker daemon on a 512MB VM. Follow the [Docker Forwarding installation](https://github.com/coreos/coreos-vagrant#docker-forwarding) instructions from the coreos-vagrant repository.

##NFS

Some resources need a NFS server. Follow these steps on a CoreOS machine:

    sudo touch /etc/exports
    sudo systemctl start nfs-server
    sudo systemctl enable nfs-server

Whenever `/etc/exports` is changed, the NFS server should be notified:

    sudo exportfs -r

##DNS

Kubernetes allows exposing services on [node's port](http://kubernetes.io/docs/user-guide/services/#type-nodeport) (defaults to 30000-32767), [external IP](http://kubernetes.io/docs/user-guide/services/#external-ips), or, if published on AWS or GCE, a [load balancer](http://kubernetes.io/docs/user-guide/services/#type-loadbalancer) is also an option.

It's also possible to deploy a load balancer addon and expose services using name based virtual host. This is the approach used by the resources of this repository, but name resolution should be used here.

There are two ways to implement local name resolution:

* Add a new entry on `/etc/hosts` pointing to the load balancer's IP
* Deploy [Simple-DNS](https://github.com/jcmoraisjr/simple-dns) and point it's IP as the first IP of the router's name servers

#Resources

Deploying resources:

    kubectl create -f resources/<resource>.yaml

Deploying template-based resources:

    ./resources/buildres.sh <component>
    cat resources/res.d/<component>-* | kubectl create -f -

##NFS based resources

Some resources like Jenkins need a NFS server. The following changes should be done on the NFS server before deploying the resources.

`sudo vim /etc/exports` with the following content. One line per exported directory. `/var/nfs/full/path` is the absolute path to the root of the exported directory. `192.168.0.0/24` is the IP of the clients authorized to connect.

    /var/nfs/full/path 192.168.0.0/24(rw,no_subtree_check)

Create the directories and notify the daemon:

    sudo mkdir -p /var/nfs/full/path
    sudo exportfs -r

##Load balancer

The load balancer addon listen changes on Kubernetes services and endpoints in order to reconfigure and restart an HAProxy server.

Deploy the resource:

    kubectl create -f resources/lb-rc.yaml

Assign the load balancer to at least one Kubernetes node:

    kubectl label node <node-name> role=loadbalancer

##Jenkins

###NFS server side

Jenkins resources need two directories on the NFS server:

    sudo mkdir -p /var/nfs/jenkins/jks/{master,agent}

Jenkins process do not execute as root, but as UID `1000` instead. Because of that the permissions should be placed on the exported directories:

    sudo chown 1000:1000 /var/nfs/jenkins/jks/*

After that add two lines on `/etc/exports` and notify the server with `sudo exportfs -r`.

###Local machine side

On the clone of this repository, create the resources from the templates:

    ./resources/buildres.sh jenkins

The script will ask:

* The IP of the NFS server
* A namespace, which is `jks` in the snippets above
* The service domain - a valid name server resolved to the IP of the load balancer

Now create the namespace:

    kubectl create ns jks
    kubectl get secret --namespace=jks

Note that any namespace should have a secret named `default-token-xxxxx`. If the last command didn't return a default token, just `kubectl delete ns/jks` and create it again.

Now deploy the resources:

    cat resources/res.d/jenkins-* | kubectl create -f -

The deploy should take a while. Follow the containers creation:

    kubectl get pod -w
