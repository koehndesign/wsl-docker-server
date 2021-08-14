#!/bin/bash
# builds a new dockerized WordPress dev environment

echo -e "enter your app name: "

read name

dir="sites/$name"

mkdir -p $dir

rsync -a recipes/wordpress/ $dir

cd $dir

# replace app name in relevant files
sed -i "s/{NAME}/$name/" .env nginx/site.conf

docker-compose up -d