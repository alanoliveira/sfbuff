module DeviceDetection
  extend ActiveSupport::Concern

  class_methods do
    def forbidden_for_bots(**)
      before_action(**) do
        head :forbidden if user_is_a_bot?
      end
    end
  end

  def device_detector
    @device_detector ||= DeviceDetector.new(request.user_agent)
  end

  def user_is_a_bot?
    device_detector.bot?
  end
end
