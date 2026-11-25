
# Stage 1: Build dependencies
FROM node:22-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy application source
COPY app.js server.js ./

# Remove development dependencies
RUN npm prune --omit=dev


# Stage 2: Production image
FROM node:22-alpine AS production

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

# Copy production dependencies and application
COPY --from=builder --chown=node:node /app/package*.json ./
COPY --from=builder --chown=node:node /app/node_modules ./node_modules
COPY --from=builder --chown=node:node /app/app.js ./
COPY --from=builder --chown=node:node /app/server.js ./

# Run as non-root user
USER node

EXPOSE 3000

CMD ["node", "server.js"]
