# Docker

Docker is a container virtualization software. Docker can be used in a wide variety of scenarios; we are mainly focusing on the developer aspect. For our use case Docker is useful for hosting a wide variety of software environments on a single machine.

## Pre-requisites

* Docker CE: free to install on Linux, Mac and Windows

## Starting Elasticsearch and Kibana on Docker

See the files in [Elasticsearch](./Elasticsearch) directory.

* The _docker-compose_ file describes our cluster of two services.
* The directories contain a custom image _Dockerfile_ based on the official base images and adding a customized configuration file to the image.

To start the services issue the `docker-compose up` command in the directory with the compose file. Elasticsearch will be available on <http://localhost:9200> (it has a REST API, so opening the address in a browser yields only basic cluster information); you can open Kibana with a browser at <http://localhost:5601>. To stop the clusters, press CTRL-C.

## Starting Redis and a Python web app on Docker

In this example we use Redis in-memory database to count our website visitors. The website is written in Python.

See the files in [Redis-python](./Redis-python) directory.

* The docker-compose.yml describes our cluster of two services: one Python web app and a Redis instance.
* The latter one is started from an official image, while the former one is built using a Dockerfile.
* Since the applications need to communicate with each other, there is a virtual network connecting the two.
* The Python web app is a single py file.

To start the services issue the `docker-compose up` command in the directory with the compose file. The web app is available at <http://localhost:5000.>

## Further reading material

* https://docs.docker.com/get-started/
* https://www.tutorialspoint.com/docker/
* https://docker-curriculum.com/