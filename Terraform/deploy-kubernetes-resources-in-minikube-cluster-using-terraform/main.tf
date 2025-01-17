# main.tf
# https://vaibhavji.medium.com/deploy-kubernetes-resources-in-minikube-cluster-using-terraform-8dde6dd72bc4
terraform {
	required_providers {
		kubernetes = {
			source = "hashicorp/kubernetes"
			version = "2.30.0"
		}
	}
}
# Provider configuration
provider "kubernetes" {
	config_path = "C:\\Users\\User\\.kube\\config"
	config_context = "minikube"
}

resource "kubernetes_namespace" "demo" {
  metadata {
    name = "k8s-tf"
  }
}

resource "kubernetes_deployment" "demo" {
  metadata {
    name = "terraform-demo"
    labels = {
      test = "MydemoApp"
    }
    namespace = "k8s-tf"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        test = "MydemoApp"
      }
    }
    template {
      metadata {
        labels = {
          test = "MydemoApp"
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = "demo"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}