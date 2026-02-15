locals {
  # Variables sustituibles en templates: __KEY__ → value
  # Usar jsonencode() para listas/maps, tostring() o literal para strings
  template_vars = {
    DATACENTER = jsonencode(data.nomad_datacenters.dc.datacenters)
    DOMAIN     = var.nomad_job_vars.domain
    MAC_LB        = var.nomad_job_vars.macs.lb
    MAC_MATRIX    = var.nomad_job_vars.macs.matrix
    MAC_QBIT      = var.nomad_job_vars.macs.qbit
    MAC_SMB_DL    = var.nomad_job_vars.macs.smb_dl
    MAC_SMB_BK    = var.nomad_job_vars.macs.smb_bk
    MAC_ENSHROUD  = var.nomad_job_vars.macs.enshroud
    MAC_MINECRAFT = var.nomad_job_vars.macs.minecraft
    MAC_HYTALE    = var.nomad_job_vars.macs.hytale
    MAC_MATERIALIOUS = var.nomad_job_vars.macs.materialious
  }

  job_files = fileset("${path.module}", "**/job.hcl")
  job_dirs  = toset([for f in local.job_files : dirname(f)])

  jobspec_raw = {
    for dir in local.job_dirs :
    dir => join("\n", [
      for file in fileset("${path.module}/${dir}", "**/*.hcl") :
      file("${path.module}/${dir}/${file}")
    ])
  }

  # Reemplazo dinámico: cada paso aplica una sustitución __KEY__ → value.
  # try() ignora los índices fuera de rango, así que los slots sobrantes son no-ops.
  # Para añadir variables, solo agrégalas a template_vars (máximo 15).
  _tv  = [for k, v in local.template_vars : { p = "__${k}__", v = v }]
  _s0  = local.jobspec_raw
  _s1  = { for d, c in local._s0  : d => try(replace(c, local._tv[0].p,  local._tv[0].v),  c) }
  _s2  = { for d, c in local._s1  : d => try(replace(c, local._tv[1].p,  local._tv[1].v),  c) }
  _s3  = { for d, c in local._s2  : d => try(replace(c, local._tv[2].p,  local._tv[2].v),  c) }
  _s4  = { for d, c in local._s3  : d => try(replace(c, local._tv[3].p,  local._tv[3].v),  c) }
  _s5  = { for d, c in local._s4  : d => try(replace(c, local._tv[4].p,  local._tv[4].v),  c) }
  _s6  = { for d, c in local._s5  : d => try(replace(c, local._tv[5].p,  local._tv[5].v),  c) }
  _s7  = { for d, c in local._s6  : d => try(replace(c, local._tv[6].p,  local._tv[6].v),  c) }
  _s8  = { for d, c in local._s7  : d => try(replace(c, local._tv[7].p,  local._tv[7].v),  c) }
  _s9  = { for d, c in local._s8  : d => try(replace(c, local._tv[8].p,  local._tv[8].v),  c) }
  _s10 = { for d, c in local._s9  : d => try(replace(c, local._tv[9].p,  local._tv[9].v),  c) }
  _s11 = { for d, c in local._s10 : d => try(replace(c, local._tv[10].p, local._tv[10].v), c) }
  _s12 = { for d, c in local._s11 : d => try(replace(c, local._tv[11].p, local._tv[11].v), c) }
  _s13 = { for d, c in local._s12 : d => try(replace(c, local._tv[12].p, local._tv[12].v), c) }
  _s14 = { for d, c in local._s13 : d => try(replace(c, local._tv[13].p, local._tv[13].v), c) }
  _s15 = { for d, c in local._s14 : d => try(replace(c, local._tv[14].p, local._tv[14].v), c) }

  jobspec_for = local._s15

  servers      = data.nomad_variable.servers.items
  smb_media_ro = data.nomad_variable.smb_media_ro.items
}
