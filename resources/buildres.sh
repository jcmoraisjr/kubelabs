#!/bin/bash
set -e

die() { echo "$*" >&2; exit 1; }
help() { die "Usage: $0 <jenkins>"; }

do_jenkins() {
    echo -n "NFS IP: "
    read IP
    echo -n "Namespace: "
    read NS
    echo -n "Service domain: "
    read DOM
    mkdir -p res.d
    for f in jenkins-{pv,master,agent}; do
        src=${f}-template.yaml
        dest=res.d/${f}.yaml
        echo "$src -> $dest"
        sed "s/{{IP}}/${IP}/g;s/{{NS}}/${NS}/g;s/{{DOM}}/${DOM}/g" $src > $dest
    done
}

cd "$(dirname "$0")"
case "$1" in
    jenkins) do_jenkins;;
    *) help;;
esac
