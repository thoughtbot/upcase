SHOULDA_NOISE      = %w( shoulda )
FACTORY_BOT_NOISE = %w( factory_bot )
THOUGHTBOT_NOISE   = SHOULDA_NOISE + FACTORY_BOT_NOISE

Rails.backtrace_cleaner.add_silencer do |line|
  THOUGHTBOT_NOISE.any? { |dir| line.include?(dir) }
end

# When debugging, uncomment the next line.
# Rails.backtrace_cleaner.remove_silencers!
