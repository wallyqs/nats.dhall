let NATS = env:NATS_PRELUDE ? https://wallyqs.github.io/nats.dhall/package.dhall

let cluster =
      NATS.K8S.Cluster::{
      , name = "my-nats"
      , namespace = "default"
      , image = "nats:latest"
      , size = 3
      , config = NATS.Server.Config::{
        , port = 4223
        }
      }

let natsk8s = NATS.K8S.toK8S cluster

in  NATS.K8S.toList natsk8s
