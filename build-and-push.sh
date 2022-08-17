#!/bin/sh
# Run docker buildx an
for STATE in stable development
do
  if [ "$STATE" = "stable" ];
  then
    SOFTETHER_REPOSITORY="https://github.com/SoftEtherVPN/SoftEtherVPN_Stable.git"
    SOFTETHER_VERSION="v4.39-9772-beta"
    LATEST=true
  else
    SOFTETHER_REPOSITORY="https://github.com/SoftEtherVPN/SoftEtherVPN.git"
    SOFTETHER_VERSION="5.02.5180"
    LATEST=false
  fi

  #sudo docker buildx prune -f

  for MODE in vpnclient vpnserver
  do
    LATEST_TAG=""
    if [ "$LATEST" = true ]; 
    then 
      LATEST_TAG="--tag oriolrius/softether-${MODE}:latest"
    fi

    sudo docker buildx build \
      --platform linux/amd64,linux/arm64 \
      --build-arg SOFTETHER_VERSION="${SOFTETHER_VERSION}" \
      --build-arg SOFTETHER_REPOSITORY="${SOFTETHER_REPOSITORY}" \
      --build-arg MODE="${MODE}" \
      --build-arg BUILD_DATE="$(date +"%Y-%m-%dT%H:%M:%SZ")" \
      --tag oriolrius/softether-${MODE}:${SOFTETHER_VERSION} \
       \
      --push \
      .
  done
done