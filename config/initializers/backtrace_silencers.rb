SHOULDA_NOISE = %w(shoulda).freeze
FACTORY_BOT_NOISE = %w(factory_bot).freeze
THOUGHTBOT_NOISE = SHOULDA_NOISE + FACTORY_BOT_NOISE

Rails.backtrace_cleaner.add_silencer do |line|
  THOUGHTBOT_NOISE.any? { |dir| line.include?(dir) }
end

# When debugging, uncomment the next line.
# Rails.backtrace_cleaner.remove_silencers!
