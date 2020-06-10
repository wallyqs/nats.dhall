let Natural/equal =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v16.0.0/Prelude/Natural/equal

let List/concat =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v16.0.0/Prelude/List/concat

let List/map =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v16.0.0/Prelude/List/map

let Natural/enumerate =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v16.0.0/Prelude/Natural/enumerate

let Config = ./config.dhall
let ClusterConfig = ./config/cluster.dhall
let LoggingConfig = ./config/logging.dhall

let NATS/Cluster = ./cluster.dhall

let NATS/Conf = ../conf/package.dhall

let toConf =
    {- toConf takes a NATS Server Config and generates the NATS/Conf type object
       that can be rendered
    -}
        λ(nats : Config.Type)
      → let port = Natural/toInteger nats.port

        -- Initialize empty config
        let empty = [ ] : List { mapKey : Text, mapValue : NATS/Conf.Type }

        -- Add the port, work with records that can be merged
        let clientConf = toMap {
          port = NATS/Conf.integer port
        }

        -- merge is like a 'match' pattern matching
        let clusterConf = merge 
        {
          , Some = \(cluster : ClusterConfig.Type) -> (toMap {
            , cluster = NATS/Conf.object (toMap { 
                , port = NATS/Conf.integer (Natural/toInteger cluster.port)
              })
            })
          , None = empty
        } nats.cluster

        let loggingConf = merge 
        {
          , Some = \(logging : LoggingConfig.Type) -> (toMap {
              , debug = NATS/Conf.bool logging.debug
              , trace = NATS/Conf.bool logging.trace
            })
          , None = empty
        } nats.logging

        let conf = List/concat { mapKey : Text, mapValue : NATS/Conf.Type } [ 
           clientConf, clusterConf, loggingConf
        ]

        -- This is not what we want
        -- let result = NATS/Conf.object conf
        -- in NATS/Conf.render result

        -- At the end return the list of 
        in NATS/Conf.object conf
in  toConf
