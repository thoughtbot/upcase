colors = {
  black: "\033[0;30m",
  red: "\033[0;31m",
  green: "\033[0;32m",
  yellow: "\033[0;33m",
  blue: "\033[0;34m",
  purple: "\033[0;35m",
  cyan: "\033[0;36m",
  reset: "\033[0;0m"
}

env_map = {
  "development" => {
    color: colors[:reset]
  },
  "staging" => {
    color: colors[:yellow]
  },
  "production" => {
    color: colors[:red]
  }
}

Pry.config.prompt = proc do |obj, nest_level, _|
  env = env_map[Rails.env]
  "(#{env[:color]}#{Rails.env}#{colors[:reset]}) #{obj}:#{nest_level}> "
end

eval(File.open(".irbrc").read)
