# Docker

Docker is a container virtualization software. Docker can be used in a wide variety of scenarios; we are mainly focusing on the developer aspect. For our use case Docker is useful for hosting a wide variety of software environments on a single machine.

## Pre-requisites

- Docker Desktop: free to install on Linux, Mac and Windows

## Sample: Redis and a Python web app on Docker

In this example we use Redis in-memory database to count our website visitors. The website is written in Python.

- [docker-compose.yml](docker-compose.yml) describes our cluster of two services: one Python web app and a Redis instance.
- The latter one is started from an official image, while the former one is built using a [Dockerfile](Dockerfile).
- Since the applications need to communicate with each other, there is a virtual network connecting the two.
- The Python web app is a [single py file](app.py).

To start the services issue the `docker-compose up` command in the directory with the compose file. The web app is available at <http://localhost:5000>.

## Further reading material

- https://docs.docker.com/get-started/
- https://www.tutorialspoint.com/docker/
- https://docker-curriculum.com/
