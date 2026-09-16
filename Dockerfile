
# 1. Building Stage 

# Current active LTS according to node.js
FROM node:24-alpine AS builder
WORKDIR /app
COPY package*.json ./

# Use npm ci to ensure you used the same dependencies as before
RUN npm ci
COPY . .

# Remove devDependencies
RUN npm prune --production      

# 2. Production stage

# Production build
FROM node:24-alpine
WORKDIR /app
ENV NODE_ENV=production \ PORT=3000
COPY --chown=node:node --from=builder /app/node_modules ./node_modules
COPY --chown=node:node --from=builder /app/package*.json ./
COPY --chown=node:node --from=builder /app/server.js ./

# Run user as non-root for security
USER node
EXPOSE 3000

CMD [ "node", "server.js"]