# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/players' do
  let(:player) { create(:player, name: 'Player Name', main_character: 10) }

  shared_examples 'a layout/players page' do
    context 'when player exists and is synchronized' do
      let(:player) { create(:player, :synchronized) }

      it do
        expect(response.body).not_to render_stream_source('PlayerSyncChannel') if response.successful?
      end
    end

    context 'when player exists but not synchronized' do
      let(:player) { create(:player, :desynchronized) }

      it do
        expect(response.body).to render_stream_source('PlayerSyncChannel') if response.successful?
      end
    end

    context 'when player do not exists' do
      let(:player) { build(:player) }

      it do
        expect(response.body).to render_stream_source('PlayerSyncChannel') if response.successful?
      end
    end
  end

  describe 'GET /players/:sid' do
    it do
      get player_url(player)
      expect(response).to redirect_to(battles_player_url(player))
    end
  end

  describe 'GET /players/:sid/battles' do
    before do
      # other player battles
      create_list(:battle, 10, played_at: Time.zone.now)
    end

    it_behaves_like 'a layout/players page' do
      before { get battles_player_url(player) }
    end

    it 'renders a successful response' do
      get battles_player_url(player)
      expect(response).to be_successful
    end

    it 'set page title' do
      get battles_player_url(player)
      assert_select 'title', text: 'SFBUFF - Player Name'
    end

    context 'when player have battles' do
      before do
        create_list(:battle, 7, played_at: Time.zone.now, p1: { player_sid: player.sid })
      end

      it 'render battles' do
        get battles_player_url(player)
        expect(response).to have_rendered('players/_battles')
      end

      it 'render rivals' do
        get battles_player_url(player)
        expect(response).to have_rendered('players/_rivals')
      end

      it 'render filtered counter alert' do
        get battles_player_url(player)
        assert_select 'main > div.alert', text: '7 matches found'
        assert_select 'turbo-frame#battle-list div.card', count: 7
      end
    end

    context 'when player have no battles' do
      it 'render an alert with no match found information' do
        get battles_player_url(player)
        assert_select 'main > div.alert', text: /no match found/i
        assert_select 'turbo-frame#battle-list div.card', count: 0
      end
    end

    context 'with pagination' do
      before do
        11.times { create(:battle, played_at: Time.zone.now, p1: { player_sid: player.sid }) }
      end

      it 'render an alert with the number of battles found' do
        get battles_player_url(player, page: 2)
        assert_select 'turbo-frame#battle-list div.card', count: 1
        assert_select 'main > div.alert', text: '11 matches found'
      end
    end

    context 'when filtering by played character' do
      before do
        create_list(:battle, 3, played_at: Time.zone.now, p1: { player_sid: player.sid, character: 1 })
        create_list(:battle, 2, played_at: Time.zone.now, p1: { player_sid: player.sid, character: 2 })
      end

      it 'render an alert with the number of battles found' do
        get battles_player_url(player, players_controller_battles_action: { player_character: 2 })
        assert_select 'turbo-frame#battle-list div.card', count: 2
      end
    end

    context 'when filtering by played control type' do
      before do
        create_list(:battle, 2, played_at: Time.zone.now, p1: { player_sid: player.sid, control_type: 0 })
        create_list(:battle, 3, played_at: Time.zone.now, p1: { player_sid: player.sid, control_type: 1 })
      end

      it 'render an alert with the number of battles found' do
        get battles_player_url(player, players_controller_battles_action: { player_control_type: 1 })
        assert_select 'turbo-frame#battle-list div.card', count: 3
      end
    end

    context 'when filtering by opponent character' do
      before do
        create_list(:battle, 3, played_at: Time.zone.now, p1: { player_sid: player.sid }, p2: { character: 1 })
        create_list(:battle, 2, played_at: Time.zone.now, p1: { player_sid: player.sid }, p2: { character: 2 })
      end

      it 'render an alert with the number of battles found' do
        get battles_player_url(player, players_controller_battles_action: { opponent_character: 2 })
        assert_select 'turbo-frame#battle-list div.card', count: 2
      end
    end

    context 'when filtering by opponent control type' do
      before do
        create_list(:battle, 3, played_at: Time.zone.now, p1: { player_sid: player.sid }, p2: { control_type: 0 })
        create_list(:battle, 2, played_at: Time.zone.now, p1: { player_sid: player.sid }, p2: { control_type: 1 })
      end

      it 'render an alert with the number of battles found' do
        get battles_player_url(player, players_controller_battles_action: { opponent_control_type: 0 })
        assert_select 'turbo-frame#battle-list div.card', count: 3
      end
    end

    context 'when filtering by battle_type' do
      before do
        create_list(:battle, 3, battle_type: 1, played_at: Time.zone.now, p1: { player_sid: player.sid })
        create_list(:battle, 2, battle_type: 2, played_at: Time.zone.now, p1: { player_sid: player.sid })
      end

      it 'render an alert with the number of battles found' do
        get battles_player_url(player, players_controller_battles_action: { battle_type: 1 })
        assert_select 'turbo-frame#battle-list div.card', count: 3
      end
    end

    context 'when filtering by played_at range' do
      before do
        create_list(:battle, 3, played_at: 4.days.ago, p1: { player_sid: player.sid })
        create_list(:battle, 2, played_at: Time.zone.now, p1: { player_sid: player.sid })
      end

      it 'render an alert with the number of battles found' do
        get battles_player_url(player,
                               players_controller_battles_action: { played_from: 5.days.ago, played_to: 2.days.ago })
        assert_select 'turbo-frame#battle-list div.card', count: 3
      end
    end

    context 'when it is a request from turbo-frame battle-list' do
      before do
        create_list(:battle, 3, played_at: Time.zone.now, p1: { player_sid: player.sid })
      end

      it 'not render rivals partial' do
        get battles_player_url(player), headers: { 'turbo-frame' => 'battle-list' }
        expect(response).not_to have_rendered('players/_rivals')
      end

      it 'render battles partial' do
        get battles_player_url(player), headers: { 'turbo-frame' => 'battle-list' }
        expect(response).to have_rendered('players/_battles')
      end
    end
  end

  describe 'GET /players/:sid/ranked' do
    it 'renders a successful response' do
      get ranked_player_url(player)
      expect(response).to be_successful
    end

    context 'when the player has ranked mr battles' do
      before do
        create_list(:battle, 5, :ranked,
                    played_at: Time.zone.now,
                    p1: { player_sid: player.sid, character: player.main_character, mr_variation: 1 },
                    p2: { mr_variation: -1 })
      end

      it 'renders the master rating chart' do
        get ranked_player_url(player)
        assert_select 'h4', text: 'Master Rating'
      end
    end

    context 'when the player has ranked not mr battles' do
      before do
        create_list(:battle, 5, :ranked,
                    played_at: Time.zone.now,
                    p1: { player_sid: player.sid, character: player.main_character,
                          mr_variation: nil, league_point: 100 },
                    p2: { mr_variation: nil })
      end

      it 'renders the league point chart' do
        get ranked_player_url(player)
        assert_select 'h4', text: 'League Point'
      end
    end

    context 'when the player has no ranked battles' do
      before do
        create_list(:battle, 5, :battle_hub, played_at: Time.zone.now, p1: { player_sid: player.sid })
      end

      it 'render no match alert' do
        get ranked_player_url(player)
        assert_select 'main > div.alert', text: /no match found/i
      end
    end
  end

  describe 'GET /players/:sid/matchup_chart' do
    it 'renders a successful response' do
      get matchup_chart_player_url(player)
      expect(response).to be_successful
    end
  end
end
