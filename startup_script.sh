#! /bin/bash

sudo apt update
sudo apt -y install openjdk-8-jre-headless

sudo useradd -r -m -U -d /opt/minecraft -s /bin/bash minecraft

sudo su - minecraft

mkdir -p ~/{backups,tools,server}

wget https://launcher.mojang.com/v1/objects/ed76d597a44c5266be2a7fcd77a8270f1f0bc118/server.jar -P ~/server

cd ~/server

java -Xmx1024M -Xms512M -jar server.jar nogui
wait
echo "eula=True" > eula.txt
wait
java -Xmx1024M -Xms512M -jar server.jar nogui
