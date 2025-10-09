# Docker

Docker is a container virtualization software. Docker can be used in a wide variety of scenarios; we are mainly focusing on the developer aspect. For our use case Docker is useful for hosting a wide variety of software environments on a single machine.

## Pre-requisites

- Docker Desktop: free to install on Linux, Mac and Windows
- Basic command line knowledge
- Git (optional, but useful for downloading example code)

## Docker Core Concepts

### Container vs Virtual Machine

Key differences between containers and virtual machines:

| Feature | Container | Virtual Machine |
|---------|-----------|-----------------|
| Size | Smaller (MB) | Larger (GB) |
| Startup time | Seconds | Minutes |
| Resource usage | Lower | Higher |
| Isolation | Process-level | Hardware-level |
| OS kernel | Uses host kernel | Own kernel |

### Main Docker Components

- **Docker Engine**: The foundation of the Docker platform responsible for running containers
- **Docker Image**: A read-only template containing all files needed to run an application
- **Docker Container**: A running instance of a Docker image
- **Docker Registry**: Storage for Docker images (e.g., Docker Hub)
- **Dockerfile**: Text file that describes how to build a Docker image
- **Docker Compose**: Tool for defining and running multi-container applications

## Sample: Redis and a Python web app on Docker

In this example we use Redis in-memory database to count our website visitors. The website is written in Python.

- [docker-compose.yml](docker-compose.yml) describes our cluster of two services: one Python web app and a Redis instance.
- The latter one is started from an official image, while the former one is built using a [Dockerfile](Dockerfile).
- Since the applications need to communicate with each other, there is a virtual network connecting the two.
- The Python web app is a [single py file](app.py).

To start the services issue the `docker-compose up` command in the directory with the compose file. The web app is available at <http://localhost:5000>.

### Detailed Explanation of the Example

#### Dockerfile Analysis

```dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "app.py"]
```

- `FROM python:3.9-slim`: Selecting a base image (minimal Python 3.9 version)
- `WORKDIR /app`: Setting the working directory inside the container
- `COPY requirements.txt .`: Copying dependencies
- `RUN pip install...`: Installing dependencies
- `COPY . .`: Copying application files
- `CMD ["python", "app.py"]`: Application startup command

#### docker-compose.yml Analysis

```yaml
version: '3'

services:
  web:
    build: .
    ports:
      - "5000:5000"
    depends_on:
      - redis
  
  redis:
    image: redis:alpine
```

- `version: '3'`: Docker Compose file version
- `services`: Definition of services
  - `web`: The Python web application
    - `build: .`: Use local Dockerfile
    - `ports: - "5000:5000"`: Port mapping (host:container)
    - `depends_on: - redis`: Dependency on redis service
  - `redis`: Redis database
    - `image: redis:alpine`: Using official Redis image

#### app.py Analysis

```python
from flask import Flask
import redis
import os

app = Flask(__name__)
redis_client = redis.Redis(host='redis', port=6379)

@app.route('/')
def hello():
    redis_client.incr('hits')
    counter = redis_client.get('hits').decode('utf-8')
    return f'Hello World! I have been seen {counter} times.\n'

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
```

- Creating a Flask web application
- Initializing Redis client (note that the host name is 'redis', which matches the service name defined in docker-compose.yml)
- Defining a simple route that increments and returns the visit count
- Running the application on 0.0.0.0 address (all interfaces)

### Commands to Run the Example

```bash
# Start services
docker-compose up

# Start services in background
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs

# List containers
docker ps
```


## Further reading material

- https://docs.docker.com/get-started/
- https://www.tutorialspoint.com/docker/
- https://docker-curriculum.com/
