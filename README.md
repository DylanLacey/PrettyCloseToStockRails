# Preconditions

1. A sane install of Ruby 2.x (I'm using 2.3.3)
2. Bundler installed: `gem install bundler`

# Set the Environment Up

1. Install dependencies: `bundle install`
2. Set up the test DB: `rake db:migrate`
3. Set your username and access key as ENV variables `SAUCE_USERNAME` and `SAUCE_ACCESS_KEY`

# Run tests

1. `rake spec`

# Test Design
This repo is set up to demonstrate a nice, clean Sauce Labs enabled Rspec/Capybara setup.

## Capybara
Capybara is a DSL for testing; It gives a powerful interface for controlling browsers.

### Customizations
To use Capybara with Sauce Labs, we create a custom driver in `/spec/sauce_capybara.rb`.  By default, Capybara tries to reset the browser state at the end of each test, so it can use that browser again.

Since Sauce Labs recommends a single session for each test, we want to avoid this.  Plus, if your test setup creates a new driver before each test, you'll end up with either errors from trying to quit sessions twice, or extra cleanup steps at the end of sessions wasting time.

## RSpec

RSpec is a testing framework for Ruby.  It's considerably more popular then Test::Unit

### Customizations

In `/spec/sauce_helper`, we register the custom driver and create a new session before each test (line 8-56).

We capture the Session ID so we can use it with the REST ID later (line 41).

After each test, we check the success status and update it with the REST API (line 50-57)