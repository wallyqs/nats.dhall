let Config = ../server/config.dhall

let Cluster
    : Type
    = { name : Text
      , namespace : Text
      , image : Text
      , size : Natural
      , externalAccess : Bool
      , config : Config.Type
      }

let default =
      { name = None Text
      , namespace = "default"
      , image = "nats:latest"
      , size = 1
      , externalAccess = False
      , config = Config::{=}
      }

in  { default = default, Type = Cluster }
