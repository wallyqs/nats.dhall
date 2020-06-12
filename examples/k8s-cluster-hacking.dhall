let NATS = env:NATS_PRELUDE ? https://wallyqs.github.io/nats.dhall/package.dhall

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

let nats/k8s = NATS.K8S.toK8S cluster

-- Add some custom annotations to the StatefulSet
let stsmeta = nats/k8s.StatefulSet.metadata
let stsmeta = stsmeta with annotations = Some (toMap {
  foo = "bar"
})
let sts = nats/k8s.StatefulSet with metadata = stsmeta
let nats/k8s = nats/k8s with StatefulSet = sts

in  NATS.K8S.toList nats/k8s
