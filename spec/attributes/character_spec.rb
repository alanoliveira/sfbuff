require "rails_helper"
require_relative "a_enum_attribute"

RSpec.describe Character do
  it_behaves_like "a enum attribute"
end
