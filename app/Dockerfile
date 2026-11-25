FROM node:22-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

COPY . .

FROM node:22-alpine AS runtime

WORKDIR /app

ENV NODE_ENV=production

RUN rm -rf /usr/local/lib/node_modules/npm \
    /usr/local/lib/node_modules/corepack \
    /opt/yarn-* \
    /usr/local/bin/npm \
    /usr/local/bin/npx \
    /usr/local/bin/yarn \
    /usr/local/bin/yarnpkg \
    /usr/local/bin/corepack

COPY --from=builder --chown=node:node /app /app

USER node

EXPOSE 3000

CMD ["node", "src/index.js"]
