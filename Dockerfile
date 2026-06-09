FROM node:18-alpine
COPY . /starbucks
WORKDIR /starbucks
RUN npm install
CMD ["npm","start"]
EXPOSE 3000
