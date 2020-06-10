let LoggingConfig
    : Type
    = { 
        , debug : Bool
        , trace : Bool
        , logtime : Optional Bool
      }

let default =
      { , debug = False
        , trace = False
        , logtime = None Bool
      }

in { default = default, Type = LoggingConfig }
