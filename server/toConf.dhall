let Natural/equal =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v16.0.0/Prelude/Natural/equal

let NATS/Cluster = ./cluster.dhall

let NATS/Conf = ../conf/package.dhall

let toConf =
    {- toConf takes a NATS/Cluster and generates the NATS Server configuration
       that can be stored in ConfigMap.
    -}
        λ(nats : NATS/Cluster.Type)
      → let name = nats.name
        let namespace = nats.name
        let client = {
          , port = Natural/toInteger nats.clientPort
        }
        let monitoring = {
          , port = Natural/toInteger nats.monitoringPort
        }
        let cluster = {
          , port = Natural/toInteger nats.clusterPort
          , host = "0.0.0.0"
          , routes = if Natural/equal nats.size 1
                     then  ""
                     else  "nats://${name}.${namespace}.svc:${Natural/show nats.clusterPort}"
        }

        let conf = NATS/Conf.object
        [
          , { mapKey = "port", mapValue = NATS/Conf.integer client.port }
          , { mapKey = "http", mapValue = NATS/Conf.integer monitoring.port }
          , { mapKey = "cluster", mapValue = NATS/Conf.object [
               , { mapKey = "port", mapValue = NATS/Conf.integer cluster.port }
               , { mapKey = "routes", mapValue = NATS/Conf.array 
                   [
                     NATS/Conf.string cluster.routes
                   ] 
                 }
             ]
          }
        ]

        in NATS/Conf.render conf

in  toConf
