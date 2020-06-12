let NATS = env:NATS_PRELUDE ? https://wallyqs.github.io/nats.dhall/package.dhall

let serverConfig = NATS.Server.Config::{
      , port = 4223
      , logging = Some NATS.Server.LoggingConfig::{
        , debug = True
        }
      , cluster = Some NATS.Server.ClusterConfig::{=}
      }

in NATS.Conf.render (NATS.Server.toConf serverConfig)
