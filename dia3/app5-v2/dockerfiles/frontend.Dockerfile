# Dockerfile for frontend
FROM node:18-alpine

RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

WORKDIR /usr/src/app

COPY apps/frontend/package*.json ./
RUN chown appuser:appgroup package*.json
RUN npm install

COPY apps/frontend/ ./
RUN chown -R appuser:appgroup .

USER appuser

EXPOSE 3000
CMD [ "npm", "start" ]

