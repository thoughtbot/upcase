# Be sure to restart your server when you modify this file.

SHOULDA_NOISE = %w(shoulda).freeze
FACTORY_BOT_NOISE = %w(factory_bot).freeze
THOUGHTBOT_NOISE = SHOULDA_NOISE + FACTORY_BOT_NOISE

Rails.backtrace_cleaner.add_silencer do |line|
  THOUGHTBOT_NOISE.any? { |dir| line.include?(dir) }
end

# You can also remove all the silencers if you're trying to debug a problem that might stem from framework code.
# Rails.backtrace_cleaner.remove_silencers!
