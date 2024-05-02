# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Buckler::Api::Battlelog do
  subject(:battlelog) { described_class.new(client, player_sid) }

  let(:client) { instance_double(Buckler::Client) }
  let(:player_sid) { 123_456_789 }

  before do
    (1..).each_slice(2).take(11).each_with_index do |arr, i|
      allow(client).to receive(:battlelog).with(player_sid, i + 1).and_return(
        { 'pageProps' => { 'fighter_banner_info' => 'banner_info', 'replay_list' => arr } }
      )
    end
  end

  it 'iterate over the battles form page 1 to page 10' do
    expect(battlelog.to_a).to eq((1..20).to_a)
  end
end
