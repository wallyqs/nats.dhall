let kind =
      https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/v4.0.0/1.17/typesUnion.dhall sha256:61d9d79f8de701e9442a796f35cf1761a33c9d60e0dadb09f882c9eb60978323

let NATS/K8S/Cluster = ./cluster.dhall

let toList =
        λ(nats : NATS/K8S/Cluster.Type)
      → { apiVersion = "v1"
        , kind = "List"
        , items =
          [ kind.StatefulSet nats.StatefulSet
          , kind.ConfigMap nats.ConfigMap
          , kind.Service nats.Service
          ]
        }

in  toList
