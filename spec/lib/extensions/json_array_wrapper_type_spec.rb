require 'rails_helper'

RSpec.describe JsonArrayWrapperType do
  let(:wrapper) { described_class.new ActiveRecord::Type.lookup(:integer) }

  it { expect(wrapper.serialize([ 1, 2 ])).to eq "[1,2]" }
  it { expect(wrapper.deserialize("[1,2]")).to eq [ 1, 2 ] }
  it { expect(wrapper.serialize(nil)).to be_nil }
  it { expect(wrapper.deserialize(nil)).to be_nil }
end
