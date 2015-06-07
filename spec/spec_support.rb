def toggle_i18n_test_files(active)
  folder = active ? "spec/i18n" : "lib/responsys/i18n"

  I18n.load_path = Dir.glob(Pathname.new(__FILE__).parent.parent.to_s + "/#{folder}/*.yml")

  I18n.reload!
  I18n.locale = I18n.default_locale
end

def configure_gem(credentials = get_credentials)
  Responsys.configure do |config|
    config.settings = {
      username: credentials["username"],
      password: credentials["password"],
      login_endpoint: credentials["login_endpoint"],
      debug: DEBUG
    }
  end
end

def get_credentials
  if File.exist?("#{File.dirname(__FILE__)}/api_credentials.yml")
    file = "api_credentials.yml"
  else
    file = "api_credentials.sample.yml"
  end

  YAML.load_file("#{File.dirname(__FILE__)}/#{file}")
end

def set_incorrect_credentials
  configure_gem(
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