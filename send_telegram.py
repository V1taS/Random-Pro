import os
import sys
import asyncio
from telegram import Bot, Update
from telegram.ext import Updater, CommandHandler, CallbackContext

telegram_bot_token = os.environ["TELEGRAM_BOT_TOKEN"]
telegram_chat_id = os.environ["TELEGRAM_CHAT_ID"]
message = sys.argv[1]

async def send_telegram_message(telegram_bot_token: str, telegram_chat_id: str, message: str):
    bot = Bot(token=telegram_bot_token)
    await bot.send_message(chat_id=telegram_chat_id, text=message)

async def main():
    await send_telegram_message(telegram_bot_token, telegram_chat_id, message)

if __name__ == "__main__":
    asyncio.run(main())