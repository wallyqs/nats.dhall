let kubernetes =
      https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/v4.0.0/1.17/package.dhall sha256:d9eac5668d5ed9cb3364c0a39721d4694e4247dad16d8a82827e4619ee1d6188

let NATS/Cluster = ../server/cluster/type.dhall

let toK8S =
        λ(nats : NATS/Cluster)
      → let labels = Some (toMap { app = nats.name })

        let metadata =
              kubernetes.ObjectMeta::{ name = nats.name, labels = labels }

        let cmMetadata =
              kubernetes.ObjectMeta::{
              , name = "${nats.name}-config"
              , labels = labels
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

        let serverConfig =
              ''
              port = ${Natural/show nats.clientPort}
              http = ${Natural/show nats.monitoringPort}

              cluster {
                port = ${Natural/show nats.clusterPort}

                routes [
                  nats://${nats.name}-0.${nats.name}.${nats.namespace}.svc:${Natural/show
                                                                               nats.clusterPort}
                  nats://${nats.name}-1.${nats.name}.${nats.namespace}.svc:${Natural/show
                                                                               nats.clusterPort}
                  nats://${nats.name}-2.${nats.name}.${nats.namespace}.svc:${Natural/show
                                                                               nats.clusterPort}
                ]
              }
              ''

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

        in  { StatefulSet = sts, ConfigMap = cm, Service = svc }

in  toK8S
