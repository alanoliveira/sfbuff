# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Buckler::Api do
  let(:api) { described_class.new(client) }
  let(:client) { instance_double(Buckler::Client) }

  def mock_fighter_banner(**params)
    {
      'favorite_character_league_info' => {
        'league_point' => params.fetch(:league_point, 0)
      }
    }
  end

  describe '#battlelog' do
    context 'when player_sid is valid' do
      it 'returns an instance of Battlelog' do
        expect(api.battlelog(123_456_789)).to be_a(Buckler::Api::Battlelog)
      end
    end

    context 'when player_sid is invalid' do
      it 'raises an ArgumentError' do
        expect { api.battlelog(123_456_78) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#search_player_by_sid' do
    let(:player_sid) { 123_456_789 }
    let(:fighter_banner_list) { [mock_fighter_banner] }

    before do
      result = { 'pageProps' => { 'fighter_banner_list' => fighter_banner_list } }
      allow(client).to receive(:fighterslist).with({ short_id: player_sid }).and_return(result)
    end

    it 'returns the fighter data' do
      expect(api.search_player_by_sid(player_sid)).to eq(fighter_banner_list.first)
    end

    context 'when the fighter not found' do
      before do
        result = { 'pageProps' => { 'fighter_banner_list' => [] } }
        allow(client).to receive(:fighterslist).with({ short_id: player_sid }).and_return(result)
      end

      it 'returns nil' do
        expect(api.search_player_by_sid(player_sid)).to be_nil
      end
    end
  end

  describe '#search_players_by_name' do
    let(:name) { 'player1' }

    let(:fighter_banner_list) { 2.times.map { mock_fighter_banner } }

    before do
      result = { 'pageProps' => { 'fighter_banner_list' => fighter_banner_list } }
      allow(client).to receive(:fighterslist).with({ fighter_id: name }).and_return(result)
    end

    it 'returns an Enumerator with all matching fighters' do
      expect(api.search_players_by_name(name).to_a).to eq(fighter_banner_list)
    end

    context 'when the list have players that never played online' do
      let(:fighter_banner_list) { 2.times.map { mock_fighter_banner }.append(mock_fighter_banner(league_point: -1)) }

      it 'filter out that players' do
        expect(api.search_players_by_name(name).to_a).to have_attributes(count: 2).and all(
          include('favorite_character_league_info' => { 'league_point' => a_value >= 0 })
        )
      end
    end

    context 'when the given name is too short' do
      it 'raises an ArgumentError' do
        expect { api.search_players_by_name('p1') }.to raise_error(ArgumentError)
      end
    end
  end
end
