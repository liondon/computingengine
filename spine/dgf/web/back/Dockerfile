FROM node:alpine
WORKDIR /usr/src/app
COPY src/package*.json ./
RUN mkdir /DATA
RUN npm install
COPY src .

CMD [ "npm", "start" ]



