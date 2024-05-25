# frozen_string_literal: true

RSpec::Matchers.define :contain_xpath do |xpath|
  match { |subject| Nokogiri::HTML(subject).xpath(xpath).any? }
end

RSpec::Matchers.define :match_xpath do |xpath|
  match { |subject| values_match?(@with, Nokogiri::HTML(subject).xpath(xpath).to_s) }
  chain(:with) { @with = _1 }
end
