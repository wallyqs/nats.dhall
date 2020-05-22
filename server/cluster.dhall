let Cluster
    : Type
    = { name : Text
      , namespace : Text
      , image : Text
      , externalAccess : Bool
      , size : Natural
      , clientPort : Natural
      , clusterPort : Natural
      , leafnodePort : Natural
      , gatewayPort : Natural
      , monitoringPort : Natural
      }

let defaultCluster =
      { name = None Text
      , namespace = "default"
      , image = "nats:latest"
      , externalAccess = False
      , size = 1
      , clientPort = 4222
      , clusterPort = 6222
      , leafnodePort = 7422
      , gatewayPort = 7522
      , monitoringPort = 8222
      }

in  { default = defaultCluster, Type = Cluster }
