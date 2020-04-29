let NATS = env:NATS_PRELUDE ? https://wallyqs.github.io/nats.dhall/package.dhall

let kind =
      https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/v4.0.0/1.17/typesUnion.dhall sha256:61d9d79f8de701e9442a796f35cf1761a33c9d60e0dadb09f882c9eb60978323

let nats/cluster =
      NATS.Server.Cluster::{
      , name = "my-nats"
      , namespace = "default"
      , image = "nats:latest"
      , size = 3
      }

let nats/k8s/cluster = NATS.K8S.toK8S nats/cluster

in  { apiVersion = "v1"
    , kind = "List"
    , items =
      [ kind.ConfigMap nats/k8s/cluster.ConfigMap
      , kind.Service nats/k8s/cluster.Service
      , kind.StatefulSet nats/k8s/cluster.StatefulSet
      ]
    }
