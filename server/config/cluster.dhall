let ClusterConfig
    : Type
    = { 
        , host : Text
        , port : Natural
        , routes : List Text
        , clusterAdvertise : Text
        , noAdvertise : Bool
      }

let default =
      { , host = "0.0.0.0"
        , port = 6222
        , routes = [] : List Text
        , clusterAdvertise = ""
        , noAdvertise = False
      }

in { default = default, Type = ClusterConfig }
