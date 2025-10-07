# Dockerfile for processor
FROM node:18-alpine

RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

WORKDIR /usr/src/app

COPY --chown=appuser:appgroup ../apps/processor/package*.json ./
RUN npm install

COPY --chown=appuser:appgroup ../apps/processor/ ./

USER appuser

CMD [ "npm", "start" ]

