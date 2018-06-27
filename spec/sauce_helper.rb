require 'selenium/webdriver'
require 'capybara/rails'
require 'capybara/rspec'
require 'sauce_whisk'
require_relative 'sauce_capybara'

RSpec.configure do |config|
  config.before :each, js: true do |scenario|
    Capybara.register_driver :remote do |app|
      capabilities = {
        browserName: "Chrome",
        platform: "Windows 7",
        version: "latest"
      }# {Put your Sauce Labs Desired Capabilities here as a hash}
      capabilities[:name] = scenario.full_description    # Give the Sauce Labs test a decent name
      
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.open_timeout = 1500  # Optional; Deals with long session start times
      
      server_url = "https://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}" +'@ondemand.saucelabs.com:443/wd/hub'
      
      SauceCapybara::Driver.new(
        app,
        browser: :remote,
        url: server_url,
        desired_capabilities: capabilities,
        http_client: client
      )
    end

    Capybara.current_driver = :remote
    Capybara.default_driver = :remote
    Capybara.javascript_driver = :remote
    jobname = scenario.full_description
    Capybara.session_name = "#{jobname} - #{ENV['platform']} - " +
    "#{ENV['browserName']} - #{ENV['version']}"
    session = Capybara.current_session
    
    # Capture the Sauce Labs job ID
    begin
      @session_id = session.driver.browser.session_id
    rescue Selenium::WebDriver::Error::UnknownError, URI::InvalidURIError
      sleep(1)
      @session_id = session.driver.browser.session_id
    end
    puts "SauceOnDemandSessionID=#{@session_id} job-name=#{jobname}" # Optional; Used for the Jenkins plugin
  end

  # Use the Sauce Labs REST API to mark jobs passed or failed
  config.after :each, js: true do |scenario|
    if scenario.exception
      SauceWhisk::Jobs.fail_job @session_id
    else
      SauceWhisk::Jobs.pass_job @session_id
    end
  end
end

    Capybara.app_host = 'http://www.google.com'
    Capybara.run_server = false