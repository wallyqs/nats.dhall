let NATS = env:NATS_PRELUDE ? https://wallyqs.github.io/nats.dhall/package.dhall

let cluster =
      NATS.Server.Cluster::{
      , name = "my-nats"
      , namespace = "default"
      , image = "nats:latest"
      , size = 3
      }

let nats/k8s = NATS.K8S.toK8S cluster
in NATS.K8S.toList nats/k8s
