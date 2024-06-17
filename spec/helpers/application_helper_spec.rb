# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#page_title' do
    subject(:page_title) { helper.page_title('hello') }

    it { expect(page_title.to_s).to have_xpath('//h1[text()="hello"]') }
    it { expect { helper.page_title('hello') }.to change { helper.content_for(:title) }.to('hello') }
  end

  describe '#head_title' do
    subject(:head_title) { helper.head_title }

    context 'when there is not content_for :title' do
      it { is_expected.to have_xpath('//title[text()="SFBUFF"]') }
    end

    context 'when there is content_for :title' do
      before { helper.content_for(:title) { 'hello' } }

      it { is_expected.to have_xpath('//title[text()="SFBUFF - hello"]') }
    end
  end

  describe '#nav_link' do
    subject(:nav_link) { helper.nav_link('foo', '/foo') }

    it { is_expected.to have_xpath('//a[@class="nav-link" and @href="/foo"]') }

    context 'when it is the current page' do
      before { allow(helper).to receive(:current_page?).with('/foo').and_return(true) }

      it { is_expected.to have_xpath('//a[@class="nav-link active" and @href="/foo"]') }
    end
  end
end
