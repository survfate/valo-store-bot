# ValoStoreBot

A simple Discord bot that retrieves the skins on sale in one’s Valorant store. Forked from https://github.com/sudhxnva/valo-store-bot

## Fork Update:
* Added Night Market check feature for the bot
* Migrated to `Discord.js v13`
* Change `valorant.js` to use my forked package (`@survfate/valorant.js`) instead, you can view the source here: https://github.com/survfate/valorant.js
* Add support for CONTENT_LOCALE & EMBED_FOOTER to the `.env`

## Setup

1. Clone the repository from ``` https://github.com/survfate/valo-store-bot.git ```
2. Run the command `npm install` to install all dependencies.
3. Create a Discord bot on the [Discord Developer Portal](https://discord.com/developers/) and generate an access token. (refer to [this guide](https://github.com/reactiflux/discord-irc/wiki/Creating-a-discord-bot-&-getting-a-token))
4. Create a `.env` file in the root folder with the following values:

   ```
   SECRET = "random_string_to_encrypt_passwords"
   BOT_TOKEN = "your_discord_bot_token"
   DB_URL = "mongoDB_connection_string"
   CONTENT_LOCALE = "the_content_locale_string"
   EMBED_FOOTER = "your_custom_embed_footer_string"
   ```
   (Available locales: `"ar-AE", "de-DE", "en-US", "es-ES", "es-MX", "fr-FR", "id-ID", "it-IT", "ja-JP", "ko-KR", "pl-PL", "pt-BR", "ru-RU", "th-TH", "tr-TR", "vi-VN", "zh-CN", "zh-TW"`)

   (The bot will need a MongoDB instance)
5. Run the bot using `npm start`
   For development, you can use `npm run dev` (runs with nodemon). The bot will listen to the command `!test` instead of `!store` in dev mode.

   For deploy with Docker, check the next section.

## Docker Compose deploy option (Recommended):

1. Create a `docker-compose.yml` file with the content like below in a location of choice
   ```
   ---
   version: "2.1"
   services:
   mongo:
      image: mongo:4.4.10-focal
      container_name: valo-mongo
      volumes:
         - ./dump:/dump
      ports:
         - 27017:27017
   valostorebot:
      build: .
      container_name: valostorebot
      volumes:
         - ./.env:/home/node/valo-store-bot/.env
      ports:
         - 8844:3000
      depends_on: 
         - mongo
      restart: unless-stopped
   ```
2. Start both the MongoDB and the bot containers in detach mode with `docker compose up -d`

## Docker deploy option:

1. Run `docker run --name valo-mongo -d -p 27017:27017 mongo:4.4.10-focal` to deploy a MongoDB docker instance
2. Download the `Dockerfile` into your location of choice that already contained the `.env` file (check the below section), `cd` into that path
3. Run `docker build -t valostorebot .` to build a local Docker image of the bot
4. Add `DB_URL = "mongodb://mongo:27017/valostorebot"` to the `.env` file, this make the bot container able to see and connect to the MongoDB docker instance
5. Start the bot container in detach mode with `docker run --restart unless-stopped --name valostorebot -d -p 8844:3000 -v $(pwd)/.env:/home/node/valo-store-bot/.env --link valo-mongo:mongo valostorebot`

## Backup & Restore MongoDB Docker container

* For Backup:
```
docker exec -i valo-mongo /usr/bin/mongodump --db valostorebot --out /dump
docker cp valo-mongo:/dump ./dump
```
(the `./dump` directory then can be restored with the below commands)

* For Restore:
```
docker exec -i valo-mongo /usr/bin/mongorestore ./dump
```

## Usage

`!store` command on a server to retrieve the store. 

![screenshot-discord com-2023 01 02-01_30_28](https://user-images.githubusercontent.com/10634948/210181719-0f836bd1-6440-4c69-8353-1f565cbc4678.png)

`!market` command on a server to retrieve the current Night Market.

![screenshot-discord com-2023 01 02-01_32_11](https://user-images.githubusercontent.com/10634948/210181628-6d4b1096-7a2e-4b0e-9dcd-aa0cb066c9a7.png)

If a user is calling the command for the first time, they will be prompted to enter their details on a Discord DM chat with the bot.

![screenshot-discord com-2023 01 02-01_47_21](https://user-images.githubusercontent.com/10634948/210181727-82b95d88-747b-4d37-a4bc-8dfac698f6f0.png)

![screenshot-discord com-2023 01 02-01_35_21](https://user-images.githubusercontent.com/10634948/210181737-4291aaaf-5032-43e2-8703-85a19b15ba96.png)

Once registered, the user will not have to enter their details again. The `!store` command should work smoothly.

**Note**: This implementation of the bot was designed for a small Discord server with my friends in it. Hence, it encrypts the password and stores it in a DB so that a user doesn’t have to type in their credentials every single time. The app is only encrypting the password, **NOT** hashing it (read the difference [here](https://security.stackexchange.com/a/122606)). So this won’t suit big servers where people are not comfortable with their passwords being stored in a random user’s database (A solution to this is that you can modify it to only store the username and ask them to enter their password every time).

## Credits

- [Valorant.js](https://github.com/Sprayxe/valorant.js/) (A brilliant easy-to-use library for Valorant) by [Sprayxe](https://github.com/Sprayxe)
- Inspiration for this bot from [this project](https://github.com/OwOHamper/Valorant-item-shop-discord-bot) (thanks [OwOHamper](https://github.com/OwOHamper)!)
