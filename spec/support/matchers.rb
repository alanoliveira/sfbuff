# frozen_string_literal: true

RSpec::Matchers.define :match_xpath do |xpath|
  match { |subject| Nokogiri::HTML(subject).xpath(xpath).any? }
end
