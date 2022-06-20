#!/usr/bin/env bash
set -e  ## Exit immediately if a command exits with a non-zero status.

if [ "$SKIP_DEPLOY" = "1" -o "$SKIP_DEPLOY" = "true" -o "$SKIP_DEPLOY" = "TRUE" ]; then
  echo "SKIP_DEPLOY is $SKIP_DEPLOY, skipping actual deployment of $APPLICATION_NAME"
else
    echo "set namespace context to $KUBE_NAMESPACE"
    kubectl config set-context $(kubectl config current-context) --namespace=$KUBE_NAMESPACE

    for y in ./deployment/*.yml ;
    do
        echo "deploying $y for $APPLICATION_NAME ..."
        kubectl apply -f $y
    done
fi
