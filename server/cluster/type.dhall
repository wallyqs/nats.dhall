let Cluster : Type = {
  , name : Text
  , namespace : Text
  , image : Text
  , externalAccess : Bool
  , size : Natural

  -- FIXME: Should ports be part of the server config instead?
  , clientPort : Natural
  , clusterPort : Natural
  , leafnodePort : Natural
  , gatewayPort : Natural
  , monitoringPort : Natural
}

in Cluster
