let NATS = env:NATS_PRELUDE ? https://wallyqs.github.io/nats.dhall/k8s/package.dhall

let cluster =
      NATS.Server.Cluster::{
      , name = "my-nats"
      , namespace = "default"
      , image = "nats:latest"
      , size = 3
      }

let natsk8s = NATS.K8S.toK8S cluster

in  NATS.K8S.toList natsk8s
