# Docker Support for arrows.app

This document describes how to build and run arrows.app using Docker.

## Prerequisites

- Docker Engine 20.10 or later
- Docker Compose 2.0 or later (optional, for using docker-compose)

## Quick Start

### Using Docker Compose (Recommended)

The easiest way to run arrows.app is using Docker Compose:

```bash
docker-compose up -d
```

The application will be available at http://localhost:8080

To stop the application:

```bash
docker-compose down
```

### Using Docker CLI

#### Build the Image

```bash
docker build -t arrows-app:latest .
```

#### Run the Container

```bash
docker run -d -p 8080:80 --name arrows-app arrows-app:latest
```

The application will be available at http://localhost:8080

#### Stop and Remove the Container

```bash
docker stop arrows-app
docker rm arrows-app
```

## Configuration

### Port Mapping

By default, the application is exposed on port 8080 on the host machine. You can change this by modifying the port mapping:

**Docker Compose:**
Edit `docker-compose.yml` and change the ports section:
```yaml
ports:
  - "3000:80"  # Maps host port 3000 to container port 80
```

**Docker CLI:**
```bash
docker run -d -p 3000:80 --name arrows-app arrows-app:latest
```

## Architecture

The Docker setup uses a multi-stage build process:

1. **Builder Stage**: Uses Node.js 18 Alpine to install dependencies and build the application
2. **Production Stage**: Uses Nginx Alpine to serve the static files

This approach results in a small, efficient production image.

## File Structure

```
.
├── Dockerfile              # Multi-stage Docker build configuration
├── docker-compose.yml      # Docker Compose configuration
├── .dockerignore          # Files to exclude from Docker build
└── docker/
    └── nginx.conf         # Nginx configuration for serving the app
```

## Troubleshooting

### Container Health Check

The container includes a health check that verifies the application is responding. You can check the health status:

```bash
docker ps
```

Look for the health status in the STATUS column.

### Viewing Logs

**Docker Compose:**
```bash
docker-compose logs -f
```

**Docker CLI:**
```bash
docker logs -f arrows-app
```

### Rebuilding After Changes

**Docker Compose:**
```bash
docker-compose build --no-cache
docker-compose up -d
```

**Docker CLI:**
```bash
docker build --no-cache -t arrows-app:latest .
docker stop arrows-app
docker rm arrows-app
docker run -d -p 8080:80 --name arrows-app arrows-app:latest
```

## Production Deployment

For production deployments, consider:

1. Using a container orchestration platform (Kubernetes, Docker Swarm, etc.)
2. Setting up proper monitoring and logging
3. Configuring SSL/TLS termination (use a reverse proxy like Traefik or nginx)
4. Implementing backup and disaster recovery procedures
5. Setting resource limits for the container

## Security Considerations

The Nginx configuration includes several security headers:
- X-Frame-Options
- X-Content-Type-Options
- X-XSS-Protection

For production use, consider adding:
- SSL/TLS certificates
- Content Security Policy headers
- Rate limiting
- Web Application Firewall (WAF)
