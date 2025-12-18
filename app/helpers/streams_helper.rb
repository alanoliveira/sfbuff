module StreamsHelper
  def worker_stream_from(*, **, &)
    turbo_stream_from *, channel: "WorkerStreamsChannel", **, &
  end
end
