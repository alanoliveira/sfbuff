class UpdateBucklerCredentialsJob < ApplicationJob
  queue_as :default

  def perform
    BucklerApiClient.new(build_id: (AppSetting.buckler_build_id || "undefined"), auth_cookie: AppSetting.buckler_auth_cookie).friends
  rescue BucklerApiClient::PageNotFound
    renew_buckler_build_id
    retry_job if executions == 1
  rescue BucklerApiClient::Unauthorized
    renew_buckler_auth_cookie
    raise
  end

  private

  def renew_buckler_build_id
    next_data = BucklerSiteClient.new.next_data
    AppSetting.buckler_build_id = next_data["buildId"]
  end

  def renew_buckler_auth_cookie
    AppSetting.buckler_auth_cookie = BucklerAuthenticator.new.login
  end
end
