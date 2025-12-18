class WorkerStreamsChannel < ApplicationCable::Channel
  extend Turbo::Streams::Broadcasts, Turbo::Streams::StreamName
  include Turbo::Streams::StreamName::ClassMethods

  def subscribed
    model_gid = verified_stream_name_from_params

    worker_broadcaster = GlobalID.find(model_gid)
    return reject unless worker_broadcaster&.is_a?(WorkerBroadcaster) && worker_broadcaster.accept_subscription?

    worker_broadcaster.run_callbacks :worker_channel_subscribed do
      stream_from model_gid, coder: ActiveSupport::JSON do |message|
        transmit message
        stop_stream_from model_gid
      end
    end
  end
end
