# OTRS for docker

This is a home of mainly test image of OTRS 5 which runs PostgreSQL

# Setup

Image is created as automated build, so could easily be pulled:

```
docker pull uolcz/otrs-for-docker
```

For additional setup please see (PostgreSQL)[https://hub.docker.com/_/postgres/], where they describe couple options you can setup like:

```
POSTGRES_PASSWORD

POSTGRES_USER

POSTGRES_DB
```

Which you can customize and the put in postgres block in `docker-compose.yml`
and then you have to change them respectively in `Config.pm` in the beginning
in block `database settings` (second one is default OTRS config coppied in
container)

if changing these constants, please build image yourself like so:

```
sudo docker build -t your/name_here .
```

After build success you can replace `otrs: -> image:` in docker compose with
`your/name_here` name you build your container with and there you go...

Or enter your newly build image with:

```
sudo docker run -it  -p 80:80 your/name_here
```

Or run it detached like so:

```
sudo docker run -it  -p 80:80 -d your/name_here
```


# Usage

Made for testing purposes of experimental OTRS features and runs without
POSTFIX setup, but still you can get much out of it simply by using
`docker-compose.yml` in this repo like so:

```
docker-compose build
```

to first build necessary (all goes from images, so should be quick or not at all), then just run:

```
docker-compose up
```

And your OTRS has to be setup first on:

```
http://localhost/otrs/installer.pl
```

then do not forget you are running PostgreSQL in setup steps and you login
information for DB there.

After setup success you can access OTRS on:

```
http://localhost/otrs/index.pl
```

# NOTICE

You may actually need to run docker/docker-compose with `sudo`, varies
according to your local settings...

Also this image was neve rintended for production usage, purely testing purposes
