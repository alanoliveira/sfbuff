module ApplicationCable
  class JobTurboStreamsChannel < Turbo::StreamsChannel
    def self.inherited(base)
      base.cattr_reader :target, default: base.name.underscore.dasherize
    end

    def self.broadcast_action_to(*, **opts)
      opts[:target] ||= target
      super(*, **opts)
    end

    def subscribed
      @job_id = create_job.job_id
      stream_from @job_id
    end

    def unsubscribed
      stop_stream_from(@job_id)
    end
  end
end
