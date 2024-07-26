## --------------------------------------------------
##   Configuration variables for S3 Bucket
## --------------------------------------------------


variable "name" {
  type        = string
  description = "The name of the S3 bucket"
}

variable "versioning_status" {
  type        = string
  description = "configuration block for the versioning parameters"
  default = "Enabled"
}

variable "object_ownership" {
  type        = string
  description = "Object ownership. Valid values: BucketOwnerPreferred, ObjectWriter or BucketOwnerEnforced"
  default = "BucketOwnerPreferred"
}

variable "block_public_acls" {
  type        = bool
  description = "Whether Amazon S3 should block public ACLs for this bucket"
  default = true
}
variable "block_public_policy" {
  type        = bool
  description = "Whether Amazon S3 should block public bucket policies for this bucke"
  default = true
}
variable "ignore_public_acls" {
  type        = bool
  description = "Whether Amazon S3 should ignore public ACLs for this bucket"
  default = true
}
variable "restrict_public_buckets" {
  type        = bool
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket"
  default = true
}