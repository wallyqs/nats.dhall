let Cluster : Type = {
  , name : Text
  , image : Text
  , namespace : Text
  , externalAccess : Bool
  , size : Natural

  -- FIXME: Should ports be part of the server config instead?
  , clientPort : Natural
  , monitoringPort : Natural
  , clusterPort : Natural
  , leafnodePort : Natural
  , gatewayPort : Natural
}

in Cluster
