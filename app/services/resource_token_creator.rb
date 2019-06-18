class Config
  def self.sso_salt
    ENV.fetch("SSO_SALT")
  end
end

class ResourceTokenCreator
  def initialize(heroku_uuid:, timestamp:, sso_salt:)
    @heroku_uuid = heroku_uuid
    @timestamp = timestamp
    @sso_salt = Config.sso_salt
  end

  def run
    Digest::SHA1.hexdigest(pre_token).to_s
  end

  def pre_token
    @heroku_uuid + ":" + @sso_salt + ":" + @timestamp
  end
end
