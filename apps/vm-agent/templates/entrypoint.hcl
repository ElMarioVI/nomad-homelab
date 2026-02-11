variable "entrypoint_config" {
  description = "Entrypoint configuration for the VM agent"
  default     = <<EOH
#!/bin/sh

SERVER_ADDR={{ range nomadService "vm-server" }}{{ .Address }}:{{ .Port }}{{ end }}

if [ -z "$SERVER_ADDR" ]; then
  echo "No server address found"
  exit 1
fi

/vmagent-prod \
  -remoteWrite.url="http://$SERVER_ADDR/api/v1/write" \
  -remoteWrite.maxDiskUsagePerURL=1GB \
  -remoteWrite.tmpDataPath=/tmp/vmagent-remotewrite-data \
  -promscrape.config=/local/scrape.yaml \
  -httpListenAddr=0.0.0.0:8429 \
  -promscrape.suppressScrapeErrors=false \
  -promscrape.discovery.concurrency=1 \
  -promscrape.maxScrapeSize=16MB \
  -memory.allowedPercent=70 \
  -remoteWrite.queues=2 \
  -remoteWrite.maxBlockSize=8MB
EOH
}
