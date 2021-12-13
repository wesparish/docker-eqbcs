# About
Builds a Linux version of EQBCS (EQ Box Chat. Private Chat Relay server for EQ bots)

Note: Code is an old open source file, unsure of where it came from, was from an old zip file I had

# How to use this image
```console
docker run --rm -ti -p 2112:2112 --entrypoint /bin/bash wesparish/docker-eqbcs:eqbcs-1.2.v1
```

# Environment variables
|Environment Variable|Default|
|--------------------|-------|
|EQBCS_PORT          |2112   |
|EQBCS_ADDR          |0.0.0.0|

# User
This image runs as UID 1000, "eqbcs" user
