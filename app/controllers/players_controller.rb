class PlayersController < ApplicationController
  include DefaultPlayedAtRange
  include MatchupsActions

  before_action :set_player, except: :index
  before_action :synchronize_player, except: :index, unless: -> { @player.synchronized? }

  layout "with_header_footer", only: :index

  def index
    @job_id = PlayerSearchJob.perform_later(params[:q]).job_id if params.key? :q if trustable?
  end

  def cache_store
    super.with_options version: @player.cache_key_with_version, expires_in: 5.minutes
  end

  def battles
    super filter_matchups(:short_id, :character, :control_type, :vs_character,
      :vs_control_type, :played_from, :played_to, :battle_type)
  end

  def rivals
    super filter_matchups(:short_id, :character, :control_type, :vs_character,
      :vs_control_type, :played_from, :played_to, :battle_type)
  end

  def matchup_chart
    super filter_matchups(:short_id, :character, :control_type,
      :played_from, :played_to, :battle_type)
  end

  def ranked
    params.with_defaults!(character: @player.main_character)
    @ranked_history = RankedHistory.new(
      short_id: params[:short_id], character: params[:character],
      played_at: (params[:played_from].beginning_of_day..params[:played_to].end_of_day)
    )
  end

  private

  def set_player
    @player = Player.find_or_initialize_by(short_id: params[:short_id])
  end

  def synchronize_player
    @synchronize_job_id = PlayerSynchronizeJob.perform_later(@player.short_id).job_id if trustable?
  end
end
