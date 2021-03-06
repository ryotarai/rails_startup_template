if yes?("Use another template engine instead of erb?")
  template_engine = ask('What name is the template engine? (e.g. slim or haml)')
  gem "#{template_engine}-rails"
end
use_bootstrap = yes?('Install twitter bootstrap?')

gem "therubyracer"
gem "less-rails"
gem "twitter-bootstrap-rails" if use_bootstrap

# Simple form builder (https://github.com/plataformatec/simple_form)
gem "simple_form"

gem_group :development, :test do
  gem "rspec-rails"

  gem 'spork-rails', github: 'sporkrb/spork-rails'

  gem 'growl'

  gem 'guard-rspec'
  gem 'guard-spork', github: 'guard/guard-spork'

  gem "capybara" 
  gem "capybara-webkit"

  gem "factory_girl_rails"
end

run "echo 'web: bundle exec rails server -p $PORT' >> Procfile"
run "echo PORT=3000 >> .env"
run "echo '.env' >> .gitignore"

run "echo 'STDOUT.sync = true' >> config/environments/development.rb"


run "bundle install"

run "bundle exec rails generate rspec:install"
run "bundle exec spork --bootstrap"
run "bundle exec guard init spork"
run "bundle exec guard init rspec"

# Install bootstrap
if use_bootstrap
  run "bundle exec rails generate bootstrap:install less"

  if yes?("Use fixed bootstrap layout?")
    run "bundle exec rails g bootstrap:layout -f application fixed"
  elsif yes?("Use fluid bootstrap layout?")
    run "bundle exec rails g bootstrap:layout -f application fluid"
  end

  remove_file "app/views/layouts/application.html.erb"
  remove_file "app/assets/stylesheets/scaffolds.css.scss"
end


# Install simple_form
run "bundle exec rails generate simple_form:install --bootstrap"

run "echo 'body { padding-top: 60px; }' >> app/assets/stylesheets/bootstrap_and_overrides.css.less"

puts "TODO: Edit spec_helper.rb"



