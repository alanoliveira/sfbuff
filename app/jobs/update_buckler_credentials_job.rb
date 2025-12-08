class UpdateBucklerCredentialsJob < ApplicationJob
  limits_concurrency key: name, to: 1
  queue_as :default

  def perform
    begin
      test_connection
    rescue BucklerApiClient::Unauthorized, BucklerApiClient::PageNotFound => error
      Rails.logger.info("reseting credentials due: #{error.class.name}")
      AppSetting.buckler_auth_cookie = nil
      AppSetting.buckler_build_id = nil
    end

    renew_buckler_build_id if AppSetting.buckler_build_id.blank?
    renew_buckler_auth_cookie if AppSetting.buckler_auth_cookie.blank?
  end

  private

  def test_connection
    BucklerApiClient.new(
      build_id: AppSetting.buckler_build_id,
      auth_cookie: AppSetting.buckler_auth_cookie
    ).friends
  end

  def renew_buckler_build_id
    next_data = BucklerSiteClient.new.next_data
    AppSetting.buckler_build_id = next_data["buildId"]
  end

  def renew_buckler_auth_cookie
    AppSetting.buckler_auth_cookie = BucklerAuthenticator.new.login
  end
end
