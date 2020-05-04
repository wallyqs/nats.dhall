let Cluster : Type = {
  , name : Text
  , namespace : Text
  , image : Text
  , externalAccess : Bool
  , size : Natural

  -- FIXME: Move this into its own type.
  , clientPort : Natural
  , clusterPort : Natural
  , leafnodePort : Natural
  , gatewayPort : Natural
  , monitoringPort : Natural
}

in Cluster
