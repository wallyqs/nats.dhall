let kubernetes =
      https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/v4.0.0/1.17/package.dhall sha256:d9eac5668d5ed9cb3364c0a39721d4694e4247dad16d8a82827e4619ee1d6188

let NATS/toConf = ../server/toConf.dhall

let NATS/Cluster = ../server/cluster.dhall

let NATS/K8S/Cluster = ./cluster.dhall

let toK8S =
        λ(nats : NATS/Cluster.Type)
      → let labels = Some (toMap { app = nats.name })

        let metadata =
              kubernetes.ObjectMeta::{ name = nats.name, labels = labels, namespace = Some nats.namespace }

        let cmMetadata =
              kubernetes.ObjectMeta::{
              , name = "${nats.name}-config"
              , labels = labels
	      , namespace = Some nats.namespace
              }

        let clientHostPort =
              if nats.externalAccess then Some nats.clientPort else None Natural

        let clientPort =
              kubernetes.ContainerPort::{
              , containerPort = nats.clientPort
              , name = Some nats.name
              , hostPort = clientHostPort
              }

        let natsConfFile = "nats.conf"

        let serverConfig = NATS/toConf nats

        let configVolume =
              kubernetes.Volume::{
              , name = "config-volume"
              , configMap = Some kubernetes.ConfigMapVolumeSource::{
                , name = Some cmMetadata.name
                }
              }

        let configVolMount =
              kubernetes.VolumeMount::{
              , name = configVolume.name
              , mountPath = "/etc/nats"
              }

        let command =
              [ "/nats-server"
              , "-c"
              , "${configVolMount.mountPath}/${natsConfFile}"
              ]

        let natsContainer =
              kubernetes.Container::{
              , name = "nats"
              , image = Some nats.image
              , ports = Some [ clientPort ]
              , command = Some command
              , volumeMounts = Some [ configVolMount ]
              }

        let cm =
              kubernetes.ConfigMap::{
              , metadata = cmMetadata
              , data = Some
                [ { mapKey = natsConfFile, mapValue = serverConfig } ]
              }

        let sts =
              kubernetes.StatefulSet::{
              , metadata = metadata
              , spec = Some kubernetes.StatefulSetSpec::{
                , serviceName = nats.name
                , selector = kubernetes.LabelSelector::{ matchLabels = labels }
                , replicas = Some nats.size
                , template = kubernetes.PodTemplateSpec::{
                  , metadata = metadata
                  , spec = Some kubernetes.PodSpec::{
                    , containers = [ natsContainer ]
                    , volumes = Some [ configVolume ]
                    }
                  }
                }
              }

        let svc =
              kubernetes.Service::{
              , metadata = metadata
              , spec = Some kubernetes.ServiceSpec::{
                , selector = labels
                , clusterIP = Some "None"
                , ports = Some
                  [ kubernetes.ServicePort::{
                    , name = Some "client"
                    , port = nats.clientPort
                    , targetPort = Some
                        (kubernetes.IntOrString.Int nats.clientPort)
                    }
                  ]
                }
              }

        in  NATS/K8S/Cluster::{
            , StatefulSet = sts
            , ConfigMap = cm
            , Service = svc
            }

in  toK8S
