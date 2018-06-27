require "rails_helper"

module SauceCapybara
  class Driver < Capybara::Selenium::Driver
    # No need to clean up after sessions & no need to wait until all
    # processes have ended to call close (and doing so can cause timeout
    # problems on Sauce) so just quit now.
    def reset!
      quit
    end
  end
end