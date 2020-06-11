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

        -- CLUSTER
        --
        let clusterConf = merge 
        {
          , Some = \(cluster : ClusterConfig.Type) -> (toMap {
            , cluster = NATS/Conf.object (toMap { 
                , port = NATS/Conf.integer (Natural/toInteger cluster.port)
              })
            })
          , None = empty
        } nats.cluster

        -- LOGGING
        -- NOTE: Ideally we should omit all the false ones from the output.
        let loggingConf = merge 
        {
          , Some = \(logging : LoggingConfig.Type) -> (toMap {
              , debug = NATS/Conf.bool logging.debug
              , trace = NATS/Conf.bool logging.trace
              , logtime = NATS/Conf.bool logging.logtime
            })
          , None = empty
        } nats.logging

        let conf = List/concat { mapKey : Text, mapValue : NATS/Conf.Type } [ 
           , clientConf
           , clusterConf
           , loggingConf
        ]

        -- Return the list of configured blocks as NATS/Conf types
        in NATS/Conf.object conf
in  toConf
