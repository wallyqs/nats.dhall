{- Render an `Integer` value as a `CONF number`, according to the CONF
   standard, in which a number may not start with a plus sign (`+`).
-}

let Integer/nonNegative = https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Integer/nonNegative

let renderInteger
    : Integer → Text
    = λ(integer : Integer) →
        if    Integer/nonNegative integer
        then  Natural/show (Integer/clamp integer)
        else  Integer/show integer

let positive = assert : renderInteger +1 ≡ "1"

let zero = assert : renderInteger +0 ≡ "0"

let negative = assert : renderInteger -1 ≡ "-1"

in  renderInteger
