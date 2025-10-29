source "https://rubygems.org"

gem "rails", "8.1.1"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "sassc-rails"
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", require: false
gem "markdoc"
gem "dotenv"
gem "chatgpt-ruby"

group :development, :test do
  gem "debug", platforms: [:mri], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
  gem "error_highlight", ">= 0.6.0", platforms: [:ruby]
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
