FROM node:18.20.4-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:stable-alpine-slim AS runner

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 8081

ARG APP_VERSION=0.1.0
ENV APP_VERSION=$APP_VERSION

COPY nginx.conf /etc/nginx/conf.d/nginx.conf.template
RUN envsubst '${APP_VERSION}' < /etc/nginx/conf.d/nginx.conf.template > /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]