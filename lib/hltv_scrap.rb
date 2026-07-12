# frozen_string_literal: true

require_relative 'hltv_scrap/client'
require_relative 'hltv_scrap/parser'

# Scrapes finished match results from https://www.hltv.org/results.
module HltvScrap
  RESULTS_URL = 'https://www.hltv.org/results'

  class << self
    def results(url: RESULTS_URL, client: Client.new)
      Parser.new(client.fetch(url)).results
    end
    alias get_results results
  end
end
