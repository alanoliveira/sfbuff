# frozen_string_literal: true

RSpec.shared_context 'with locale' do |locale|
  around do |example|
    I18n.with_locale(locale) do
      example.run
    end
  end
end
