# frozen_string_literal: true

RSpec::Matchers.define :have_turbo_stream do |action: nil, target: nil|
  match do |subject|
    properties = []
    properties << "@action='#{action}'" if action.present?
    properties << "@target='#{target}'" if target.present?
    xpath = %(//turbo-stream[#{properties.join(' and ')}])
    values_match?(have_xpath(xpath), subject)
  end
end
RSpec::Matchers.alias_matcher :a_turbo_stream, :have_turbo_stream

RSpec::Matchers.define :have_stream_source do |channel|
  match do |subject|
    values_match?(have_element('turbo-cable-stream-source'), subject)
  end
  failure_message { "not contains the stream source '#{channel}'" }
  failure_message_when_negated { "body should not contains the stream source '#{channel}'" }
end

RSpec::Matchers.define :have_battle_statistic do |w: nil, l: nil, d: nil|
  match do |subject|
    ok = true
    ok &&= values_match?(w, subject.wins)
    ok &&= values_match?(l, subject.loses)
    ok &&= values_match?(d, subject.draws)
    @group.try { ok &&= a_hash_including(**_1).matches? subject.group }
    ok
  end
  chain(:with_group) { |group| @group = group.stringify_keys }
end
RSpec::Matchers.alias_matcher :a_battle_statistic, :have_battle_statistic
