let LoggingConfig
    : Type
    = { 
        , debug : Bool
        , trace : Bool
        , logtime : Bool
      }

let default =
      { , debug = False
        , trace = False
        , logtime = False
      }

in { default = default, Type = LoggingConfig }
