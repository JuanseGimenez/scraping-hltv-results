# frozen_string_literal: true

require 'nokogiri'
require 'time'

module HltvScrap
  # Turns the HTML of the HLTV results page into an array of match hashes.
  class Parser
    BASE_URL = 'https://www.hltv.org'

    def initialize(html)
      @document = Nokogiri::HTML(html)
    end

    def results
      @document.css('.results-all .result-con').map { |result| parse(result) }
    end

    private

    def parse(result)
      teams  = result.css('.team')
      scores = result.css('.result-score span')

      {
        match_url: match_url(result),
        team1: text(teams[0]),
        crest1: crest(result, '.team1'),
        score1: text(scores[0]),
        team2: text(teams[1]),
        crest2: crest(result, '.team2'),
        score2: text(scores[1]),
        map: text(result.at_css('.map-text')),
        event: text(result.at_css('.event-name')),
        event_crest: attr(result.at_css('.event img'), 'src'),
        date: match_date(result)
      }
    end

    def match_url(result)
      href = attr(result.at_css('a'), 'href')
      href && "#{BASE_URL}#{href}"
    end

    # Teams ship two logos (one per theme); we skip the colour-inverted one.
    def crest(result, team_selector)
      logos = result.css("#{team_selector} img")
      logo = logos.find { |img| !attr(img, 'src').to_s.include?('invert=true') }
      attr(logo || logos.first, 'src')
    end

    # Featured results at the top of the page carry no timestamp.
    def match_date(result)
      unix = result['data-zonedgrouping-entry-unix']
      return nil if unix.nil? || unix.empty?

      Time.at(unix.to_i / 1000).utc.strftime('%Y-%m-%d')
    end

    def text(node)
      node&.text.to_s.strip
    end

    def attr(node, name)
      node && node[name]
    end
  end
end
