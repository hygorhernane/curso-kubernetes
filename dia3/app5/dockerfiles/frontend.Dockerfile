# Dockerfile for frontend
FROM node:18-alpine

RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

WORKDIR /usr/src/app

COPY --chown=appuser:appgroup ../apps/frontend/package*.json ./
RUN npm install

COPY --chown=appuser:appgroup ../apps/frontend/ ./

USER appuser

EXPOSE 3000
CMD [ "npm", "start" ]

