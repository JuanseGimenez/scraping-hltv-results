# frozen_string_literal: true

require_relative 'test_helper'

class ParserTest < Minitest::Test
  include TestHelper

  KEYS = %i[match_url team1 crest1 score1 team2 crest2 score2 map event
            event_crest date].freeze

  def setup
    @results = HltvScrap::Parser.new(results_fixture).results
  end

  def test_returns_an_array_of_results
    assert_kind_of Array, @results
    assert_equal 6, @results.size
  end

  def test_every_result_exposes_the_full_schema
    @results.each do |result|
      assert_equal KEYS.sort, result.keys.sort
    end
  end

  def test_parses_the_first_featured_match
    first = @results.first

    assert_equal '9z', first[:team1]
    assert_equal 'PARIVISION', first[:team2]
    assert_equal '3', first[:score1]
    assert_equal '0', first[:score2]
    assert_equal 'bo5', first[:map]
    assert_equal 'XSE Pro League Guangzhou 2026', first[:event]
  end

  def test_builds_absolute_match_urls
    assert_match %r{\Ahttps://www\.hltv\.org/matches/\d+/}, @results.first[:match_url]
  end

  def test_prefers_the_non_inverted_team_crest
    @results.each do |result|
      refute_includes result[:crest1].to_s, 'invert=true'
      refute_includes result[:crest2].to_s, 'invert=true'
    end
  end

  def test_extracts_the_date_from_the_unix_timestamp
    dated = @results.find { |result| result[:date] }

    assert_equal '2026-07-12', dated[:date]
  end

  def test_featured_results_have_no_date
    assert_nil @results.first[:date]
  end
end
