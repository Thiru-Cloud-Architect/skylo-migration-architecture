variable "project_id" { 
    type = string 
}

variable "region" { 
    type = string  
    default = "asia-south1" 
}

variable "zone" {
    type = string  
    default = "asia-south1-a" 
}
variable "domain_name" { 
    type = string 
} # for CDN/HTTPS LB if using custom domain