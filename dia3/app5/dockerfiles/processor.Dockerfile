# Dockerfile for processor
FROM node:18-alpine

RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

WORKDIR /usr/src/app

COPY apps/processor/package*.json ./
RUN chown appuser:appgroup package*.json
RUN npm install

COPY apps/processor/ ./
RUN chown -R appuser:appgroup .

USER appuser

CMD [ "npm", "start" ]

