# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'minitest/autorun'
require 'hltv_scrap'

module TestHelper
  FIXTURE = File.expand_path('fixtures/results.html', __dir__)

  def results_fixture
    File.read(FIXTURE)
  end
end
