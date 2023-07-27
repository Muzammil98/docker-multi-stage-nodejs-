## base -- Stage 1
FROM node:18 AS base

WORKDIR /app

COPY package* .
    
RUN npm install

COPY . .


## for lint -- Stage 2

FROM base AS linter

WORKDIR /app

RUN npm run lint


## for build -- Stage 3

FROM linter AS builder

WORKDIR /app

RUN npm run build


## for production -- Stage 4

FROM node:slim
# FROM gcr.io/distroless/nodejs18-debian11

WORKDIR /app

COPY package* .

RUN npm install --only=production

COPY --from=builder /app/dist ./

EXPOSE 8081

ENTRYPOINT ["npm","start"]