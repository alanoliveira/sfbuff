class JobChannel < Turbo::StreamsChannel
  alias_method :job_id, :verified_stream_name_from_params

  periodically :broadcast_cached, every: 2.seconds
  after_subscribe :broadcast_cached

  def subscribed
    return reject unless Rails.cache.exist? "job/#{job_id}"
    stream_from job_id
  end

  private

  def broadcast_cached
    if result = Rails.cache.read("job/#{job_id}")
      JobChannel.broadcast_replace_to(job_id, target: job_id, **result)
    end
  end
end
