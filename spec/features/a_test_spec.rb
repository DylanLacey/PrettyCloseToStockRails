require "rails_helper"

describe "A test with PB", :type => :feature, :js => true do
  it "Manages to load Google" do
    puts "The driver is #{Capybara.current_driver}"
    visit "/"
  end
end