Rails.application.config.after_initialize do
  Rails.application.executor.to_complete do
    BucklerApiGateway.reset_thread_instance
  end
end
