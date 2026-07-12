# frozen_string_literal: true

require 'ferrum'

module HltvScrap
  # Fetches the rendered HTML of an HLTV page.
  #
  # HLTV is behind Cloudflare, so we drive a real Chrome via Ferrum (raw CDP, no
  # chromedriver). Chrome must run headed to pass the challenge; on a server that
  # means a virtual display: `xvfb-run -a bundle exec ruby your_script.rb`.
  class Client
    RESULTS_SELECTOR = '.results-all .result-con'
    DEFAULT_TIMEOUT = 60

    def initialize(timeout: DEFAULT_TIMEOUT, headless: false)
      @timeout = timeout
      @headless = headless
    end

    def fetch(url)
      browser = build_browser
      browser.goto(url)
      wait_for_results(browser)
      browser.body
    ensure
      browser&.quit
    end

    private

    def build_browser
      Ferrum::Browser.new(
        headless: @headless,
        timeout: @timeout,
        window_size: [1920, 1080],
        browser_options: {
          'no-sandbox' => nil,
          'disable-blink-features' => 'AutomationControlled'
        }
      )
    end

    def wait_for_results(browser)
      deadline = monotonic_now + @timeout

      until browser.css(RESULTS_SELECTOR).any?
        raise TimeoutError, "results did not load within #{@timeout}s" if monotonic_now > deadline

        sleep 1
      end
    end

    def monotonic_now
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end

  class TimeoutError < StandardError; end
end
