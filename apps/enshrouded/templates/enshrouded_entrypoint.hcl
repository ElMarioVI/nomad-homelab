variable "enshrouded_entrypoint" {
  description = "Entrypoint for enshrouded server"
  default     = <<EOH
#!/bin/sh
export STEAM_COMPAT_CLIENT_INSTALL_PATH="/steamcmd"
export STEAM_COMPAT_DATA_PATH="/steamcmd/steamapps/compatdata/2278520"
mkdir -p /steamcmd/steamapps/compatdata/2278520

rm -f /game/steamapps/appmanifest_2278520.acf

/steamcmd/steamcmd.sh \
  +@sSteamCmdForcePlatformType windows \
  +force_install_dir /game \
  +login anonymous \
  +app_update 2278520 validate \
  +quit

/steamcmd/compatibilitytools.d/GE-Proton10-25/proton run /game/enshrouded_server.exe &
exec tail -f /game/logs/enshrouded_server.log
EOH
}
