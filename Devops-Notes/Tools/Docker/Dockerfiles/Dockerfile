FROM node:lts-bookworm-slim
WORKDIR /app
COPY package*.json /app/
RUN npm install 

COPY . /app/
COPY . /app/
EXPOSE 3500
CMD ["node", "index.js"]