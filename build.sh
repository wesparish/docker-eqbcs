#!/bin/bash

usage() { echo "Usage: $0 [-p (disable push)] " \
               "[-r <registry> (default: wesparish)] " \
               "[-i <image name> (default: $(basename $PWD))] " \
               "[-a <additional private registry> (default: none)]" 1>&2; exit 1; }

function cleanup {
  echo "Cleaning up..."
  rm  -rf $(dirname $dockerfile)/${appDir}/
}
trap cleanup EXIT

# Defaults
push=true
registry="wesparish"
imagename="$(basename $PWD)"
privateRegistry=
appDir=eqbcs-cpp
echo "Args: push: $push, registry: $registry, imagename: $imagename, privateRegistry: $privateRegistry"

while getopts ":pr:i:a:" o; do
    case "${o}" in
        p)
            push=
            ;;
        r)
            registry=${OPTARG}
            ;;
        i)
            imagename=${OPTARG}
            ;;
        a)
            privateRegistry=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

echo "Args: push: $push, registry: $registry, imagename: $imagename, privateRegistry: $privateRegistry"

buildDate=$(date +%Y-%m-%d-%H%M%S)

set -e

for dockerfile in $(find  -name Dockerfile); do
  g++ -o $(dirname $dockerfile)/eqbcs ${appDir}/eqbcs.cpp
  versionvariant=$(dirname $dockerfile | sed -e 's|^./||g' -e 's|/|-|g')
  echo Building variant: $versionvariant
  echo docker build -t $registry/${imagename}:${versionvariant} $(dirname $dockerfile)
  docker build -t $registry/${imagename}:$versionvariant $(dirname $dockerfile)
  [ $push ] && echo docker push $registry/${imagename}:${versionvariant}
  [ $push ] && docker push $registry/${imagename}:$versionvariant

  docker tag $registry/${imagename}:${versionvariant} $registry/${imagename}:${versionvariant}-${buildDate}
  [ $push ] && echo docker push $registry/${imagename}:${versionvariant}-${buildDate}
  [ $push ] && docker push $registry/${imagename}:${versionvariant}-${buildDate}

  if [ -n "$privateRegistry" ] ; then
    echo docker tag $registry/${imagename}:${versionvariant} ${privateRegistry}/${imagename}:${versionvariant}
    docker tag $registry/${imagename}:$versionvariant ${privateRegistry}/${imagename}:$versionvariant
    [ $push ] && echo docker push ${privateRegistry}/${imagename}:${versionvariant}
    [ $push ] && docker push ${privateRegistry}/${imagename}:$versionvariant

    docker tag $registry/${imagename}:${versionvariant} $registry/${imagename}:${versionvariant}-${buildDate}
    [ $push ] && echo docker push $registry/${imagename}:${versionvariant}-${buildDate}
    [ $push ] && docker push $registry/${imagename}:${versionvariant}-${buildDate}
  fi
done

set +e
