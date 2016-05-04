# Copyright 2016 Google
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#      http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'telegram/bot'
require 'redd'

TELEGRAM_TOKEN    = ENV["TELEGRAM_TOKEN"]
TELEGRAM_BOT_NAME = "RedditCuteBot"

REDDIT_CLIENT_ID  = ENV["REDDIT_CLIENT_ID"]
REDDIT_SECRET     = ENV["REDDIT_SECRET"]

class CuteBot
  SUPPORTED_REDDITS = [
    "aww",
    "babygoats",
    "batty",
    "catbellies",
    "catsinboxes",
    "cute",
    "daww",
    "ferrets",
    "gifsofotters",
    "goats",
    "husky",
    "kittens",
    "otters",
    "puppies",
    "raccoons",
    "roombaww",
    "seals",
    "teefies"
  ]

  DOMAIN_WHITELIST = ["imgur", "instagram", "gfycat"]

  def initialize
    @r = Redd.it(:userless, REDDIT_CLIENT_ID, REDDIT_SECRET)
  end

  def send_message(bot, message, text)
    bot.api.send_message(chat_id: message.chat.id, text: text)
  end

  def good_domain?(domain)
    DOMAIN_WHITELIST.any? { |d| domain.include?(d) }
  end

  def post_cutes(bot, msg, subreddit)
    send_message(bot, msg, "Querying r/#{subreddit}")

    cutes = @r.get_hot(subreddit, :limit => 3)
    cutes.each do |cute|
      puts cute.domain
      next unless good_domain?(cute.domain)
      send_message(bot, msg, cute.url)
    end
  end

  Telegram::Bot::Client.run(TELEGRAM_TOKEN) do |bot|
    bot.listen do |msg|
      case msg.text
      when '/start'
        send_message(bot, msg, "Hello! To get cute type '/cute <reddit name>'")
      when '/cute'
        subreddit = SUPPORTED_REDDITS.shuffle.first
        post_cutes(bot, msg, subreddit)
      else
        subreddit = msg.text[1..-1].downcase

        puts subreddit

        if SUPPORTED_REDDITS.include?(subreddit) then
          post_cutes(bot, msg, subreddit)
        end
      end
    end
  end
end

end
