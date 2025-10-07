# Dockerfile for metric-generator
FROM node:18-alpine

RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

WORKDIR /usr/src/app

COPY --chown=appuser:appgroup ../apps/metric-generator/package*.json ./
RUN npm install

COPY --chown=appuser:appgroup ../apps/metric-generator/ ./

USER appuser

CMD [ "npm", "start" ]

