class HostMap
  def initialize(mappings)
    @mappings = mappings
  end

  def call(env)
    app_for(env["SERVER_NAME"]).call(env)
  end

  private

  def app_for(server_name)
    @mappings[server_name] || NOT_FOUND
  end

  NOT_FOUND = lambda do |env|
    [
      404,
      { "Content-Type" => "text/html" },
      ["Unmapped server name: #{env["SERVER_NAME"]}"]
    ]
  end
end
