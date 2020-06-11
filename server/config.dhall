let ClusterConfig = ./config/cluster.dhall
let LoggingConfig = ./config/logging.dhall

let Config
    : Type
    = { 
        , host : Text
        , port : Natural
        , cluster : Optional ClusterConfig.Type
        , logging : Optional LoggingConfig.Type
      }

let default =
      { 
        , host = "0.0.0.0"
        , port = 4222
        , cluster = None ClusterConfig.Type
        , logging = None LoggingConfig.Type
      }

in  { default = default, Type = Config }
