#!/bin/bash

echo ""
echo "*World of Tanks EU Servers status*"
echo ""
echo "Collecting data from WG Servers..."
FIRSTSERVERADDRESS="login.p1.worldoftanks.eu"
SECONDSERVERADDRESS="login.p2.worldoftanks.eu"

JSONANSWER="$(curl -s 'https://api.worldoftanks.eu/wgn/servers/info/?application_id=3807a045b76e542d7e22792a01af3105&game=wot')"

FIRSTSERVER="$(echo $JSONANSWER |  jq '.data.wot[1]')"
SECONDSERVER="$(echo $JSONANSWER |  jq '.data.wot[0]')"

FIRSTSERVERNAME="$(echo $FIRSTSERVER | jq '.server' | tr -d \")"
SECONDSERVERNAME="$(echo $SECONDSERVER | jq '.server' | tr -d \")"
FIRSTSERVERPLAYERS="$(echo $FIRSTSERVER | jq '.players_online')"
SECONDSERVERPLAYERS="$(echo $SECONDSERVER | jq '.players_online')"

echo "Server $FIRSTSERVERNAME: $FIRSTSERVERPLAYERS players online"
echo "Server $SECONDSERVERNAME: $SECONDSERVERPLAYERS players online"
echo "Total: $(($FIRSTSERVERPLAYERS + $SECONDSERVERPLAYERS)) players online"
echo ""

echo "Calculating latency to game servers.."

FIRSTSERVERPING="$(ping "$FIRSTSERVERADDRESS" -c 2 | tail -1 | awk '{print $4}' | cut -d '/' -f 2)"
SECONDSERVERPING="$(ping "$SECONDSERVERADDRESS" -c 2 | tail -1 | awk '{print $4}' | cut -d '/' -f 2)"

echo "Ping to "$FIRSTSERVERNAME" server: $FIRSTSERVERPING ms"
echo "Ping to "$SECONDSERVERNAME" server: $SECONDSERVERPING ms"
echo ""
if [[ $FIRSTSERVERPING  < $SECONDSERVERPING ]]; then
  echo "Server "$FIRSTSERVERNAME" is recommended for playing"
  else
    echo "Server "$SECONDSERVERNAME" is recommended for playing"
fi
