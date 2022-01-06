FROM node:15.10-alpine as build

ARG PUBLIC_URL

WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

COPY package.json ./
COPY package-lock.json ./

RUN npm ci --silent
RUN npm install react-scripts -g --silent
RUN npm install pushstate-server -g --silent

ENV PUBLIC_URL $PUBLIC_URL

COPY . ./
RUN npm run build

# start app
CMD pushstate-server -d build
