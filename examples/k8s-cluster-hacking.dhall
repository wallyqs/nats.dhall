let NATS =
        env:NATS_PRELUDE
      ? https://wallyqs.github.io/nats.dhall/package.dhall sha256:83858825c53bbca2b5100f19fa1ba0112ff3314d169f96d8232a08a2370eea88

let kubernetes =
      https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/v4.0.0/1.17/package.dhall sha256:d9eac5668d5ed9cb3364c0a39721d4694e4247dad16d8a82827e4619ee1d6188

let cluster =
      NATS.K8S.Cluster::{
      , name = "my-nats-custom"
      , namespace = "default"
      , image = "nats:latest"
      , size = 3
      , config = NATS.Server.Config::{
        , port = 4223
        , logging = Some NATS.Server.LoggingConfig::{
          , debug = True
          , trace = True
          }
        }
      }

let nats/k8s =
    -- Generate a record with the deployable set of K8S objects.
    -- This will contain at least a StatefulSet, Service and ConfigMap
      NATS.K8S.toK8S cluster

let nats/k8s =
    -- Add some custom annotations to the StatefulSet
      nats/k8s
      with StatefulSet.metadata.annotations = Some (toMap { foo = "bar" })

in  NATS.K8S.toList nats/k8s
