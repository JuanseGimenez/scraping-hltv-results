#!/usr/bin/ruby

require 'open-uri'
require 'nokogiri'
require 'json'

url = 'https://www.hltv.org/results'
html = open(url)
parse_page = Nokogiri::HTML(html)
matches = []
parse_page.css('.results-all .result-con').each do |match|

	team1 =       match.css('.team').first.text
	crest1 =      match.css('.team1 img').first.attr('src')
	score1 =      match.css('.result-score').css('span').first.text
	team2 =       match.css('.team').last.text
	crest2 =      match.css('.team2 img').last.attr('src')
	score2=       match.css('.result-score').css('span').last.text
	map =         match.css('.star-cell .map-text').text
	event =       match.css('.event .event-name').text
	event_crest = match.css('.event img').attr('src')

	matches.push(
		team1: team1,
		crest1: crest1,
		score1: score1,
		team2: team2,
		crest2: crest2,
		score2: score2,
		map: map,
		event: event,
		event_crest: event_crest
	)

end

puts JSON.pretty_generate(matches)