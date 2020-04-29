let NATS = env:NATS_PRELUDE

let cluster = NATS.K8S.Cluster:: {
    , name = "my-nats"
    , image = "nats:latest"
    , size = 3
}

in NATS.K8S.toList cluster
