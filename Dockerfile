############################################################
# Dockerfile that contains SteamCMD
############################################################
FROM debian:stretch-slim
LABEL maintainer="walentinlamonos@gmail.com"

# Install, update & upgrade packages
# Create user for the server
# This also creates the home directory we later need
# Clean TMP, apt-get cache and other stuff to make the image smaller
# Create Directory for SteamCMD
# Download SteamCMD
# Extract and delete archive
RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		lib32stdc++6 \
		lib32gcc1 \
		wget \
		ca-certificates \
		curl \
		unzip \
	&& useradd -m steam \
	&& su steam -c \
		"mkdir -p /home/steam/steamcmd \
		&& cd /home/steam/steamcmd \
		&& wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf -" \
        && apt-get clean autoclean \
        && apt-get autoremove -y \
        && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Switch to user steam
USER steam

VOLUME /home/steam/steamcmd

RUN ./home/steam/steamcmd/steamcmd.sh +login anonymous \
        +force_install_dir /home/steam/csgo-dedicated \
        +app_update 740 validate \
        +quit && \
{ \
		echo '@ShutdownOnFailedCommand 1'; \
		echo '@NoPromptForPassword 1'; \
		echo 'login anonymous'; \
		echo 'force_install_dir /home/steam/csgo-dedicated/'; \
		echo 'app_update 740'; \
		echo 'quit'; \
} > /home/steam/csgo-dedicated/csgo_update.txt && \
cd /home/steam/csgo-dedicated/csgo && \ 
    curl https://raw.githubusercontent.com/CM2Walki/CSGO/master/etc/cfg.tar.gz -o cfg.tar.gz && \
    tar -xf cfg.tar.gz && rm cfg.tar.gz && \
    curl -s -o /tmp/tmp.zip http://www.esport-tools.net/download/CSay-CSGO.zip && \
    unzip /tmp/tmp.zip -d /home/steam/csgo-dedicated/csgo && \
    rm /tmp/tmp.zip && \
    curl -k -s -o /tmp/tmp.zip vps.gopnik.net:6800/csgo_esl_serverconfig.zip && \
    unzip /tmp/tmp.zip -d /home/steam/csgo-dedicated/csgo/cfg && \
    rm /tmp/tmp.zip

ENV SRCDS_FPSMAX=300 SRCDS_TICKRATE=128 SRCDS_PORT=27015 SRCDS_TV_PORT=27020 SRCDS_MAXPLAYERS=14 SRCDS_TOKEN=0 SRCDS_RCONPW="changeme" SRCDS_PW="changeme"

VOLUME /home/steam/csgo-dedicated

# Set Entrypoint; Technically 2 steps: 1. Update server, 2. Start server
ENTRYPOINT ./home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/steam/csgo-dedicated +app_update 740 +quit && \
        ./home/steam/csgo-dedicated/srcds_run -game csgo -console -autoupdate -steam_dir /home/steam/steamcmd/ -steamcmd_script /home/steam/csgo-dedicated/csgo_update.txt -usercon +fps_max $SRCDS_FPSMAX -tickrate $SRCDS_TICKRATE -port $SRCDS_PORT -tv_port $SRCDS_TV_PORT -maxplayers_override $SRCDS_MAXPLAYERS +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust2 +sv_setsteamaccount $SRCDS_TOKEN +rcon_password $SRCDS_RCONPW +sv_password $SRCDS_PW +sv_region $SRCDS_REGION

# Expose ports
EXPOSE 27015 27020 27005 51840
