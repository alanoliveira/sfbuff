# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BucklerHelper do
  include_context('with locale', :en)

  describe '#character' do
    it { expect(helper.character(:ryu)).to eq('Ryu') }
    it { expect(helper.character(2)).to eq('Luke') }
    it { expect(helper.character(:iori)).to be_nil }
    it { expect(helper.character(999)).to be_nil }
  end

  describe '#control_type' do
    it { expect(helper.control_type(:modern)).to eq('M') }
    it { expect(helper.control_type(1)).to eq('M') }
    it { expect(helper.control_type(:smart)).to be_nil }
    it { expect(helper.control_type(999)).to be_nil }

    context 'with long format' do
      it { expect(helper.control_type(:modern, format: :long)).to eq('Modern') }
      it { expect(helper.control_type(1, format: :long)).to eq('Modern') }
      it { expect(helper.control_type(:smart, format: :long)).to be_nil }
      it { expect(helper.control_type(999, format: :long)).to be_nil }
    end
  end

  describe '#battle_type' do
    it { expect(helper.battle_type(:ranked)).to eq('Ranked') }
    it { expect(helper.battle_type(1)).to eq('Ranked') }
    it { expect(helper.battle_type(:smart)).to be_nil }
    it { expect(helper.battle_type(999)).to be_nil }
  end

  describe '#round_result' do
    it { expect(helper.round_result(:p)).to eq('p') }
    it { expect(helper.round_result(1)).to eq('v') }
    it { expect(helper.round_result(:dm)).to eq('dm') }
    it { expect(helper.round_result(999)).to be_nil }
  end
end
