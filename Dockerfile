FROM node:16-alpine3.15

# Installs latest Chromium (93) package.
RUN apk add --no-cache \
      chromium \
      nss \
      freetype \
      harfbuzz \
      ca-certificates \
      ttf-freefont \
      nodejs \
      yarn

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Puppeteer v10.2.0 works with Chromium 93.
RUN yarn add puppeteer@10.2.0

# Add user so we don't need --no-sandbox.
RUN addgroup -S pptruser && adduser -S -g pptruser pptruser \
    && mkdir -p /home/pptruser/Downloads /app \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /app

# Clone source code and install dependencies
RUN apk add git
WORKDIR /home/node
RUN git clone https://github.com/survfate/valo-store-bot.git
WORKDIR /home/node/valo-store-bot
RUN npm install
#RUN npm audit fix
EXPOSE 3000
CMD npm start