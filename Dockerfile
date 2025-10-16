# Use Node.js 22 (required by n8n)
FROM node:22-alpine

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
    giflib-dev \
    librsvg-dev

# Copy the n8n source code
COPY . /usr/src/n8n

WORKDIR /usr/src/n8n

# Install pnpm
RUN npm install -g pnpm@10.18.3

# Install dependencies with increased memory
ENV NODE_OPTIONS="--max-old-space-size=4096"
RUN pnpm install --frozen-lockfile

# Build n8n
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
