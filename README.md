# Preconditions

1. A sane install of Ruby 2.x (I'm using 2.3.3)
2. Bundler installed: `gem install bundler`

# Set the Environment Up

1. Install dependencies: `bundle install`
2. Set up the test DB: `rake db:migrate`
3. Set your username and access key as ENV variables `SAUCE_USERNAME` and `SAUCE_ACCESS_KEY`

# Run tests

1. `rake spec`
