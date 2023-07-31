FROM node:16-alpine as base
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

FROM base as test
ENTRYPOINT npm run test

FROM nginx as runtime
COPY --from=base /app/build /usr/share/nginx/html