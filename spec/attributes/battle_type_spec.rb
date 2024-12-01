require "rails_helper"
require_relative "a_enum_attribute"

RSpec.describe BattleType do
  it_behaves_like "a enum attribute"
end
