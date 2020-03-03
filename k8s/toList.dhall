let kubernetes = 
    https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/package.dhall
    sha256:39fa32f6cbdd341cfd2be0aec017c7f6eb554a58bf0262ae222badf3b9c348c0

let kind =
    https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/4ad58156b7fdbbb6da0543d8b314df899feca077/types.dhall 
    sha256:e48e21b807dad217a6c3e631fcaf3e950062310bfb4a8bbcecc330eb7b2f60ed

let Cluster = ./cluster/type.dhall

let toList = \(nats : Cluster) -> 
  let labels = Some (toMap { app = nats.name })
  let metadata = kubernetes.ObjectMeta::{ 
    , name = nats.name
    , labels = labels
  }

  let clientHostPort = if nats.externalAccess then Some 4222 else None Natural

  let clientPort = kubernetes.ContainerPort::{ 
    , containerPort = 4222
    , name = Some nats.name
    , hostPort = clientHostPort
  }

  -- let svc = kubernetes.Service::{
  --     , metadata = metadata
  --     , spec = kubernetes.ServiceSpec::{
  --       , selector = labels
  --       , type = Some "None"
  --     }
  -- }

  let sts =
      kubernetes.StatefulSet::{
       metadata = metadata,
       spec = Some kubernetes.StatefulSetSpec::{
         serviceName = nats.name,
         selector = kubernetes.LabelSelector::{
           matchLabels = labels
          },
         replicas = Some nats.size,
         template = kubernetes.PodTemplateSpec::{
           metadata = metadata,
           spec = Some kubernetes.PodSpec::{
             containers =
              [ kubernetes.Container::{
                 name = nats.name,
                 image = Some nats.image,
                 ports = Some
                    [
                      clientPort
                    ]
                }
              ]
            }
          }
        }
      }
  in { apiVersion = "v1", kind = "List", items = [ sts ] }

in toList
