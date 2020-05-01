let kubernetes =
      https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/v4.0.0/1.17/package.dhall sha256:d9eac5668d5ed9cb3364c0a39721d4694e4247dad16d8a82827e4619ee1d6188

let Cluster : Type = 
  {
  , StatefulSet : kubernetes.StatefulSet.Type
  , ConfigMap : kubernetes.ConfigMap.Type
  , Service : kubernetes.Service.Type
  }

let defaultCluster = 
  {
  , StatefulSet = kubernetes.StatefulSet.Type
  , ConfigMap = kubernetes.ConfigMap.Type
  , Service = kubernetes.Service.Type
  }

in { default = defaultCluster, Type = Cluster }
