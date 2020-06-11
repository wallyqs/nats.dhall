let NATS = env:NATS_PRELUDE

-- Model this to be similar as the real config
-- includes = [] that can be at any level
let serverConfig =  NATS.Server.Config::{
     -- Can use a custom port
     , port = 4222

     -- , logging = Some NATS.Server.LoggingConfig::{=}
     , logging = Some NATS.Server.LoggingConfig::{
       -- NOTE: If values are false do not even include them in the NATS/Conf
       , debug = False
       , trace = False
       , logtime = False
     }

     -- Enable clustering with the defaults
     , cluster = Some NATS.Server.ClusterConfig::{=}
    }

-- with syntax syntax sugar
let serverConfig = serverConfig with port = 4555
let serverConfig = serverConfig with cluster = None NATS.Server.ClusterConfig.Type
let serverConfig = serverConfig with cluster = Some NATS.Server.ClusterConfig::{ port = 8888 }
let serverConfig = serverConfig // { port = 9090 }

-- Now generate the config types
let conf = NATS.Server.toConf serverConfig

-- Renders the result

in NATS.Conf.render conf
