# frozen_string_literal: true

RSpec::Matchers.define :have_xpath do |xpath|
  match { |subject| Nokogiri::HTML(subject).xpath(xpath).any? }
end

RSpec::Matchers.define :match_xpath do |xpath|
  match { |subject| values_match?(@with, Nokogiri::HTML(subject).xpath(xpath).to_s) }
  chain(:with) { @with = _1 }
end

RSpec::Matchers.define :have_turbo_stream do |action: nil, target: nil|
  match do |subject|
    properties = []
    properties << "@action='#{action}'" if action.present?
    properties << "@target='#{target}'" if target.present?
    xpath = %(//turbo-stream[#{properties.join(' and ')}])
    Nokogiri::HTML(subject).xpath(xpath).any?
  end
end
RSpec::Matchers.alias_matcher :a_turbo_stream, :have_turbo_stream

RSpec::Matchers.define :render_stream_source do |channel|
  match do |subject|
    values_match?(have_xpath("//turbo-cable-stream-source[@channel='#{channel}']"), subject)
  end
  failure_message { "not contains the stream source '#{channel}'" }
  failure_message_when_negated { "body should not contains the stream source '#{channel}'" }
end
