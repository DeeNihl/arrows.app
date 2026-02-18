# Multi-stage build for arrows.app
# Stage 1: Build the application
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies (skip Cypress binary download)
ENV CYPRESS_INSTALL_BINARY=0
RUN npm ci

# Copy source code
COPY . .

# Build the arrows-ts application
RUN npx nx build arrows-ts --prod

# Stage 2: Production image with nginx
FROM nginx:alpine

# Copy built application from builder stage
COPY --from=builder /app/dist/apps/arrows-ts /usr/share/nginx/html

# Copy nginx configuration
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
