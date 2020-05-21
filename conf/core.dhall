{- A record of functions useful for constructing `CONF` values.

   This is only a subset of what `package.dhall` exports. If you are
   not writing a CONF prelude function, you should use the
   `package.dhall` file instead.

   It is used internally by `render`, and `omitNullFields`
   instead of `package.dhall` to avoid import cycles.
-}
{ Type = ./Type
, Tagged = ./Tagged
, Nesting = ./Nesting
, keyText = ./types/keyText
, keyValue = ./types/keyValue
, string = ./types/string
, number = ./types/number
, double = ./types/double
, integer = ./types/integer
, natural = ./types/natural
, object = ./types/object
, array = ./types/array
, bool = ./types/bool
, null = ./types/null
, envValue = ./types/envValue
, renderInteger = ./renderInteger.dhall
}
