module DefaultPlayedAtRange
  extend ActiveSupport::Concern

  included do
    before_action do
      played_from = params[:played_from].to_date rescue Date.today - 1.week
      played_to = params[:played_to].to_date rescue Date.today
      params.merge!(
        played_from: played_from,
        played_to: played_to
      )
    end
  end
end
