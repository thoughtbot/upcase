class Forum
  def self.url(suffix = nil)
    "#{ENV["FORUM_URL"]}/#{suffix}"
  end

  def self.sso_url
    url("session/sso_login")
  end
end
