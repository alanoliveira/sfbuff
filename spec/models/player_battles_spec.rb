# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerBattles do
  subject(:player_battles) { described_class.fetch(player_sid) }

  let(:player_sid) { 111 }
  let(:opponent1_sid) { 222 }
  let(:opponent2_sid) { 333 }

  before do
    create(:battle,
           battle_type: 4,
           played_at: Time.utc(2024, 1, 1, 13, 0),
           p1: { player_sid:, character: 1, control_type: 0 },
           p2: { player_sid: opponent1_sid, character: 2, control_type: 0 })

    create(:battle,
           battle_type: 1,
           played_at: Time.utc(2024, 1, 1, 13, 10),
           p1: { player_sid:, character: 1, control_type: 1 },
           p2: { player_sid: opponent1_sid, character: 3, control_type: 0 })

    create(:battle,
           battle_type: 1,
           played_at: Time.utc(2024, 1, 2, 14, 0),
           p1: { player_sid: opponent1_sid, character: 2, control_type: 1 },
           p2: { player_sid:, character: 4, control_type: 0 })

    create(:battle,
           battle_type: 1,
           played_at: Time.utc(2024, 1, 2, 14, 30),
           p1: { player_sid: opponent2_sid, character: 3, control_type: 1 },
           p2: { player_sid: opponent1_sid, character: 2, control_type: 0 })
  end

  it 'returns battles where the player participated' do
    expect(player_battles.count).to eq(3)
  end

  it 'filter battles by character' do
    expect(player_battles.using_character(1).count).to eq(2)
  end

  it 'filter battles by control type' do
    expect(player_battles.using_control_type(0).count).to eq(2)
  end

  it 'filter battles by opponent character' do
    expect(player_battles.vs_character(2).count).to eq(2)
  end

  it 'filter battles by opponent control type' do
    expect(player_battles.vs_control_type(1).count).to eq(1)
  end

  it 'filter battles by battle type' do
    expect(player_battles.battle_type(1).count).to eq(2)
  end

  it 'filters battles by date' do
    expect(player_battles.played_at(Time.utc(2024, 1, 1, 13, 0)).count).to eq(1)
  end

  it 'filters battles by date range' do
    expect(player_battles.played_at(Time.utc(2024, 1, 1).all_day).count).to eq(2)
  end
end
