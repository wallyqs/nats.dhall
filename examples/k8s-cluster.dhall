-- ? https://wallyqs.github.io/nats.dhall/package.dhall
let NATS = env:NATS_PRELUDE

let cluster =
      NATS.Server.Cluster::{
      , name = "my-nats"
      , namespace = "another-nats"
      , image = "nats:latest"
      , size = 3
      }

let natsk8s = NATS.K8S.toK8S cluster

in  NATS.K8S.toList natsk8s
