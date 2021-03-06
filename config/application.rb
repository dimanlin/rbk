require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rbk
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.autoload_paths += %W( lib/ )
    config.active_job.queue_adapter = :sidekiq
    config.i18n.default_locale = :ru
    config.time_zone = "Europe/Moscow"
  end
end
