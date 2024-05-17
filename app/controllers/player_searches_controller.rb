# frozen_string_literal: true

class PlayerSearchesController < ApplicationController
  # GET /buckler/player_searches/:id
  def show
    @result = PlayerSearchJob.find_job_status!(params[:id])
    return head :accepted if @result[:status] == :waiting

    render
  rescue JobCache::NotFound
    redirect_to root_url
  end

  # POST /buckler/player_searches
  def create
    term = params.fetch(:term)
    return head :unprocessable_entity if term.length < 4

    @job = PlayerSearchJob.perform_later(term)
  end
end
