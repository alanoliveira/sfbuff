class BucklerCredential::RefreshBuildIdJob < ApplicationJob
  queue_as :urgent

  def perform(buckler_credential)
    new_build_id = BucklerApi::NextData.new.build_id
    buckler_credential.set_build_id! new_build_id
  end
end
