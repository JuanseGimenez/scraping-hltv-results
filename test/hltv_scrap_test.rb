# frozen_string_literal: true

require_relative 'test_helper'

class HltvScrapTest < Minitest::Test
  include TestHelper

  # A stand-in for the browser client, so no network is touched.
  class FakeClient
    attr_reader :requested_url

    def initialize(html)
      @html = html
    end

    def fetch(url)
      @requested_url = url
      @html
    end
  end

  def test_results_fetches_and_parses
    client = FakeClient.new(results_fixture)

    results = HltvScrap.results(client: client)

    assert_equal 6, results.size
    assert_equal HltvScrap::RESULTS_URL, client.requested_url
  end

  def test_get_results_is_kept_as_an_alias
    client = FakeClient.new(results_fixture)

    assert_equal HltvScrap.results(client: client),
                 HltvScrap.get_results(client: FakeClient.new(results_fixture))
  end
end
