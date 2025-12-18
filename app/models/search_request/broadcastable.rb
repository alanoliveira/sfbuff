module SearchRequest::Broadcastable
  extend ActiveSupport::Concern
  include WorkerBroadcaster

  included do
    after_subscribe :process_later!, if: :created?
    after_save_commit :broadcast_replace_later, if: :finished?
  end
end
