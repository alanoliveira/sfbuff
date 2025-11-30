class UpdateBucklerCredentialsJob < ApplicationJob
  queue_as :default

  def perform
    BucklerApiClient.new(build_id: AppSetting.buckler_build_id, auth_cookie: AppSetting.buckler_auth_cookie).friends
  rescue BucklerApiClient::PageNotFound
    renew_buckler_build_id
  rescue BucklerApiClient::Unauthorized
    # TODO
    raise
  end

  private

  def renew_buckler_build_id
    next_data = BucklerSiteClient.new.next_data
    AppSetting.buckler_build_id = next_data["buildId"]
    retry_job if executions == 1
  end
end
