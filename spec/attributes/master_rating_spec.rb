require "rails_helper"
require_relative "a_numeric_attribute"

RSpec.describe MasterRating do
  it_behaves_like "a numeric attribute"
end
