variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Redirect policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "alias" {
  description = "Alias."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.alias))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "anycast" {
  description = "Anycast."
  type        = bool
  default     = false
}

variable "type" {
  description = "Redirect policy type. Choices: `L3`, `L2`, `L1`."
  type        = string
  default     = "L3"

  validation {
    condition     = contains(["L3", "L2", "L1"], var.type)
    error_message = "Allowed values are `L3`, `L2` or `L1`."
  }
}

variable "hashing" {
  description = "Hashing algorithm. Choices: `sip-dip-prototype`, `sip`, `dip`."
  type        = string
  default     = "sip-dip-prototype"

  validation {
    condition     = contains(["sip-dip-prototype", "sip", "dip"], var.hashing)
    error_message = "Allowed values are `sip-dip-prototype`, `sip` or `dip`."
  }
}

variable "threshold" {
  description = "Threshold."
  type        = bool
  default     = false
}

variable "max_threshold" {
  description = "Maximum threshold. Minimum value: 0. Maximum value: 100."
  type        = number
  default     = 0

  validation {
    condition     = var.max_threshold >= 0 && var.max_threshold <= 100
    error_message = "Minimum value: 0. Maximum value: 100."
  }
}

variable "min_threshold" {
  description = "Minimum threshold. Minimum value: 0. Maximum value: 100."
  type        = number
  default     = 0

  validation {
    condition     = var.min_threshold >= 0 && var.min_threshold <= 100
    error_message = "Minimum value: 0. Maximum value: 100."
  }
}

variable "pod_aware" {
  description = "Pod aware redirect."
  type        = bool
  default     = false
}

variable "resilient_hashing" {
  description = "Resilient hashing."
  type        = bool
  default     = false
}

variable "rewrite_source_mac" {
  description = "Rewrite source mac."
  type        = bool
  default     = null
}

variable "threshold_down_action" {
  description = "Threshold down action. Choices: `permit`, `deny`, `bypass`."
  type        = string
  default     = "permit"

  validation {
    condition     = contains(["permit", "deny", "bypass"], var.threshold_down_action)
    error_message = "Allowed values are `permit`, `deny` or `bypass`."
  }
}

variable "ip_sla_policy" {
  description = "IP SLA Policy Name."
  type        = string
  default     = ""
  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.ip_sla_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "redirect_backup_policy" {
  description = "Redirect Backup Policy Name."
  type        = string
  default     = ""
  validation {
    condition     = can(regex("^[a-zA-Z0-9_.:-]{0,64}$", var.redirect_backup_policy))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "l3_destinations" {
  description = "List of L3 destinations. Allowed values `pod`: 1-255."
  type = list(object({
    description           = optional(string, "")
    name                  = optional(string, "")
    ip                    = string
    ip_2                  = optional(string)
    mac                   = optional(string)
    pod_id                = optional(number, 1)
    redirect_health_group = optional(string, "")
  }))
  default = []

  validation {
    condition = alltrue([
      for l3 in var.l3_destinations : l3.description == null || can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", l3.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for l3 in var.l3_destinations : l3.name == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", l3.name))
    ])
    error_message = "`name` allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for l3 in var.l3_destinations : l3.pod_id == null || (l3.pod_id >= 1 && l3.pod_id <= 255)
    ])
    error_message = "`pod_id`: Minimum value: 1. Maximum value: 255."
  }

  validation {
    condition = alltrue([
      for l3 in var.l3_destinations : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", l3.redirect_health_group))
    ])
    error_message = "`redirect_health_group` allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}

variable "l1l2_destinations" {
  description = "List of L1L2 destinations."
  type = list(object({
    description           = optional(string, "")
    name                  = string
    mac                   = optional(string)
    weight                = optional(number)
    pod_id                = optional(number)
    redirect_health_group = optional(string, "")
    l4l7_device           = string
    concrete_device       = string
    interface             = string
  }))
  default = []

  validation {
    condition = alltrue([
      for l1l2 in var.l1l2_destinations : l1l2.name == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", l1l2.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for l1l2 in var.l1l2_destinations : l1l2.description == null || can(regex("^[a-zA-Z0-9\\\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", l1l2.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for l1l2 in var.l1l2_destinations : l1l2.pod_id == null || try(l1l2.pod_id >= 1 && l1l2.pod_id <= 255, false)
    ])
    error_message = "`pod_id`: Minimum value: 1. Maximum value: 255."
  }

  validation {
    condition = alltrue([
      for l1l2 in var.l1l2_destinations : l1l2.mac == null || (l1l2.mac != "" && l1l2.mac != "00:00:00:00:00:00")
    ])
    error_message = "`mac`: Empty string or `00:00:00:00:00:00` are not allowed."
  }

  validation {
    condition = alltrue([
      for l1l2 in var.l1l2_destinations : l1l2.weight == null || try(l1l2.weight >= 1 && l1l2.weight <= 10, false)
    ])
    error_message = "`weight`: Minimum value: 1. Maximum value: 10."
  }

  validation {
    condition = alltrue([
      for l1l2 in var.l1l2_destinations : can(regex("^[a-zA-Z0-9_.:-]{0,64}$", l1l2.redirect_health_group))
    ])
    error_message = "`redirect_health_group` allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for l1l2 in var.l1l2_destinations : l1l2.l4l7_device == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", l1l2.l4l7_device))
    ])
    error_message = "`l4l7_device`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for l1l2 in var.l1l2_destinations : l1l2.concrete_device == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", l1l2.concrete_device))
    ])
    error_message = "`concrete_device`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for l1l2 in var.l1l2_destinations : l1l2.interface == null || can(regex("^[a-zA-Z0-9_.:-]{0,64}$", l1l2.interface))
    ])
    error_message = "`interface`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `:`, `-`. Maximum characters: 64."
  }
}
