let kind =
      https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/v4.0.0/1.17/typesUnion.dhall sha256:61d9d79f8de701e9442a796f35cf1761a33c9d60e0dadb09f882c9eb60978323

let kubernetes =
      https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/v4.0.0/1.17/package.dhall sha256:d9eac5668d5ed9cb3364c0a39721d4694e4247dad16d8a82827e4619ee1d6188

let NATS/K8S/Cluster : Type = {
  , StatefulSet : kubernetes.StatefulSet.Type
  , ConfigMap : kubernetes.ConfigMap.Type
  , Service : kubernetes.Service.Type
}

in let toList =
        λ(nats : NATS/K8S/Cluster)
      → { apiVersion = "v1"
        , kind = "List"
        , items =
          [ kind.StatefulSet nats.StatefulSet
          , kind.ConfigMap nats.ConfigMap
          , kind.Service nats.Service
          ]
        }

in  toList
