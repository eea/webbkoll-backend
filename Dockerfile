FROM node:8.10.0

RUN mkdir -p /webbkoll-backend

RUN \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    wget https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64.deb && \
    dpkg -i dumb-init_*.deb

#USER node

WORKDIR /webbkoll-backend

COPY . .

RUN npm install

EXPOSE 8100

CMD ["/usr/bin/dumb-init", "npm", "start"]
