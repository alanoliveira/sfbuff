# frozen_string_literal: true

namespace :sfbuff do
  desc 'perform login on buckler server'
  task buckler_login: :environment do
    BucklerLoginJob.perform_now
  end
end
