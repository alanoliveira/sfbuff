module ModalVariant
  extend ActiveSupport::Concern

  class_methods do
    def determine_modal_variant(**)
      before_action -> { request.variant = :modal if turbo_frame_request_id == "modal" }, **
    end
  end
end
