# docker-csgo-csay
CSGO with CSay plugin in Docker

This Docker container is build using cm2network steamcmd & csgo docker images
https://hub.docker.com/r/cm2network/csgo/

# How to use this image
## Hosting a simple game server

Running on the *host* interface (recommended):<br/>
```console
$ docker run -d --net=host --name=csgo-dedicated -e SRCDS_TOKEN={YOURTOKEN} cm2network/csgo
```

Running multiple instances (iterate SRCDS_PORT and SRCDS_TV_PORT):
```console
$ docker run -d --net=host -e SRCDS_PORT=27016 -e SRCDS_TV_PORT=27021 -e SRCDS_TOKEN={YOURTOKEN} --name=csgo-dedicated2 cm2network/csgo
```

`SRCDS_TOKEN` **is required to be listed & reachable;** [https://steamcommunity.com/dev/managegameservers](https://steamcommunity.com/dev/managegameservers)<br/><br/>
**It's also recommended to use "--cpuset-cpus=" to limit the game server to a specific core & thread.**<br/>
**The container will automatically update the game on startup, so if there is a game update just restart the container.**

# Configuration
## Environment Variables
Feel free to overwrite these environment variables, using -e (--env): 
```dockerfile
SRCDS_RCONPW="changeme" (value can be overwritten by csgo/cfg/server.cfg) 
SRCDS_PW="changeme" (value can be overwritten by csgo/cfg/server.cfg) 
SRCDS_PORT=27015
SRCDS_TV_PORT=27020
SRCDS_FPSMAX=300
SRCDS_TICKRATE=128
SRCDS_MAXPLAYERS=14
```
## Config
The config files can be found under */home/steam/csgo-dedicated/csgo/cfg*

If you want to learn more about configuring a CS:GO server check this [documentation](https://developer.valvesoftware.com/wiki/Counter-Strike:_Global_Offensive_Dedicated_Servers#Advanced_Configuration).

## Docker Hub Build
<sup>1</sup> The image is too large (> 10 GBs) to be created using automated build and is therefor pushed manually.

README.md is a copy-paste of cm2network's docker hub README, for any more info refer to it.

https://hub.docker.com/r/trashcluster/csgo-csay
