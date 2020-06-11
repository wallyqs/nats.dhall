let NATS = env:NATS_PRELUDE

let cluster =
      NATS.Server.Cluster::{
      , name = "another-nats"
      , namespace = "nats-io"
      , image = "nats:latest"
      , size = 3
      }

in  NATS.Server.toConf cluster
