package cluster

import "github.com/errordeveloper/kue/cmd/crdgen/types"

ClusterTemplate :: {
	kind:       "List"
	apiVersion: "v1"
	items: [
		{
			apiVersion: "container.cnrm.cloud.google.com/v1beta1"
			kind:       "ContainerCluster"
			metadata: {
				namespace: "\(resource.metadata.namespace)"
				name:      "\(resource.metadata.name)"
				labels: cluster:                                               "\(resource.metadata.name)"
				annotations: "cnrm.cloud.google.com/remove-default-node-pool": "false"
			}
			spec: {
				location: "\(resource.spec.location)"
				networkRef: name:    "\(resource.metadata.name)"
				subnetworkRef: name: "\(resource.metadata.name)"
				initialNodeCount:  1
				loggingService:    "logging.googleapis.com/kubernetes"
				monitoringService: "monitoring.googleapis.com/kubernetes"
				masterAuth: clientCertificateConfig: issueClientCertificate: false
			}
		}, {
			apiVersion: "compute.cnrm.cloud.google.com/v1beta1"
			kind:       "ComputeNetwork"
			metadata: {
				namespace: "\(resource.metadata.namespace)"
				name:      "\(resource.metadata.name)"
				labels: cluster: "\(resource.metadata.name)"
			}
			spec: {
				routingMode:                 "REGIONAL"
				autoCreateSubnetworks:       false
				deleteDefaultRoutesOnCreate: false
			}
		}, {
			apiVersion: "compute.cnrm.cloud.google.com/v1beta1"
			kind:       "ComputeSubnetwork"
			metadata: {
				namespace: "\(resource.metadata.namespace)"
				name:      "\(resource.metadata.name)"
				labels: cluster: "\(resource.metadata.name)"
			}
			spec: {
				ipCidrRange: "10.128.0.0/20"
				region:      "us-central1"
				networkRef: name: "\(resource.metadata.name)"
			}
		},
	]
}

resource: types.Cluster
template: ClusterTemplate
