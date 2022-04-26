FROM mhart/alpine-node:6.3

RUN mkdir -p /usr/src/app

# Prepare app directory
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN npm install

ENV NODE_ENV "production"
ENV PORT 8079
EXPOSE 8079

# Start the app
CMD ["npm", "start"]
