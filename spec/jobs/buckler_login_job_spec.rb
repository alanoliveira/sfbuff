require 'rails_helper'

RSpec.describe BucklerLoginJob, type: :job do
  before do
    allow(BucklerClient).to receive(:take).and_return(buckler_client)
    allow(Buckler::Api::Login).to receive(:run).and_return('cookie=chocolate')
    allow(Buckler::Api::Client).to receive(:remote_build_id)
    ENV['BUCKLER_EMAIL'] = 'foo'
    ENV['BUCKLER_PASSWORD'] = 'bar'
  end

  let(:buckler_client) { BucklerClient.new }

  it 'updates the BucklerClient cookie' do
    expect { described_class.perform_now }.to change(buckler_client, :cookies).to('cookie=chocolate')
  end
end
