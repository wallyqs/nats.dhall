let NATS = env:NATS_PRELUDE ? https://wallyqs.github.io/nats.dhall/package.dhall

let cluster =
      NATS.Server.Cluster::{
      , name = "another-nats"
      , namespace = "nats-io"
      , image = "nats:latest"
      , size = 3
      }

in  NATS.Server.toConf cluster
