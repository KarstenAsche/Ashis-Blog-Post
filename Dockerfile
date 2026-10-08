FROM node:26-alpine as builder

WORKDIR /app

ARG BLOG_ENABLED=false
ARG DEPLOYMENT_URL="https://karstenasche.github.io"
ARG DEPLOYMENT_BRANCH="main"
ARG GITHUB_ORG="Karsten Asche"
ARG GITHUB_PROJECT="ashis-blog-post"

COPY . $WORKDIR

RUN npm ci && npm run build

FROM nginx:latest as runner

COPY --from=builder /app/build /usr/share/nginx/html