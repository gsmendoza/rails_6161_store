require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rails6161Store
  class Application < Rails::Application
    if Rails.autoloaders.main
      # Rails 7
      Rails.autoloaders.main.ignore(Rails.root.join('app/monkey_patches'))
    else
      # Rails 6 and older
      config.after_initialize do
        Rails.autoloaders.main.ignore(Rails.root.join('app/monkey_patches'))
      end
    end

    config.to_prepare do
      Dir.glob(Rails.root.join('app/monkey_patches/**/*_monkey_patch.rb')).each do |monkey_patch|
        load monkey_patch
      end
    end

    if defined?(FactoryBotRails)
      initializer after: "factory_bot.set_factory_paths" do
        require 'spree/testing_support'
        FactoryBot.definition_file_paths = [
          *Spree::TestingSupport::FactoryBot.definition_file_paths,
          Rails.root.join('spec/fixtures/factories'),
        ]
      end
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
