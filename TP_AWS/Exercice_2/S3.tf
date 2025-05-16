# Déclaration d'un bucket S3
resource "aws_s3_bucket" "demo_bucket" {
  
  #  nom du bucket est défini  à partir d'une var
  bucket = var.s3_bucket_name
}
