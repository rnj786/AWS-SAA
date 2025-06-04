variable "region" {
  description = "AWS region"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "force_destroy" {
  description = "Force destroy the bucket on deletion"
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable versioning on the bucket"
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm (AES256 or aws:kms)"
  type        = string
  default     = "AES256"
}

variable "kms_key_id" {
  description = "KMS Key ID for SSE-KMS encryption (if used)"
  type        = string
  default     = null
}

variable "block_public_acls" {
  description = "Block public ACLs?"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block public bucket policies?"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignore public ACLs?"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restrict public buckets?"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to the bucket"
  type        = map(string)
  default     = {}
}
