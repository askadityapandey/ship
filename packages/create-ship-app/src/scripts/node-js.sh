#!/usr/bin/env bash
set -e
shopt -s dotglob

project_name="$1"
deployment_type="$2"
platform_common_dir="$3"
platform_specific_dir="$4"

# Clone project and create template

mkdir "$project_name"
cd "$project_name"

git clone -b a.yarmolovich/fix-dotnet-project-generation https://github.com/paralect/ship.git # TODO remove -b flag
cp -a ship/template/. .
rm -rf apps/api-net

# Rename services in docker-compose.yml

for i in docker-compose*; do
  perl -i -pe"s/ship/$project_name/g" $i
done

# Websocket config
cd apps/web

npm uninstall @microsoft/signalr
rm src/services/socket.signalr.service.ts
rm src/config/environment/development.dotnet.json

cd ../../

# Install deploy

if [ "$deployment_type" == "Digital_Ocean_Apps" ]; then
  cp -a "ship/deploy/$platform_specific_dir/.github/workflows/." ".github/workflows"
else
  cp -a "ship/deploy/$platform_common_dir/." "deploy"
  cp -a "ship/deploy/$platform_specific_dir/." "deploy"

  mv deploy/.github/workflows/* .github/workflows
  rm -rf deploy/.github
fi

rm -rf ship

# TODO uncomment lines below

# # Install pnpm
# npm i -g pnpm

# # Install modules and setup husky
# pnpm i --prefer-frozen-lockfile --ignore-scripts
# git init
# git add .
# git commit -m "initial commit"
# git branch -M main

# pnpm husky install
