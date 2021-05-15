locals {
  kv_secrets = {
    #serviceprincipal01 = "foobar"
    #aksspsecret = random_string.sp_pwd.result
    #aksspid     = module.aks_cluster.kubelet_identity[0].object_id
  }
}