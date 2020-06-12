# nats.dhall

[![License][License-Image]][License-Url]
[![Version](https://img.shields.io/badge/dhall-v0.1.0-brightgreen)](https://github.com/nats-io/k8s/releases/tag/v0.1.0)

[License-Url]: https://www.apache.org/licenses/LICENSE-2.0
[License-Image]: https://img.shields.io/badge/License-Apache2-blue.svg

<img src="nats-dhall-logo.svg" width="300">

A [Dhall](http://dhall-lang.org/) package to setup [NATS.io](https://nats.io) clusters on Kubernetes (via [dhall-kubernetes](https://github.com/dhall-lang/dhall-kubernetes)).

## Getting started

Simple example of creating a 3 node cluster on the default namespace:

```dhall
let NATS = env:NATS_PRELUDE ? https://wallyqs.github.io/nats.dhall/package.dhall

let cluster =
      NATS.K8S.Cluster::{
      , name = "my-nats"
      , namespace = "default"
      , image = "nats:latest"
      , size = 3
      , config = NATS.Server.Config::{
        , port = 4222
        }
      }

-- Creates a record with a StatefulSet, ConfigMap and Service
-- which can be used for the base setup of the cluster.
let nats/k8s = NATS.K8S.toK8S cluster

-- Create a List object which can be deployed to K8S.
in  NATS.K8S.toList nats/k8s
```

Then generate the YAML objects which can be applied via `kubectl`:

```console
$ dhall-to-yaml --file examples/k8s-cluster.dhall | kubectl apply -f -

statefulset.apps/my-nats created
configmap/my-nats-config created
service/my-nats created
```

### Demo

[![asciicast](https://asciinema.org/a/UKW8S9tMfIid0FzpGrIefUbQy.svg)](https://asciinema.org/a/UKW8S9tMfIid0FzpGrIefUbQy)

### Generating the server configuration

It is also possible to create a sample configuration from the original `NATS.Server.Cluster` type as follows:

```dhall
let NATS = env:NATS_PRELUDE ? https://wallyqs.github.io/nats.dhall/package.dhall

let cluster =
      NATS.Server.Cluster::{
      , name = "another-nats"
      , namespace = "nats-io"
      , image = "nats:latest"
      , size = 3
      }

in NATS.Server.toConf cluster
```

Result:

```hcl
port = 4222
http = 8222

cluster {
  port = 6222
  routes = [
    nats://another-nats.nats-io.svc:6222
  ]
}
```

## License

Unless otherwise noted, the NATS source files are distributed
under the Apache Version 2.0 license found in the LICENSE file.
