let Natural/equal =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v16.0.0/Prelude/Natural/equal

let List/concat =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v16.0.0/Prelude/List/concat

let List/map =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v16.0.0/Prelude/List/map

let Natural/enumerate =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v16.0.0/Prelude/Natural/enumerate

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
        
        let serverConf = toMap {
          , port = NATS/Conf.integer client.port
          , http = NATS/Conf.integer monitoring.port
          , server_name = NATS/Conf.envValue "$POD_NAME"
        }

        let cluster = {
          , port = Natural/toInteger nats.clusterPort
          , host = "0.0.0.0"
        }

        -- Generate list of integers
        let routes = if Natural/equal nats.size 1
            then [ ] : List NATS/Conf.Type
            else
              -- Generate a couple of lists then map them together
              let servers = Natural/enumerate nats.size
              let apply : Natural -> NATS/Conf.Type =
                  λ(i : Natural)
                  -> let n = Natural/show i
                     in NATS/Conf.string "nats://${name}-${n}.${name}.${namespace}.svc:${Natural/show nats.clusterPort}"

              let entries = List/map Natural NATS/Conf.Type apply servers
              -- in [
              --      NATS/Conf.string "nats://${name}-0.${name}.${namespace}.svc:${Natural/show nats.clusterPort}",
              --      NATS/Conf.string "nats://${name}-1.${name}.${namespace}.svc:${Natural/show nats.clusterPort}",
              --      NATS/Conf.string "nats://${name}-2.${name}.${namespace}.svc:${Natural/show nats.clusterPort}"
              -- ]
              in entries

        -- Merge in the routes
        let cluster = cluster ∧ { routes = routes }

        let clusterConf = if Natural/equal nats.size 1
        -- Note: Empty list requires type annotation
        then [ ] : List { mapKey : Text, mapValue : NATS/Conf.Type }
        else [
          , { mapKey = "cluster", mapValue = NATS/Conf.object [
               , { mapKey = "port", mapValue = NATS/Conf.integer cluster.port }
               , { mapKey = "routes", mapValue = NATS/Conf.array 
                   [ NATS/Conf.array routes ] 
                 }
             ]
          }
        ]

        let merged = List/concat { mapKey : Text, mapValue : NATS/Conf.Type } [
          serverConf, clusterConf
        ]

        let conf = NATS/Conf.object merged
        in NATS/Conf.render conf

in  toConf
