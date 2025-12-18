module WorkerBroadcaster
  extend ActiveSupport::Concern

  included do
    define_callbacks :worker_channel_subscribed
  end

  class_methods do
    def before_subscribe(*methods, &block)
      set_callback :worker_channel_subscribed, :before, *methods, &block
    end

    def after_subscribe(*methods, &block)
      set_callback :worker_channel_subscribed, :after, *methods, &block
    end
  end

  # template method
  def accept_subscription?
    true
  end
end
