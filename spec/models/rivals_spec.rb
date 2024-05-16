# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rivals do
  subject(:rivals) { described_class.new(player.battles) }

  let(:player) { create(:player) }

  before do
    me = { player_sid: player.sid }
    create_list(:battle, 8, winner_side: 1, p1: me, p2: { player_sid: 222, character: 1, control_type: 0 })
    create_list(:battle, 2, winner_side: 2, p1: me, p2: { player_sid: 222, character: 1, control_type: 0 })
    create_list(:battle, 1, winner_side: 1, p1: me, p2: { player_sid: 222, character: 2, control_type: 0 })
    create_list(:battle, 7, winner_side: 1, p1: me, p2: { player_sid: 333, character: 2, control_type: 1 })
    create_list(:battle, 9, winner_side: 1, p1: me, p2: { player_sid: 444, character: 3, control_type: 1 })
    create_list(:battle, 9, winner_side: 2, p1: me, p2: { player_sid: 444, character: 3, control_type: 1 })
    create_list(:battle, 2, winner_side: nil, p1: me, p2: { player_sid: 444, character: 3, control_type: 1 })
    create_list(:battle, 4, winner_side: 1, p1: me, p2: { player_sid: 555, character: 4, control_type: 0 })
    create_list(:battle, 4, winner_side: 2, p1: me, p2: { player_sid: 555, character: 4, control_type: 0 })
    create_list(:battle, 8, winner_side: 2, p1: me, p2: { player_sid: 666, character: 3, control_type: 0 })
    create_list(:battle, 6, winner_side: 2, p1: me, p2: { player_sid: 777, character: 2, control_type: 0 })
    create_list(:battle, 1, winner_side: 1, p1: me, p2: { player_sid: 777, character: 2, control_type: 0 })
    create_list(:battle, 1, winner_side: 1, p1: me, p2: { player_sid: 888, character: 3, control_type: 0 })
    create_list(:battle, 9, winner_side: 1, p1: me, p2: { player_sid: 999, character: 1, control_type: 0 })
    create_list(:battle, 9, winner_side: 1, p1: me, p2: { player_sid: 999, character: 1, control_type: 0 })
  end

  RSpec::Matchers.define :the_opponent do |sid:, character:, control_type:|
    match do |actual|
      matcher = have_attributes(
        opponent_sid: sid,
        opponent_character: character,
        opponent_control_type: control_type
      )

      matcher = matcher.and(@stats) if @stats.present?

      matcher.matches?(actual)
    end

    chain(:with_stats) do |stats|
      @stats = have_attributes(
        {
          wins: stats[:w],
          loses: stats[:l],
          total: stats[:t],
          score: stats[:s]
        }
      )
    end
  end

  describe '#favorites' do
    it 'returns the most played opponents' do
      expect(rivals.favorites(3)).to contain_exactly(
        the_opponent(sid: 999, character: 1, control_type: 0).with_stats(w: 18, l: 0, t: 18, s: 18),
        the_opponent(sid: 444, character: 3, control_type: 1).with_stats(w: 9, l: 9, t: 20, s: 0),
        the_opponent(sid: 222, character: 1, control_type: 0).with_stats(w: 8, l: 2, t: 10, s: 6)
      )
    end
  end

  describe '#tormentors' do
    it 'returns the opponents that won the most' do
      expect(rivals.tormentors(3)).to contain_exactly(
        the_opponent(sid: 666, character: 3, control_type: 0).with_stats(w: 0, l: 8, t: 8, s: -8),
        the_opponent(sid: 777, character: 2, control_type: 0).with_stats(w: 1, l: 6, t: 7, s: -5),
        the_opponent(sid: 444, character: 3, control_type: 1).with_stats(w: 9, l: 9, t: 20, s: 0)
      )
    end
  end

  describe '#victims' do
    it 'returns the opponents that lost the most' do
      expect(rivals.victims(3)).to contain_exactly(
        the_opponent(sid: 999, character: 1, control_type: 0).with_stats(w: 18, l: 0, t: 18, s: 18),
        the_opponent(sid: 333, character: 2, control_type: 1).with_stats(w: 7, l: 0, t: 7, s: 7),
        the_opponent(sid: 222, character: 1, control_type: 0).with_stats(w: 8, l: 2, t: 10, s: 6)
      )
    end
  end
end
