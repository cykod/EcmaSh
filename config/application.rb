require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module EcmaSh
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    #
    
    config.assets.precompile += [ "editor.js" ]
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    I18n.config.enforce_available_locales = true

    if Rails.env.test?
      config.paperclip_defaults = {
        :path => "public/assets/:class/:attachment/:style/:id/:filename"
      }
    else
      config.paperclip_defaults = {
      :storage => :s3,
      :bucket => ENV['AWS_BUCKET'],
      :s3_credentials => {
        :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
        :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
      }
    }
    end

    class Rack::Zippy::AssetServer
      def has_static_extension?(path); return false; end
    end
    

    config.middleware.swap(ActionDispatch::Static, Rack::Zippy::AssetServer)

  end
end
