let NATS = env:NATS_PRELUDE ? https://wallyqs.github.io/nats.dhall/package.dhall

let serverConfig =  NATS.Server.Config::{
     , port = 4222
     , logging = Some NATS.Server.LoggingConfig::{
       , debug = False
       , trace = False
       , logtime = False
     }
     , cluster = Some NATS.Server.ClusterConfig::{=}
    }

-- Using 'with' syntax sugar to override
let serverConfig = serverConfig with port = 4555
let serverConfig = serverConfig with cluster = None NATS.Server.ClusterConfig.Type
let serverConfig = serverConfig with cluster = Some NATS.Server.ClusterConfig::{ port = 8888 }
let serverConfig = serverConfig // { port = 9090 }

-- Now generate the NATS/Conf types and result 
let conf = NATS.Server.toConf serverConfig
in NATS.Conf.render conf
