# Stage 1: Build React app
FROM node:18-alpine AS build

ARG REACT_APP_API_URL=http://localhost:8001
ARG REACT_APP_SOCKET_URL=http://localhost:8001
ARG REACT_APP_SERVER_BASE_URL=http://localhost:8001

ENV REACT_APP_API_URL=${REACT_APP_API_URL}
ENV REACT_APP_SOCKET_URL=${REACT_APP_SOCKET_URL}
ENV REACT_APP_SERVER_BASE_URL=${REACT_APP_SERVER_BASE_URL}
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# Stage 2: Serve with nginx
FROM nginx:1.25-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf *
COPY --from=build /app/build .
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
