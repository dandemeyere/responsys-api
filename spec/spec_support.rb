def toggle_i18n_test_files(active)
  folder = active ? "spec/i18n" : "lib/responsys/i18n"

  I18n.load_path = Dir.glob(Pathname.new(__FILE__).parent.parent.to_s + "/#{folder}/*.yml")

  I18n.reload!
  I18n.locale = I18n.default_locale
end

def configure_gem(type = :internal, credentials = get_credentials)
  pool_settings = { size: 1, timeout: 5, type: :internal }

  if type == :redis
    pool_settings.merge!({ type: :redis }.merge!(REDIS))
  end

  Responsys.configure do |config|
    config.settings = {
      username: credentials["username"],
      password: credentials["password"],
      login_endpoint: credentials["login_endpoint"],
      debug: DEBUG,
      connection_pool: pool_settings
    }
  end
end

def get_credentials
  get_sampled_file("api_credentials")
end

def get_redis_settings
  get_sampled_file("redis")
end

def get_sampled_file(name, extension = ".yml")
  if File.exist?("#{File.dirname(__FILE__)}/#{name}#{extension}")
    file = "#{name}#{extension}"
  else
    file = "#{name}.sample#{extension}"
  end

  YAML.load_file("#{File.dirname(__FILE__)}/#{file}")
end

def set_incorrect_credentials
  configure_gem(
    :internal,
    {
      "username" => "fake",
      "password" => "fake",
      "login_endpoint" => "https://login5.responsys.net"
    }
  )
end

def set_correct_credentials
  configure_gem
end