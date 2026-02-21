resource "nomad_job" "gitea-runner" {
  jobspec = local.jobspec_for["apps/gitea-runner"]

  depends_on = [
    nomad_job.gitea,
  ]
}
