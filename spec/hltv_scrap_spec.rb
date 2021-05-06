require 'spec_helper'
require_relative '../hltv_scrap'

describe '#HLTV Scrap' do
  let(:hltv_scrap) { HltvScrap.get_results }

  it 'should be valid data' do
    expect(hltv_scrap).to be_an_instance_of(Array)
    expect(hltv_scrap.first).to have_key(:team1)
    expect(hltv_scrap.first).to have_key(:crest1)
    expect(hltv_scrap.first).to have_key(:score1)
    expect(hltv_scrap.first).to have_key(:team2)
    expect(hltv_scrap.first).to have_key(:crest2)
    expect(hltv_scrap.first).to have_key(:score2)
    expect(hltv_scrap.first).to have_key(:map)
    expect(hltv_scrap.first).to have_key(:event)
    expect(hltv_scrap.first).to have_key(:event_crest)
  end
end