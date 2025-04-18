FROM node:22-slim AS build
RUN apt-get update && apt-get install -y build-essential git python3 make g++
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/
COPY strapi/package.json strapi/package-lock.json ./
RUN npm install
ENV PATH=/opt/node_modules/.bin:$PATH

WORKDIR /opt/app
COPY strapi/. .
RUN npm run build

FROM node:22-slim
RUN apt-get update && apt-get install -y libvips-dev
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/
COPY --from=build /opt/node_modules ./node_modules

WORKDIR /opt/app
COPY --from=build /opt/app ./
ENV PATH=/opt/node_modules/.bin:$PATH

RUN chown -R node:node /opt/app
USER node
EXPOSE 1337
CMD ["npm", "run", "start"]
