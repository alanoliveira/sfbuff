module TurboStreamsHelper
  def turbo_stream_toast(...)
    turbo_stream.append(toasts_container_id, toast_message(...))
  end
end
