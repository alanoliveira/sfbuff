# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayersController::BattlesAction do
  let(:action) do
    described_class.new(
      ActionController::Parameters.new(described_class.model_name.param_key => params),
      player_sid: mic[:player_sid]
    )
  end

  describe '#battles' do
    subject(:battles) { action.battles }

    let(:mic) { { player_sid: generate(:player_sid), name: 'mic' } }
    let(:raf) { { player_sid: generate(:player_sid), name: 'raf' } }

    before do
      create(:battle, :ranked, played_at: 1.day.ago,
                               p1: mic.merge({ character: 5, control_type: 0 }),
                               p2: raf.merge({ character: 4, control_type: 1 }))
      create(:battle, :custom_room, played_at: 3.days.ago,
                                    p1: mic.merge({ character: 6, control_type: 1 }),
                                    p2: raf.merge({ character: 3, control_type: 0 }))
    end

    context 'when player_character is set' do
      let(:params) { { player_character: 5 } }

      it 'returns only battles using the character' do
        expect(battles).to have_attributes(count: 1)
      end
    end

    context 'when player_control_type is set' do
      let(:params) { { player_control_type: 1 } }

      it 'returns only battles using the control_type' do
        expect(battles).to have_attributes(count: 1)
      end
    end

    context 'when opponent_character is set' do
      let(:params) { { opponent_character: 3 } }

      it 'returns only battles using the character' do
        expect(battles).to have_attributes(count: 1)
      end
    end

    context 'when opponent_control_type is set' do
      let(:params) { { opponent_control_type: 1 } }

      it 'returns only battles using the control_type' do
        expect(battles).to have_attributes(count: 1)
      end
    end

    context 'when battle_type is set' do
      let(:params) { { battle_type: 1 } }

      it 'returns only battles using the battle_type' do
        expect(battles).to have_attributes(count: 1)
      end
    end
  end
end
