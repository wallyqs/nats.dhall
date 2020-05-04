let Natural/equal =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v15.0.0/Prelude/Natural/equal

let NATS/Cluster = ./cluster/type.dhall

let toConf =
    {- toConf takes a NATS cluster and generates a configuration map.
    TODO: Make a server conf package to represent in types.
    -}
        λ(nats : NATS/Cluster)
      → let clusterPort = Natural/show nats.clusterPort

        let routes =
                    if Natural/equal nats.size 1

              then  ""

              else  "nats://${nats.name}.${nats.namespace}.svc:${clusterPort}"

        in  ''
            port = ${Natural/show nats.clientPort}
            http = ${Natural/show nats.monitoringPort}

            cluster {
              port = ${Natural/show nats.clusterPort}
              routes = [
                ${routes}
              ]
            }
            ''

in  toConf
