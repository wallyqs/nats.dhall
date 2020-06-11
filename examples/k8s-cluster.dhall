let NATS = env:NATS_PRELUDE

let cluster = NATS.K8S.Cluster::{
      , name = "my-new-nats"
      , namespace = "default"
      , image = "nats:latest"
      , size = 3

      -- Custom config here, some of it might be overriden
      -- to accomodate to the required settings for the K8S env.
      -- , config = NATS.Server.Config::{=}
      , config = NATS.Server.Config::{
        , port = 4222
        -- Modify further the config settings
        -- , cluster = Some NATS.Server.ClusterConfig::{=}
      }
    }

-- The deployable set of K8S objects.
in NATS.K8S.toList (NATS.K8S.toK8S cluster)
