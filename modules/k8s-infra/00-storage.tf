# The cluster will use 2 different storage class
# cstor-mirror is for the database and some other components: azure-disk
# efs is for file system - file upload: azure-file

data "template_file" "docs_storage_cstor" {
    template = "${file("${path.module}/00-storage/01-storage-class-aks-cstor-mirror.yml")}"
}

resource "kubectl_manifest" "storage_cstor" {    
    yaml_body = data.template_file.docs_storage_cstor.rendered    
}