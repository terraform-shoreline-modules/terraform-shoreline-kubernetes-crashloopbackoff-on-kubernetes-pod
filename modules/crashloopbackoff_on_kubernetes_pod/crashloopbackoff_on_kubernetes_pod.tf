resource "shoreline_notebook" "crashloopbackoff_on_kubernetes_pod" {
  name       = "crashloopbackoff_on_kubernetes_pod"
  data       = file("${path.module}/data/crashloopbackoff_on_kubernetes_pod.json")
  depends_on = [shoreline_action.invoke_kubectl_top_pods_and_containers,shoreline_action.invoke_pod_checks,shoreline_action.invoke_pod_config_checker,shoreline_action.invoke_restart_pod_script]
}

resource "shoreline_file" "kubectl_top_pods_and_containers" {
  name             = "kubectl_top_pods_and_containers"
  input_file       = "${path.module}/data/kubectl_top_pods_and_containers.sh"
  md5              = filemd5("${path.module}/data/kubectl_top_pods_and_containers.sh")
  description      = "Check the resource usage of the Pod and its containers to ensure they are not exceeding limits"
  destination_path = "/agent/scripts/kubectl_top_pods_and_containers.sh"
  resource_query   = "container | app='shoreline'"
  enabled          = true
}

resource "shoreline_file" "pod_checks" {
  name             = "pod_checks"
  input_file       = "${path.module}/data/pod_checks.sh"
  md5              = filemd5("${path.module}/data/pod_checks.sh")
  description      = "Image Issues: The container image could be misconfigured or corrupted, causing the container to fail repeatedly immediately after starting up."
  destination_path = "/agent/scripts/pod_checks.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "pod_config_checker" {
  name             = "pod_config_checker"
  input_file       = "${path.module}/data/pod_config_checker.sh"
  md5              = filemd5("${path.module}/data/pod_config_checker.sh")
  description      = "Verify Pod configuration: Verify the configuration of the Pod to ensure that it is correctly configured and that there are no errors in the configuration files."
  destination_path = "/agent/scripts/pod_config_checker.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "restart_pod_script" {
  name             = "restart_pod_script"
  input_file       = "${path.module}/data/restart_pod_script.sh"
  md5              = filemd5("${path.module}/data/restart_pod_script.sh")
  description      = "Restart the Pod: Restarting the Pod may help resolve the issue if the cause of the incident is a transient issue."
  destination_path = "/agent/scripts/restart_pod_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_kubectl_top_pods_and_containers" {
  name        = "invoke_kubectl_top_pods_and_containers"
  description = "Check the resource usage of the Pod and its containers to ensure they are not exceeding limits"
  command     = "`chmod +x /agent/scripts/kubectl_top_pods_and_containers.sh && /agent/scripts/kubectl_top_pods_and_containers.sh`"
  params      = ["POD_NAME","CONTAINER_NAME","NAMESPACE"]
  file_deps   = ["kubectl_top_pods_and_containers"]
  enabled     = true
  depends_on  = [shoreline_file.kubectl_top_pods_and_containers]
}

resource "shoreline_action" "invoke_pod_checks" {
  name        = "invoke_pod_checks"
  description = "Image Issues: The container image could be misconfigured or corrupted, causing the container to fail repeatedly immediately after starting up."
  command     = "`chmod +x /agent/scripts/pod_checks.sh && /agent/scripts/pod_checks.sh`"
  params      = ["CONTAINER_IMAGE_URL","POD_NAME","DEBUG_IMAGE","NAMESPACE"]
  file_deps   = ["pod_checks"]
  enabled     = true
  depends_on  = [shoreline_file.pod_checks]
}

resource "shoreline_action" "invoke_pod_config_checker" {
  name        = "invoke_pod_config_checker"
  description = "Verify Pod configuration: Verify the configuration of the Pod to ensure that it is correctly configured and that there are no errors in the configuration files."
  command     = "`chmod +x /agent/scripts/pod_config_checker.sh && /agent/scripts/pod_config_checker.sh`"
  params      = ["POD_NAME","NAMESPACE"]
  file_deps   = ["pod_config_checker"]
  enabled     = true
  depends_on  = [shoreline_file.pod_config_checker]
}

resource "shoreline_action" "invoke_restart_pod_script" {
  name        = "invoke_restart_pod_script"
  description = "Restart the Pod: Restarting the Pod may help resolve the issue if the cause of the incident is a transient issue."
  command     = "`chmod +x /agent/scripts/restart_pod_script.sh && /agent/scripts/restart_pod_script.sh`"
  params      = ["POD_NAME","NAMESPACE"]
  file_deps   = ["restart_pod_script"]
  enabled     = true
  depends_on  = [shoreline_file.restart_pod_script]
}

