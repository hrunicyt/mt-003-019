#!/bin/bash

#  helm search repo wordpress --max-col-width=0
# NAME                   	CHART VERSION	APP VERSION	DESCRIPTION
# bitnami/wordpress      	16.1.18      	6.2.2      	WordPress is the world's most popular blogging and content management platform. Powerful yet simple, everyone from students to global corporations use it to build beautiful, functional websites.
# bitnami/wordpress-intel	2.1.31       	6.1.1      	DEPRECATED WordPress for Intel is the most popular blogging application combined with cryptography acceleration for 3rd gen Xeon Scalable Processors

# helm show values bitnami/wordpress > wordpress-sample.yaml
# cp wordpress-sample.yaml wordpress-values.yaml
#
# edit wordpress-values.yaml file and keep only updated values
# code wordpress-values.yaml
#
# apply changes
# ./wordpress.sh
#
# validate with an port-forwarding
# kubectl -n grupo6 port-forward svc/grupo6-wordpress 9000:80
#
# open browser at http://localhost:9000

helm repo add bitnami https://charts.bitnami.com/bitnami;
# bitnami/wordpress      	16.1.18      	6.2.2      	WordPress is the world's most popular blogging and content management platform. Powerful yet simple, everyone from students to global corporations use it to build beautiful, functional websites.

helm repo update;

helm  upgrade \
--install grupo6-wordpress bitnami/wordpress \
--namespace=grupo6 \
--version="16.1.18" \
-f ./wordpress-values.yaml
