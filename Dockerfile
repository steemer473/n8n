# Use the official n8n base image or build from source
FROM node:18-alpine

# Set working directory
WORKDIR /data

# Install dependencies required for building
RUN apk add --no-cache \
    git \
    python3 \
    build-base \
    cairo-dev \
    pango-dev \
    jpeg-dev \
    giflib-dev

# Clone and build n8n from your fork (or use the repo directly)
# Note: Render will clone your repo, so we'll use the local files
COPY . /usr/src/n8n

WORKDIR /usr/src/n8n

# Install dependencies and build
RUN npm install -g pnpm
RUN pnpm install --frozen-lockfile
RUN pnpm build

# Install n8n globally
RUN npm install -g n8n

# Create data directory
RUN mkdir -p /home/node/.n8n

# Set environment variables
ENV N8N_PORT=5678
ENV NODE_ENV=production

# Expose port
EXPOSE 5678

# Start n8n
CMD ["n8n", "start"]
