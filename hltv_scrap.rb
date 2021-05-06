require 'byebug'
require 'json'
require 'nokogiri'
require 'rest-client'

class HltvScrap
	URL = 'https://hltv.org/results'.freeze

	def self.get_results
		html = RestClient.get URL
		parse_page = Nokogiri::HTML(html.body)

		matches = parse_page.css('.results-all .result-con').each_with_object([]) do |match, obj|
			obj << {
				team1: match.css('.team').first.text,
				crest1: match.css('.team1 img').first.attr('src'),
				score1: match.css('.result-score').css('span').first.text,
				team2: match.css('.team').last.text,
				crest2: match.css('.team2 img').last.attr('src'),
				score2: match.css('.result-score').css('span').last.text,
				map: match.css('.star-cell .map-text').text,
				event: match.css('.event .event-name').text,
				event_crest: match.css('.event img').attr('src').value
			}
		end
	end
end